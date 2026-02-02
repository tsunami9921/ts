local StarterScripts = game:GetService("StarterPlayer").StarterPlayerScripts

-- LocalScript yarat
local WindController = Instance.new("LocalScript")
WindController.Name = "WindController"
WindController.Parent = StarterScripts

-- WindLines ModuleScript
local WindLines = Instance.new("ModuleScript")
WindLines.Name = "WindLines"
WindLines.Source =
local module = {}

local RunService = game:GetService("RunService")
local Terrain = workspace:FindFirstChildOfClass("Terrain")

local EMPTY_TABLE = {}
local OFFSET = Vector3.new(0,0.1,0)

module.UpdateQueue = table.create(10)

function module:Init(Settings)
    self.Lifetime = Settings.Lifetime or 3
    self.Direction = Settings.Direction or Vector3.new(1,0,0)
    self.Speed = Settings.Speed or 6

    -- Eğer önceden bağlanmış bir update varsa kapat
    if self.UpdateConnection then
        self.UpdateConnection:Disconnect()
    end

    -- Her Heartbeat'de update et
    self.UpdateConnection = RunService.Heartbeat:Connect(function()
        local Clock = os.clock()
        for i = #module.UpdateQueue, 1, -1 do
            local WindLine = module.UpdateQueue[i]
            local AliveTime = Clock - WindLine.StartClock
            if AliveTime >= WindLine.Lifetime then
                WindLine.Attachment0:Destroy()
                WindLine.Attachment1:Destroy()
                WindLine.Trail:Destroy()
                table.remove(module.UpdateQueue, i)
            else
                local SeededClock = (Clock + WindLine.Seed) * (WindLine.Speed * 0.2)
                local StartPos = WindLine.Position
                WindLine.Attachment0.WorldPosition = (CFrame.new(StartPos, StartPos + WindLine.Direction) * CFrame.new(0,0,WindLine.Speed*-AliveTime)).Position +
                    Vector3.new(math.sin(SeededClock)*0.5, math.sin(SeededClock)*0.8, math.sin(SeededClock)*0.5)
                WindLine.Attachment1.WorldPosition = WindLine.Attachment0.WorldPosition + OFFSET
            end
        end
    end)
end

function module:Create(Settings)
    Settings = Settings or EMPTY_TABLE
    local Lifetime = Settings.Lifetime or module.Lifetime
    local Position = Settings.Position or (workspace.CurrentCamera.CFrame*CFrame.Angles(math.rad(math.random(-30,70)),math.rad(math.random(-80,80)),0))*CFrame.new(0,0,math.random(200,600)*-0.1).Position
    local Direction = Settings.Direction or module.Direction
    local Speed = Settings.Speed or module.Speed
    if Speed <= 0 then return end

    local Attachment0 = Instance.new("Attachment")
    local Attachment1 = Instance.new("Attachment")
    local Trail = Instance.new("Trail")

    Trail.Attachment0 = Attachment0
    Trail.Attachment1 = Attachment1
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.3),
        NumberSequenceKeypoint.new(0.2,1),
        NumberSequenceKeypoint.new(0.8,1),
        NumberSequenceKeypoint.new(1,0.3)
    })
    Trail.Transparency = NumberSequence.new(0.7)
    Trail.FaceCamera = true
    Trail.Parent = Attachment0

    Attachment0.WorldPosition = Position
    Attachment1.WorldPosition = Position + OFFSET

    module.UpdateQueue[#module.UpdateQueue+1] = {
        Attachment0 = Attachment0,
        Attachment1 = Attachment1,
        Trail = Trail,
        Lifetime = Lifetime + (math.random(-10,10)*0.1),
        Position = Position,
        Direction = Direction,
        Speed = Speed + (math.random(-10,10)*0.1),
        StartClock = os.clock(),
        Seed = math.random(1,1000)*0.1
    }

    Attachment0.Parent = Terrain
    Attachment1.Parent = Terrain
end

return module
WindLines.Parent = WindController


local WindShake = Instance.new("ModuleScript")
WindShake.Name = "WindShake"
WindShake.Source =
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local Settings = require(script.Settings)
local Octree = require(script.Octree)

local COLLECTION_TAG = "WindShake" -- Tag ile otomatik takip
local UPDATE_HZ = 1/45 -- 45 Hz’de güncelle
local COMPUTE_HZ = 1/30 -- 30 Hz’de hesapla

local DEFAULT_SETTINGS = Settings.new(script, {
    WindDirection = Vector3.new(0.5,0,0.5);
    WindSpeed = 20;
    WindPower = 0.5;
})

local ObjectShakeAddedEvent = Instance.new("BindableEvent")
local ObjectShakeRemovedEvent = Instance.new("BindableEvent")
local ObjectShakeUpdatedEvent = Instance.new("BindableEvent")
local PausedEvent = Instance.new("BindableEvent")
local ResumedEvent = Instance.new("BindableEvent")

local WindShake = {
    ObjectMetadata = {};
    Octree = Octree.new();
    Handled = 0;
    Active = 0;
    LastUpdate = os.clock();

    ObjectShakeAdded = ObjectShakeAddedEvent.Event;
    ObjectShakeRemoved = ObjectShakeRemovedEvent.Event;
    ObjectShakeUpdated = ObjectShakeUpdatedEvent.Event;
    Paused = PausedEvent.Event;
    Resumed = ResumedEvent.Event;
}

-- Bağlantı yardımcı fonksiyonu
function WindShake:Connect(funcName, event)
    local callback = self[funcName]
    assert(typeof(callback) == "function", "Unknown function: "..funcName)
    return event:Connect(function(...)
        return callback(self,...)
    end)
end

-- Obje ekleme
function WindShake:AddObjectShake(object, settingsTable)
    if not (typeof(object) == "Instance" and object:IsA("BasePart")) then return end
    if self.ObjectMetadata[object] then return end

    self.Handled += 1
    self.ObjectMetadata[object] = {
        Node = self.Octree:CreateNode(object.Position, object);
        Settings = Settings.new(object, DEFAULT_SETTINGS);
        Seed = math.random(1000)*0.1;
        Origin = object.CFrame;
    }

    self:UpdateObjectSettings(object, settingsTable)
    ObjectShakeAddedEvent:Fire(object)
end

-- Obje kaldırma
function WindShake:RemoveObjectShake(object)
    local objMeta = self.ObjectMetadata[object]
    if objMeta then
        self.Handled -= 1
        self.ObjectMetadata[object] = nil
        objMeta.Settings:Destroy()
        objMeta.Node:Destroy()
        if object:IsA("BasePart") then
            object.CFrame = objMeta.Origin
        end
        ObjectShakeRemovedEvent:Fire(object)
    end
end

-- Update fonksiyonu (heartbeat ile)
function WindShake:Update()
    local now = os.clock()
    local dt = now - self.LastUpdate
    if dt < UPDATE_HZ then return end
    self.LastUpdate = now

    local camera = workspace.CurrentCamera
    local cameraCF = camera and camera.CFrame

    local updateObjects = self.Octree:RadiusSearch(cameraCF.Position + cameraCF.LookVector*115, 120)
    local activeCount = #updateObjects
    self.Active = activeCount
    if activeCount < 1 then return end

    local step = math.min(1, dt*8)
    local cfTable = table.create(activeCount)
    for i, object in ipairs(updateObjects) do
        local objMeta = self.ObjectMetadata[object]
        local lastComp = objMeta.LastCompute or 0
        local origin = objMeta.Origin
        local current = objMeta.CFrame or origin

        if (now - lastComp) > COMPUTE_HZ then
            local objSettings = objMeta.Settings
            local seed = objMeta.Seed
            local amp = objSettings.WindPower * 0.1
            local freq = now * (objSettings.WindSpeed*0.08)
            local rotX = math.noise(freq,0,seed)*amp
            local rotY = math.noise(freq,0,-seed)*amp
            local rotZ = math.noise(freq,0,seed+seed)*amp
            local offset = object.PivotOffset
            local worldpivot = origin * offset
            objMeta.Target = (worldpivot * CFrame.Angles(rotX,rotY,rotZ) + objSettings.WindDirection*((0.5+math.noise(freq,seed,seed))*amp)) * offset:Inverse()
            objMeta.LastCompute = now
        end

        current = current:Lerp(objMeta.Target, step)
        objMeta.CFrame = current
        cfTable[i] = current
    end

    workspace:BulkMoveTo(updateObjects, cfTable, Enum.BulkMoveMode.FireCFrameChanged)
end

function WindShake:Pause()
    if self.UpdateConnection then
        self.UpdateConnection:Disconnect()
        self.UpdateConnection = nil
    end
    self.Active = 0
    self.Running = false
    PausedEvent:Fire()
end

function WindShake:Resume()
    if self.Running then return end
    self.Running = true
    self.UpdateConnection = self:Connect("Update", RunService.Heartbeat)
    ResumedEvent:Fire()
end

function WindShake:Init()
    if self.Initialized then return end
    self.Initialized = true

    -- Attributes kontrolü
    if typeof(script:GetAttribute("WindPower")) ~= "number" then
        script:SetAttribute("WindPower", DEFAULT_SETTINGS.WindPower)
    end
    if typeof(script:GetAttribute("WindSpeed")) ~= "number" then
        script:SetAttribute("WindSpeed", DEFAULT_SETTINGS.WindSpeed)
    end
    if typeof(script:GetAttribute("WindDirection")) ~= "Vector3" then
        script:SetAttribute("WindDirection", DEFAULT_SETTINGS.WindDirection)
    end

    -- Temizlik
    self:Cleanup()

    -- Tag ile objeleri ekle
    self.AddedConnection = self:Connect("AddObjectShake", CollectionService:GetInstanceAddedSignal(COLLECTION_TAG))
    self.RemovedConnection = self:Connect("RemoveObjectShake", CollectionService:GetInstanceRemovedSignal(COLLECTION_TAG))
    for _, object in pairs(CollectionService:GetTagged(COLLECTION_TAG)) do
        self:AddObjectShake(object)
    end

    self:Resume()
end

function WindShake:Cleanup()
    if not self.Initialized then return end
    self:Pause()
    if self.AddedConnection then self.AddedConnection:Disconnect(); self.AddedConnection = nil end
    if self.RemovedConnection then self.RemovedConnection:Disconnect(); self.RemovedConnection = nil end
    table.clear(self.ObjectMetadata)
    self.Octree:ClearNodes()
    self.Handled = 0
    self.Active = 0
    self.Initialized = false
end

function WindShake:UpdateObjectSettings(object, settingsTable)
    if typeof(object) ~= "Instance" or typeof(settingsTable) ~= "table" then return end
    if not self.ObjectMetadata[object] and object ~= script then return end
    for key, value in pairs(settingsTable) do
        object:SetAttribute(key, value)
    end
    ObjectShakeUpdatedEvent:Fire(object)
end

function WindShake:UpdateAllObjectSettings(settingsTable)
    if typeof(settingsTable) ~= "table" then return end
    for obj, objMeta in pairs(self.ObjectMetadata) do
        for key, value in pairs(settingsTable) do
            obj:SetAttribute(key, value)
        end
        ObjectShakeUpdatedEvent:Fire(obj)
    end
end

function WindShake:SetDefaultSettings(settingsTable)
    self:UpdateObjectSettings(script, settingsTable)
end

return WindShake
]]
WindShake.Parent = WindController

-- Settings ModuleScript WindShake içinde
local Settings = Instance.new("ModuleScript")
Settings.Name = "Settings"
Settings.Source =
local Settings = {}

local SettingTypes = {
    WindPower = "number";
    WindSpeed = "number";
    WindDirection = "Vector3";
}

function Settings.new(object, base)
    local inst = {}

    -- Başlangıç değerleri
    local WindPower = object:GetAttribute("WindPower")
    local WindSpeed = object:GetAttribute("WindSpeed")
    local WindDirection = object:GetAttribute("WindDirection")

    inst.WindPower = typeof(WindPower) == SettingTypes.WindPower and WindPower or base.WindPower
    inst.WindSpeed = typeof(WindSpeed) == SettingTypes.WindSpeed and WindSpeed or base.WindSpeed
    inst.WindDirection = typeof(WindDirection) == SettingTypes.WindDirection and WindDirection or base.WindDirection

    -- Attribute değişikliklerini dinle
    local PowerConnection = object:GetAttributeChangedSignal("WindPower"):Connect(function()
        local newPower = object:GetAttribute("WindPower")
        inst.WindPower = typeof(newPower) == SettingTypes.WindPower and newPower or base.WindPower
    end)

    local SpeedConnection = object:GetAttributeChangedSignal("WindSpeed"):Connect(function()
        local newSpeed = object:GetAttribute("WindSpeed")
        inst.WindSpeed = typeof(newSpeed) == SettingTypes.WindSpeed and newSpeed or base.WindSpeed
    end)

    local DirectionConnection = object:GetAttributeChangedSignal("WindDirection"):Connect(function()
        local newDir = object:GetAttribute("WindDirection")
        inst.WindDirection = typeof(newDir) == SettingTypes.WindDirection and newDir or base.WindDirection
    end)

    -- Temizlik fonksiyonu
    function inst:Destroy()
        PowerConnection:Disconnect()
        SpeedConnection:Disconnect()
        DirectionConnection:Disconnect()
        table.clear(inst)
    end

    return inst
end

return Settings
Settings.Parent = WindShake

-- Octree ModuleScript WindShake içinde
local Octree = Instance.new("ModuleScript")
Octree.Name = "Octree"
Octree.Source =
local Octree = {}
Octree.__index = Octree

local OctreeNode = require(script:WaitForChild("OctreeNode"))
local OctreeRegionUtils = require(script:WaitForChild("OctreeRegionUtils"))

local EPSILON = 1e-9
local SQRT_3_OVER_2 = math.sqrt(3) / 2
local SUB_REGION_POSITION_OFFSET = {
    {0.25, 0.25, -0.25};
    {-0.25, 0.25, -0.25};
    {0.25, 0.25, 0.25};
    {-0.25, 0.25, 0.25};
    {0.25, -0.25, -0.25};
    {-0.25, -0.25, -0.25};
    {0.25, -0.25, 0.25};
    {-0.25, -0.25, 0.25};
}

function Octree.new()
    local self = setmetatable({
        MaxDepth = 4;
        MaxRegionSize = {512, 512, 512};
        RegionHashMap = {};
    }, Octree)
    return self
end

function Octree:ClearNodes()
    self.RegionHashMap = {}
end

function Octree:GetAllNodes()
    local nodes = {}
    for _, regionList in pairs(self.RegionHashMap) do
        for _, region in ipairs(regionList) do
            for node in pairs(region.Nodes) do
                table.insert(nodes, node)
            end
        end
    end
    return nodes
end

function Octree:CreateNode(Position, Object)
    assert(typeof(Position) == "Vector3", "Bad position value")
    assert(Object, "Bad object value")
    local node = OctreeNode.new(self, Object)
    node:SetPosition(Position)
    return node
end

function Octree:RadiusSearch(Position, Radius)
    assert(typeof(Position) == "Vector3", "Bad position value")
    assert(type(Radius) == "number", "Bad radius value")
    local PositionX, PositionY, PositionZ = Position.X, Position.Y, Position.Z
    local ObjectsFound, NodeDistances2 = {}, {}
    local Diameter = self.MaxRegionSize[1]
    local SearchRadius = Radius + SQRT_3_OVER_2 * Diameter
    local SearchRadiusSquared = SearchRadius * SearchRadius + EPSILON
    local RadiusSquared = Radius * Radius

    for _, regionList in pairs(self.RegionHashMap) do
        for _, region in ipairs(regionList) do
            local regionPos = region.Position
            local dx, dy, dz = PositionX - regionPos[1], PositionY - regionPos[2], PositionZ - regionPos[3]
            local dist2 = dx*dx + dy*dy + dz*dz
            if dist2 <= SearchRadiusSquared then
                OctreeRegionUtils.GetNeighborsWithinRadius(region, Radius, PositionX, PositionY, PositionZ, ObjectsFound, NodeDistances2, self.MaxDepth, #ObjectsFound, #NodeDistances2)
            end
        end
    end
    return ObjectsFound, NodeDistances2
end

local function GetOrCreateRegion(self, PositionX, PositionY, PositionZ)
    local CX = math.floor(PositionX / self.MaxRegionSize[1] + 0.5)
    local CY = math.floor(PositionY / self.MaxRegionSize[2] + 0.5)
    local CZ = math.floor(PositionZ / self.MaxRegionSize[3] + 0.5)
    local hash = CX * 73856093 + CY * 19351301 + CZ * 83492791
    local regionList = self.RegionHashMap[hash]
    if not regionList then
        regionList = {}
        self.RegionHashMap[hash] = regionList
    end

    local regionPosX = CX * self.MaxRegionSize[1]
    local regionPosY = CY * self.MaxRegionSize[2]
    local regionPosZ = CZ * self.MaxRegionSize[3]

    for _, region in ipairs(regionList) do
        if region.Position[1] == regionPosX and region.Position[2] == regionPosY and region.Position[3] == regionPosZ then
            return region
        end
    end

    local halfX, halfY, halfZ = self.MaxRegionSize[1]/2, self.MaxRegionSize[2]/2, self.MaxRegionSize[3]/2
    local newRegion = {
        Depth = 1;
        LowerBounds = {regionPosX - halfX, regionPosY - halfY, regionPosZ - halfZ};
        UpperBounds = {regionPosX + halfX, regionPosY + halfY, regionPosZ + halfZ};
        Nodes = {};
        SubRegions = {};
        Position = {regionPosX, regionPosY, regionPosZ};
        NodeCount = 0;
        Parent = nil;
        ParentIndex = nil;
        Size = {self.MaxRegionSize[1], self.MaxRegionSize[2], self.MaxRegionSize[3]};
    }
    table.insert(regionList, newRegion)
    return newRegion
end

function Octree:GetOrCreateLowestSubRegion(PositionX, PositionY, PositionZ)
    local current = GetOrCreateRegion(self, PositionX, PositionY, PositionZ)
    for _ = current.Depth, self.MaxDepth do
        local idx = PositionX > current.Position[1] and 1 or 2
        if PositionY <= current.Position[2] then idx += 4 end
        if PositionZ >= current.Position[3] then idx += 2 end
        local nextRegion = current.SubRegions[idx]
        if not nextRegion then
            local size = current.Size
            local multiplier = SUB_REGION_POSITION_OFFSET[idx]
            local newPos = {
                current.Position[1] + multiplier[1]*size[1],
                current.Position[2] + multiplier[2]*size[2],
                current.Position[3] + multiplier[3]*size[3]
            }
            local half = {size[1]/2, size[2]/2, size[3]/2}
            nextRegion = {
                Depth = current.Depth+1;
                LowerBounds = {newPos[1]-half[1], newPos[2]-half[2], newPos[3]-half[3]};
                UpperBounds = {newPos[1]+half[1], newPos[2]+half[2], newPos[3]+half[3]};
                Nodes = {};
                SubRegions = {};
                Position = newPos;
                NodeCount = 0;
                Parent = current;
                ParentIndex = idx;
                Size = {size[1]/2, size[2]/2, size[3]/2};
            }
            current.SubRegions[idx] = nextRegion
        end
        current = nextRegion
    end
    return current
end

return Octree
Octree.Parent = WindShake

-- Octree alt modüller
local OctreeNode = Instance.new("ModuleScript")
OctreeNode.Name = "OctreeNode"
OctreeNode.Source =
local OctreeNode = {}
OctreeNode.__index = OctreeNode

function OctreeNode.new(Octree, Object)
    assert(Octree, "No octree provided")
    assert(Object, "No object provided")
    local self = setmetatable({
        Octree = Octree;
        Object = Object;
        CurrentLowestRegion = nil;
        Position = nil;
        PositionX = nil;
        PositionY = nil;
        PositionZ = nil;
    }, OctreeNode)
    return self
end

function OctreeNode:GetObject()
    warn("OctreeNode:GetObject is deprecated.")
    return self.Object
end

function OctreeNode:GetPosition()
    warn("OctreeNode:GetPosition is deprecated.")
    return self.Position
end

function OctreeNode:GetRawPosition()
    return self.PositionX, self.PositionY, self.PositionZ
end

function OctreeNode:SetPosition(Position)
    if self.Position == Position then return end
    local PositionX, PositionY, PositionZ = Position.X, Position.Y, Position.Z
    self.PositionX, self.PositionY, self.PositionZ = PositionX, PositionY, PositionZ
    self.Position = Position

    if self.CurrentLowestRegion then
        local region = self.CurrentLowestRegion
        local lb, ub = region.LowerBounds, region.UpperBounds
        if PositionX >= lb[1] and PositionX <= ub[1] and
           PositionY >= lb[2] and PositionY <= ub[2] and
           PositionZ >= lb[3] and PositionZ <= ub[3] then
            return
        end
    end

    local NewLowestRegion = self.Octree:GetOrCreateLowestSubRegion(PositionX, PositionY, PositionZ)

    if self.CurrentLowestRegion then
        local From = self.CurrentLowestRegion
        if From == NewLowestRegion then return end
        local To = NewLowestRegion
        while From ~= To do
            local nodes = From.Nodes
            nodes[self] = nil
            From.NodeCount -= 1
            From = From.Parent
        end
        local current = NewLowestRegion
        while current do
            current.Nodes[self] = self
            current.NodeCount += 1
            current = current.Parent
        end
    else
        local current = NewLowestRegion
        while current do
            current.Nodes[self] = self
            current.NodeCount += 1
            current = current.Parent
        end
    end

    self.CurrentLowestRegion = NewLowestRegion
end

function OctreeNode:Destroy()
    local region = self.CurrentLowestRegion
    while region do
        region.Nodes[self] = nil
        region.NodeCount -= 1
        region = region.Parent
    end
end

function OctreeNode:RadiusSearch(Radius)
    return self.Octree:RadiusSearch(self.Position, Radius)
end

function OctreeNode:KNearestNeighborsSearch(K, Radius)
    return self.Octree:KNearestNeighborsSearch(self.Position, K, Radius)
end

return OctreeNode
OctreeNode.Parent = Octree

local OctreeRegionUtils = Instance.new("ModuleScript")
OctreeRegionUtils.Name = "OctreeRegionUtils"
OctreeRegionUtils.Source = 
local OctreeRegionUtils = {}

local EPSILON = 1e-6
local SQRT_3_OVER_2 = math.sqrt(3) / 2
local SUB_REGION_POSITION_OFFSET = {
    {0.25, 0.25, -0.25};
    {-0.25, 0.25, -0.25};
    {0.25, 0.25, 0.25};
    {-0.25, 0.25, 0.25};
    {0.25, -0.25, -0.25};
    {-0.25, -0.25, -0.25};
    {0.25, -0.25, 0.25};
    {-0.25, -0.25, 0.25};
}

-- Recursive search helper
local function GetNeighborsWithinRadius(Region, Radius, PositionX, PositionY, PositionZ, ObjectsFound, NodeDistances2, MaxDepth, ObjectsLength, DistancesLength)
    if not MaxDepth then error("Missing MaxDepth.") end
    local SearchRadius = Radius + SQRT_3_OVER_2 * (Region.Size[1]/2)
    local SearchRadiusSquared = SearchRadius*SearchRadius + EPSILON
    local RadiusSquared = Radius*Radius

    for _, ChildRegion in next, Region.SubRegions do
        local ChildPos = ChildRegion.Position
        local dx, dy, dz = PositionX - ChildPos[1], PositionY - ChildPos[2], PositionZ - ChildPos[3]
        local Distance2 = dx*dx + dy*dy + dz*dz
        if Distance2 <= SearchRadiusSquared then
            if ChildRegion.Depth == MaxDepth then
                for Node in next, ChildRegion.Nodes do
                    local nx, ny, nz = Node.PositionX, Node.PositionY, Node.PositionZ
                    local dx2, dy2, dz2 = nx - PositionX, ny - PositionY, nz - PositionZ
                    local NodeDist2 = dx2*dx2 + dy2*dy2 + dz2*dz2
                    if NodeDist2 <= RadiusSquared then
                        ObjectsLength += 1
                        DistancesLength += 1
                        ObjectsFound[ObjectsLength] = Node.Object
                        NodeDistances2[DistancesLength] = NodeDist2
                    end
                end
            else
                ObjectsLength, DistancesLength = GetNeighborsWithinRadius(ChildRegion, Radius, PositionX, PositionY, PositionZ, ObjectsFound, NodeDistances2, MaxDepth, ObjectsLength, DistancesLength)
            end
        end
    end

    return ObjectsLength, DistancesLength
end

OctreeRegionUtils.GetNeighborsWithinRadius = GetNeighborsWithinRadius

return OctreeRegionUtils
OctreeRegionUtils.Parent = Octree

print("WindController ve tüm modüller full Instance.new ile oluşturuldu!")


-- // Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterScripts = StarterPlayer.StarterPlayerScripts
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- // Rayfield Loadstring
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
end)

if not success then
    warn("Rayfield yüklenemedi!")
    return
end

-- // WindController Referansı
local WindController = StarterScripts:FindFirstChild("WindController")
if not WindController then
    warn("WindController bulunamadı!")
    return
end

-- require modüller
local WindLinesModule = require(WindController:WaitForChild("WindLines"))
local WindShakeModule = require(WindController:WaitForChild("WindShake"))

-- // Rayfield window
local Window = Rayfield:CreateWindow({
    Name = "Wind & Lighting Control",
    LoadingTitle = "Başlatılıyor...",
    LoadingSubtitle = "Wind ve Lighting Scriptleri",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "WindLightingConfig"
    }
})

-- // Wind toggle
local WindEnabled = false
Window:CreateToggle({
    Name = "Enable Wind",
    CurrentValue = false,
    Flag = "WindToggle",
    Callback = function(value)
        WindEnabled = value
        if WindEnabled then
            -- WindLines başlat
            WindLinesModule:Init({
                Lifetime = 3,
                Speed = 6,
                Direction = Vector3.new(1,0,0)
            })
            -- Örnek: her Heartbeat’de rastgele WindLine üret
            if not WindController:FindFirstChild("WindLoopConnection") then
                local loop = RunService.Heartbeat:Connect(function()
                    WindLinesModule:Create({
                        Speed = 6,
                        Direction = Vector3.new(1,0,0)
                    })
                end)
                loop.Name = "WindLoopConnection"
                loop.Parent = WindController
            end

            -- WindShake başlat
            WindShakeModule:Init()
            WindShakeModule:Resume()
            print("Wind aktif")
        else
            -- WindLines durdur
            if WindController:FindFirstChild("WindLoopConnection") then
                WindController.WindLoopConnection:Disconnect()
                WindController.WindLoopConnection:Destroy()
            end

            -- WindShake durdur
            WindShakeModule:Pause()
            print("Wind devre dışı")
        end
    end
})

-- // Lighting toggle
local LightingEnabled = false
Window:CreateToggle({
    Name = "Enable Lighting",
    CurrentValue = false,
    Flag = "LightingToggle",
    Callback = function(value)
        LightingEnabled = value
        if LightingEnabled then
            -- Efektleri ekle
            local Sun = Lighting:FindFirstChildOfClass("SunRaysEffect") or Instance.new("SunRaysEffect")
            Sun.Intensity = 0.25
            Sun.Parent = Lighting

            local Bloom = Lighting:FindFirstChildOfClass("BloomEffect") or Instance.new("BloomEffect")
            Bloom.Intensity = 1
            Bloom.Threshold = 0.5
            Bloom.Parent = Lighting

            local Sky = Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky")
            Sky.SkyboxUp = "rbxassetid://1234567"
            Sky.SkyboxDn = "rbxassetid://1234567"
            Sky.SkyboxLf = "rbxassetid://1234567"
            Sky.SkyboxRt = "rbxassetid://1234567"
            Sky.SkyboxFt = "rbxassetid://1234567"
            Sky.SkyboxBk = "rbxassetid://1234567"
            Sky.Parent = Lighting

            Lighting.GlobalShadows = true
            Lighting.ClockTime = 14
            Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
            print("Lighting aktif")
        else
            -- Efektleri temizle
            for _, child in pairs(Lighting:GetChildren()) do
                if child:IsA("SunRaysEffect") or child:IsA("BloomEffect") or child:IsA("Sky") then
                    child:Destroy()
                end
            end
            Lighting.GlobalShadows = false
            print("Lighting devre dışı")
        end
    end
})

print("Rayfield GUI hazır! Wind ve Lighting toggle edebilirsiniz.")
