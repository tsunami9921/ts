-- Maded by Tsubasa

-- SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Teams = game:GetService("Teams")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- RAYFIELD
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "TsurenStudios | SLS",
    LoadingTitle = "TsurenStudios",
    LoadingSubtitle = "Made by Tsubasa ♥️",
    Theme = "Light"
})

-- UTILS
local function GetBall()
    local misc = Workspace:FindFirstChild("Misc")
    return misc and misc:FindFirstChild("Football")
end

local function GetHRP()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function GetHumanoid()
    local c = LocalPlayer.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function getGoal(team)
    local s = Workspace:FindFirstChild("Stadium")
    if not s then return end
    local ts = s:FindFirstChild("Teams")
    if not ts then return end
    local t = ts:FindFirstChild(team)
    if not t then return end
    return t:FindFirstChild("Goal")
end

--================ HOTKEY CONTROLLER (FULL) =================

local Hotkeys = {
    Fly = Enum.KeyCode.F,           -- Fly Aç / Kapat
    AutoFarm = Enum.KeyCode.G,      -- Auto Farm Aç / Kapat
    Reach = Enum.KeyCode.R           -- Reach Aç / Kapat
}

local States = {
    Fly = false,
    AutoFarm = false,
    Reach = false
}

local HotkeyEvents = {
    Fly = Instance.new("BindableEvent"),
    AutoFarm = Instance.new("BindableEvent"),
    Reach = Instance.new("BindableEvent")
}

-- Genel Hotkey Connect
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end

    -- Fly / AutoFarm / Reach
    for name, key in pairs(Hotkeys) do
        if input.KeyCode == key then
            States[name] = not States[name]
            HotkeyEvents[name]:Fire(States[name])

            Rayfield:Notify({
                Title = "Hotkey",
                Content = name.." : "..(States[name] and "ENABLED" or "DISABLED"),
                Duration = 2
            })
        end
    end

    -- Diğer Hotkeyler
    -- Bring Ball
    if input.KeyCode == Enum.KeyCode.B then
        local ball, hrp = GetBall(), GetHRP()
        if ball and hrp then
            ball.CFrame = hrp.CFrame * CFrame.new(0,0,-4)
            ball.AssemblyLinearVelocity = Vector3.zero
        end
    end

    -- Freeze Ball
    if input.KeyCode == Enum.KeyCode.N then
        freezeBall = not freezeBall
        Rayfield:Notify({
            Title="Freeze Ball",
            Content=freezeBall and "ENABLED" or "DISABLED",
            Duration=2
        })
    end

    -- Home Goal Hitbox
    if input.KeyCode == Enum.KeyCode.H then
        goalEnabledHome = not goalEnabledHome
        applyGoal("Home", goalEnabledHome)
    end

    -- Away Goal Hitbox
    if input.KeyCode == Enum.KeyCode.J then
        goalEnabledAway = not goalEnabledAway
        applyGoal("Away", goalEnabledAway)
    end

    -- Through Barriers
    if input.KeyCode == Enum.KeyCode.K then
        charThrough = not charThrough
        updateCollision()
        setBarriersCollision(charThrough)
    end

    -- Infinite Stamina
    if input.KeyCode == Enum.KeyCode.L and StaminaController then
        staminaOn = not staminaOn
        StaminaController.HasInfiniteStamina:set(staminaOn)
    end

    -- FPS Toggle
    if input.KeyCode == Enum.KeyCode.P then
        setFPS(not fpsEnabled)
    end
end)

--================ HOTKEY EVENTS CONNECT =================

-- Fly Event
HotkeyEvents.Fly.Event:Connect(function(v)
    flyEnabled = v
    if v then startFly() else stopFly() end
end)

-- AutoFarm Event
HotkeyEvents.AutoFarm.Event:Connect(function(v)
    autoFarmEnabled = v
end)

-- Reach Event
HotkeyEvents.Reach.Event:Connect(function(v)
    trollReach = v
    LolReach = v
    newReachEnabled = v
end)

--================ PRIVATE SERVER (KNIT) =================
local Knit = require(ReplicatedStorage.Packages.Knit)
local PrivateServerService
pcall(function() PrivateServerService = Knit.GetService("PrivateServersService") end)

local function joinPrivateServerSafe(code)
    if not code or code == "" then
        Rayfield:Notify({Title = "Error", Content = "Private server code is empty!", Duration = 3})
        return
    end
    if not PrivateServerService then
        Rayfield:Notify({Title = "Error", Content = "PrivateServersService not found!", Duration = 3})
        return
    end
    local ok, result = pcall(function()
        return PrivateServerService.RF.JoinPrivateServer:InvokeServer(code)
    end)
    if ok then
        Rayfield:Notify({Title = "Private Server", Content = "Join request sent successfully.", Duration = 3})
    else
        warn("JoinPrivateServer failed:", result)
        Rayfield:Notify({Title = "Error", Content = "Join private server failed.", Duration = 3})
    end
end

--================ WELCOME TAB =================
local WelcomeTab = Window:CreateTab("Welcome","home")
WelcomeTab:CreateLabel("Welcome to TsurenStudios Hub!")
WelcomeTab:CreateLabel("Credit by Tsubasa | SLS")
WelcomeTab:CreateLabel("Use responsibly. This script modifies gameplay features.")
WelcomeTab:CreateParagraph({
    Title = "TsurenStudios | SLS Hub",
    Content = "Features included:\n- Auto Farm & Auto Goal\n- Player Reach & Movement Modifiers\n- Ball Controls & Freeze\n- Team & Position Management\n- Weather Effects\n- Server Tools (Teleport, Private Server, Rejoin, Server Hop)\n- Advanced Barrier Collision Fixes"
})

-- Stats
local coinsLabel = WelcomeTab:CreateParagraph({Title="Coins", Content="Loading..."})
local lvlLabel   = WelcomeTab:CreateParagraph({Title="Level", Content="Loading..."})
local xpLabel    = WelcomeTab:CreateParagraph({Title="XP", Content="Loading..."})

--================ MAIN TAB =================
local tMain = Window:CreateTab("Main", "layers")
local autoFarmEnabled = false
local autoFarmCooldown = 0.6
local lastFarmTick = 0

tMain:CreateToggle({Name = "Auto Farm (Safe)", CurrentValue=false, Callback=function(v) autoFarmEnabled=v end})
tMain:CreateSlider({Name = "Farm Cooldown (sec)", Range={0.3,2}, Increment=0.05, CurrentValue=autoFarmCooldown, Callback=function(v) autoFarmCooldown=v end})

local function isBallMine(ball)
    if not ball then return false end
    local ok, owner = pcall(function() return ball:GetNetworkOwner() end)
    if ok and owner == LocalPlayer then return true end
    local hrp = GetHRP()
    if hrp and (ball.Position - hrp.Position).Magnitude < 6 then return true end
    return false
end

--================ PLAYERS TAB =================
local tPlayers = Window:CreateTab("Players", "users")
local fpsEnabled = false
local fpsLabel

local function setFPS(v)
    fpsEnabled = v
    local gui = LocalPlayer:FindFirstChild("PlayerGui")
    if not gui then return end

    if v and not fpsLabel then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FPSGui"
        screenGui.Parent = gui

        fpsLabel = Instance.new("TextLabel")
        fpsLabel.Name = "FPSLabel"
        fpsLabel.Size = UDim2.new(0,100,0,30)
        fpsLabel.Position = UDim2.new(0,10,0,10)
        fpsLabel.BackgroundTransparency = 0.4
        fpsLabel.BackgroundColor3 = Color3.fromRGB(0,0,0)
        fpsLabel.TextColor3 = Color3.fromRGB(255,255,255)
        fpsLabel.TextScaled = true
        fpsLabel.Text = "FPS: 0"
        fpsLabel.Parent = screenGui
    elseif not v and fpsLabel then
        fpsLabel.Parent:Destroy()
        fpsLabel = nil
    end
end

-- Toggle UI
tPlayers:CreateToggle({
    Name="Show FPS (F7)",
    CurrentValue=false,
    Callback=setFPS
})

-- Keybind F7
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F7 then
        setFPS(not fpsEnabled)
    end
end)

-- Update FPS every frame
RunService.RenderStepped:Connect(function(dt)
    if fpsEnabled and fpsLabel then
        local fps = math.floor(1/dt)
        fpsLabel.Text = "FPS: "..fps
    end
end)
local Stats = game:GetService("Stats")
local PingValue = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
local pingMs = math.floor(PingValue)
local PingLabel = tPlayers:CreateLabel("Ping:")

task.spawn(function()
    while task.wait(1) do
        local ok, ping = pcall(function()
            return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
        end)

        if ok and PingLabel then
            local pingStr = "Ping: "..math.floor(ping).." ms"
            if ping < 80 then
                pingStr = pingStr.." 🟢"
            elseif ping < 150 then
                pingStr = pingStr.." 🟡"
            else
                pingStr = pingStr.." 🔴"
            end

     PingLabel:Set(pingStr)
        end
    end
end)


--================ FLY (SAFE / ANTI-KICK) =================

local flyEnabled = false
local flySpeed = 60
local flyConn = nil

local function startFly()
    local hrp = GetHRP()
    local hum = GetHumanoid()
    if not hrp or not hum then return end

    -- güvenli fizik
    hum:ChangeState(Enum.HumanoidStateType.Physics)

    -- varsa eskiyi sil
    for _,v in pairs(hrp:GetChildren()) do
        if v:IsA("BodyVelocity") and v.Name == "FlyVelocity" then
            v:Destroy()
        end
    end

    local bv = Instance.new("BodyVelocity")
    bv.Name = "FlyVelocity"
    bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
    bv.P = 2000
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    flyConn = RunService.RenderStepped:Connect(function()
        if not flyEnabled or not hrp or not hum then return end

        local cam = workspace.CurrentCamera
        local moveDir = hum.MoveDirection
        local vel = Vector3.zero

        -- ileri / sağ / sol
        vel += cam.CFrame.LookVector * moveDir.Z * flySpeed
        vel += cam.CFrame.RightVector * moveDir.X * flySpeed

        -- yukarı / aşağı
        if UIS:IsKeyDown(Enum.KeyCode.Space) then
            vel += Vector3.new(0, flySpeed * 0.6, 0)
        elseif UIS:IsKeyDown(Enum.KeyCode.LeftShift) then
            vel -= Vector3.new(0, flySpeed * 0.6, 0)
        else
            vel += Vector3.new(0, -4, 0) -- süzülme (kick-safe)
        end

        -- aşırı yükselme koruması
        if hrp.Position.Y > 130 then
            vel = Vector3.new(vel.X, -8, vel.Z)
        end

        bv.Velocity = vel
    end)
end

local function stopFly()
    flyEnabled = false

    if flyConn then
        flyConn:Disconnect()
        flyConn = nil
    end

    local hrp = GetHRP()
    local hum = GetHumanoid()

    if hrp then
        for _,v in pairs(hrp:GetChildren()) do
            if v:IsA("BodyVelocity") and v.Name == "FlyVelocity" then
                v:Destroy()
            end
        end
    end

    if hum then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
end

--================ UI =================

tPlayers:CreateToggle({
    Name = "Fly (Bugs / Anti Kick)",
    CurrentValue = false,
    Callback = function(v)
        flyEnabled = v
        if v then
            startFly()
        else
            stopFly()
        end
    end
})

tPlayers:CreateSlider({
    Name = "Fly Speed",
    Range = {20,120},
    Increment = 5,
    CurrentValue = flySpeed,
    Callback = function(v)
        flySpeed = v
    end
})

--================ HOTKEY (F) =================
HotkeyEvents.Fly.Event:Connect(function(v)
    flyEnabled = v
    if v then
        startFly()
    else
        stopFly()
    end
end)


tPlayers:CreateSlider({Name="WalkSpeed", Range={16,200}, Increment=1, CurrentValue=16, Callback=function(v)
    local h=GetHumanoid()
    if h then h.WalkSpeed=v end
end})
tPlayers:CreateSlider({Name="JumpPower", Range={50,200}, Increment=1, CurrentValue=50, Callback=function(v)
    local h=GetHumanoid()
    if h then h.JumpPower=v end
end})

-- Through Barriers fix
local charThrough=false
local function updateCollision()
    local char=LocalPlayer.Character
    if char then
        local hrp=char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CanCollide=not charThrough end
        local ball=GetBall()
        if ball then ball.CanCollide=not charThrough end
    end
end

tPlayers:CreateToggle({Name="Through Barriers", CurrentValue=false, Callback=function(v) charThrough=v updateCollision() end})

-- Infinite Stamina
local StaminaController
pcall(function() StaminaController=Knit.GetController("StaminaController") end)
local SharedInterfaceStates=require(ReplicatedStorage.Shared.SharedInterfaceStates)
local Movement=require(ReplicatedStorage.Shared.Defaults.Movement)
local staminaOn=false
local staminaConn
if StaminaController then
    tPlayers:CreateToggle({Name="Infinite Stamina (F6)", CurrentValue=false, Callback=function(v)
        staminaOn=v
        StaminaController.HasInfiniteStamina:set(v)
        if v then
            staminaConn=RunService.Heartbeat:Connect(function()
                SharedInterfaceStates.Stamina.Amount:set(Movement.Stamina.Maximum)
            end)
        else
            if staminaConn then staminaConn:Disconnect() staminaConn=nil end
        end
    end})
end
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.F6 and StaminaController then
        staminaOn=not staminaOn
        StaminaController.HasInfiniteStamina:set(staminaOn)
    end
end)

--==================================================
-- PACK TAB
--==================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.Knit)
local PacksService = Knit.GetService("PacksService")

local PacksData = require(ReplicatedStorage.Shared.Defaults.Packs)

-- Pack list
local PackTypes = {}
for name,_ in pairs(PacksData.ItemData) do
    table.insert(PackTypes, name)
end
table.sort(PackTypes)

-- State
local SelectedPack = PackTypes[1]
local AutoBuy = false
local Buying = false

-- Buy func
local function BuyPack()
    if Buying then return end
    Buying = true

    pcall(function()
        PacksService:ProcessPurchase(SelectedPack, "Coins")
    end)

    task.wait(1.2)
    Buying = false
end

-- Auto loop
task.spawn(function()
    while task.wait(2) do
        if AutoBuy and not Buying then
            BuyPack()
        end
    end
end)

-- UI
local PacksTab = Window:CreateTab("Packs", "shopping-cart")

PacksTab:CreateDropdown({
    Name = "Pack",
    Options = PackTypes,
    CurrentOption = SelectedPack,
    Callback = function(v)
        if type(v) == "table" then
            SelectedPack = v[1]
        else
            SelectedPack = v
        end
    end
})

PacksTab:CreateButton({
    Name = "Buy Pack",
    Callback = function()
        BuyPack()
    end
})

PacksTab:CreateToggle({
    Name = "Auto Buy",
    CurrentValue = false,
    Callback = function(v)
        AutoBuy = v
    end
})


--================ ANIMATIONS / DANCE TAB =================
local tAnim = Window:CreateTab("Animations / Dances","star")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = char:WaitForChild("Humanoid")

-- Animasyonlar listesi
local animations = {
    -- Direct Animations from ReplicatedStorage
    {name="Sui", path=ReplicatedStorage.Assets.Animations.Other.Sui},
    {name="Orange Dance", path=ReplicatedStorage.Assets.Items.Celebrations["Orange Dance"]},

    -- Diğerler id ve isim listesi
    {id="133596366979822", name="Biblically Accurate Emote - ⭐"},
    {id="118995435851830", name="God Mode Awakening🔥  - ⭐"},
    {id="114833623647442", name="Headless Football - ⭐"},
    {id="109755476052324", name="IShowSpeed Dance - ⭐"},
    {id="139890185302092", name='CR7 CELEBRATION "SIUU" - ⭐'},
    {id="137529866280376", name="Chrollo - Legendary T Pose - ⭐"},
    {id="111241337069546", name="[ Content Deleted ] - ⭐"},
    {id="90980126975445", name="Aura Farming Sit(Profile Pose) - ⭐"},
    {id="106640307740815", name="[👋] Nah - Handshake - ⭐"},
    {id="132074413582912", name="California Girl Dance [OG] - ⭐"},
    {id="121020540386418", name="Sorry, sorry, SORRY! - ⭐"},
    {id="100282947534083", name="Iron's Repulsor Flight - ⭐"},
    {id="109585245141415", name="Iron Man rebuild - ⭐"},
    {id="111209446991587", name="Spider - ⭐"},
    {id="82999087084315", name="Scary Entity - ⭐"},
    {id="139973403632033", name="Corrupted Scary Entity Mutation - ⭐"},
    {id="102610758906338", name="Possessed - ⭐"},
    {id="83169082048183", name='Mr "ant" Tenna Jumpscare - Deltarune - ⭐'},
    {id="85143829531506", name="Japanese Apology Bow - ⭐"},
    {id="99068367180942", name="Michael Myers Bounce - ⭐"},
    {id="101848273620506", name="Become a car: Convertible - ⭐"},
    {id="139537277486789", name="💪One Hand Push Ups - ⭐"},
    {id="126168053681827", name="Akaza Hakuji Fighting Stance - ⭐"}
}

-- Animasyon oynatma fonksiyonu
local function playAnimation(anim)
    if anim.path then
        -- ReplicatedStorage içindeki animation objesi
        local track = Humanoid:LoadAnimation(anim.path)
        track:Play()
    elseif anim.id then
        -- ID ile animation oluştur
        local animation = Instance.new("Animation")
        animation.AnimationId = "rbxassetid://"..anim.id
        local track = Humanoid:LoadAnimation(animation)
        track:Play()
    end
end

-- Butonları ekleme
for _, anim in pairs(animations) do
    tAnim:CreateButton({
        Name = anim.name,
        Callback = function()
            playAnimation(anim)
        end
    })
end


--==================================================
-- TEAM + POSITION TAB
--==================================================

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Knit = require(ReplicatedStorage.Packages.Knit)

-- Controller
local TeamController
pcall(function()
    TeamController = Knit.GetController("TeamController")
end)

-- Positions
local Positions = {
    "GK","CB","LB","RB",
    "CM","CDM","CAM",
    "LW","RW","CF","ST"
}

-- State
local SelectedTeam = "Home"
local SelectedPos = Positions[1]
local AutoJoin = false

-- Join Team func
local function JoinTeam(teamName)
    pcall(function()
        if TeamController and TeamController.JoinTeam then
            TeamController:JoinTeam(teamName)
        else
            LocalPlayer.Team = Teams:FindFirstChild(teamName)
        end
    end)
end

-- Set Position func
local function SetPosition(pos)
    pcall(function()
        if TeamController and TeamController.SetPosition then
            TeamController:SetPosition(pos)
        end
    end)

    -- fallback attribute
    LocalPlayer:SetAttribute("TeamPosition", pos)
end

-- Auto Apply loop
task.spawn(function()
    while task.wait(2) do
        if AutoJoin then
            JoinTeam(SelectedTeam)
            task.wait(0.3)
            SetPosition(SelectedPos)
        end
    end
end)

-- UI
local TeamTab = Window:CreateTab("Team", "users")

TeamTab:CreateDropdown({
    Name = "Select Team",
    Options = {"Home","Away"},
    CurrentOption = SelectedTeam,
    Callback = function(v)
        if type(v) == "table" then
            SelectedTeam = v[1]
        else
            SelectedTeam = v
        end
    end
})

TeamTab:CreateDropdown({
    Name = "Select Position",
    Options = Positions,
    CurrentOption = SelectedPos,
    Callback = function(v)
        if type(v) == "table" then
            SelectedPos = v[1]
        else
            SelectedPos = v
        end
    end
})

TeamTab:CreateButton({
    Name = "Apply Now",
    Callback = function()
        JoinTeam(SelectedTeam)
        task.wait(0.3)
        SetPosition(SelectedPos)
    end
})

TeamTab:CreateToggle({
    Name = "Auto Join + Auto Position",
    CurrentValue = false,
    Callback = function(v)
        AutoJoin = v
    end
})

--================ BALL TAB =================
local tBall=Window:CreateTab("Ball","circle")
local freezeBall=false
local normalVel=60
tBall:CreateButton({Name="Bring Ball", Callback=function()
    local ball,hrp=GetBall(),GetHRP()
    if ball and hrp then
        ball.CFrame=hrp.CFrame*CFrame.new(0,0,-4)
        ball.AssemblyLinearVelocity=Vector3.zero
    end
end})
tBall:CreateButton({Name="Velocity Normal", Callback=function()
    local ball,hrp=GetBall(),GetHRP()
    if ball and hrp then ball.AssemblyLinearVelocity=hrp.CFrame.LookVector*normalVel end
end})
tBall:CreateButton({Name="Velocity Troll", Callback=function()
    local ball,hrp=GetBall(),GetHRP()
    if ball and hrp then ball.AssemblyLinearVelocity=hrp.CFrame.LookVector*55+Vector3.new(0,35,0) end
end})
tBall:CreateSlider({Name="Normal Velocity Power", Range={20,100}, Increment=1, CurrentValue=normalVel, Callback=function(v) normalVel=v end})
tBall:CreateToggle({Name="Freeze Ball", CurrentValue=false, Callback=function(v) freezeBall=v end})

--================ GAME TAB =================
local tGame=Window:CreateTab("Game","play")

-- Oyun Temel Bilgiler
local productInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local gameName = productInfo.Name or "Unknown"
local gameId = game.PlaceId
local jobId = game.JobId
local creator = productInfo.Creator and productInfo.Creator.Name or "Unknown"

-- Oyun Başlangıç Zamanı
local serverStartTime = tick()

-- Paragraphlar
local gameNameLabel = tGame:CreateParagraph({Title="Game Name", Content=gameName})
local gameIdLabel = tGame:CreateParagraph({Title="Game ID", Content=tostring(gameId)})
local jobIdLabel = tGame:CreateParagraph({Title="Server ID", Content=jobId})
local creatorLabel = tGame:CreateParagraph({Title="Creator", Content=creator})
local playerCountLabel = tGame:CreateParagraph({Title="Player Count", Content=tostring(#Players:GetPlayers())})
local serverTimeLabel = tGame:CreateParagraph({Title="Server Uptime", Content="0s"})
local gameTimeLabel = tGame:CreateParagraph({Title="Game Time (since join)", Content="0s"})

-- Update Server Info / Player Count / Times
RunService.Heartbeat:Connect(function()
    -- Player count
    playerCountLabel:Set({Title="Player Count", Content=tostring(#Players:GetPlayers())})
    -- Server Uptime
    local uptime = tick() - serverStartTime
    local mins = math.floor(uptime/60)
    local secs = math.floor(uptime%60)
    serverTimeLabel:Set({Title="Server Uptime", Content=string.format("%dm %ds", mins, secs)})
    -- Game Time
    local gameElapsed = os.time() - os.time() + (tick()-serverStartTime) -- basit olarak tick farkı
    gameTimeLabel:Set({Title="Game Time", Content=string.format("%dm %ds", mins, secs)})
end)

--================ REACH =================
local tReach=Window:CreateTab("Reach","refresh-cw")
local trollReach=false
local trollDist=18
local newReachEnabled=false
local newReachPart
local LolReach=false
local normalDist=8
tReach:CreateToggle({Name="Troll Reach (V2)", CurrentValue=false, Callback=function(v) trollReach=v end})
tReach:CreateToggle({Name="NormalReach (V1)", CurrentValue=false, Callback=function(v) LolReach=v end})
tReach:CreateToggle({Name="New Reach", CurrentValue=false, Callback=function(v) newReachEnabled=v if not v and newReachPart then newReachPart:Destroy() newReachPart=nil end end})

--================ WEATHER =================
local tWeather=Window:CreateTab("Weather","cloud-rain")
local rainEnabled=false
tWeather:CreateToggle({Name="Rain", CurrentValue=false, Callback=function(v)
    rainEnabled=v
    local WeatherState=require(ReplicatedStorage.Shared.SharedInterfaceStates).Player.Preferences.Weather
    WeatherState:set(v and "Rain" or "Clear")
end})

--================ GOAL TAB FIX =================
local tGoal = Window:CreateTab("Goal Setting", "target")
local goalEnabledHome = false
local goalEnabledAway = false

local goalOriginalSize = Vector3.new(31.327, 11.277, 8.339)
local goalBigSize = Vector3.new(281, 149.13, 50)

local function applyGoal(team, state)
    local goal = Workspace:FindFirstChild("Stadium") 
                and Workspace.Stadium:FindFirstChild("Teams") 
                and Workspace.Stadium.Teams:FindFirstChild(team) 
                and Workspace.Stadium.Teams[team]:FindFirstChild("Goal")
    if not goal then return end
    local hitbox = goal:FindFirstChild("Hitbox")
    if not hitbox then return end

    if state then
        hitbox.Size = goalBigSize
        hitbox.Color = Color3.fromRGB(0,140,255)
        hitbox.Transparency = 0.5
        hitbox.Material = Enum.Material.Neon
    else
        hitbox.Size = goalOriginalSize
        hitbox.Transparency = 0
        hitbox.Material = Enum.Material.Plastic
    end
end

-- Toggle for Home Goal
tGoal:CreateToggle({
    Name = "Enable Home Goal Hitbox",
    CurrentValue = false,
    Callback = function(v)
        goalEnabledHome = v
        applyGoal("Home", goalEnabledHome)
    end
})

-- Toggle for Away Goal
tGoal:CreateToggle({
    Name = "Enable Away Goal Hitbox",
    CurrentValue = false,
    Callback = function(v)
        goalEnabledAway = v
        applyGoal("Away", goalEnabledAway)
    end
})
--================ SERVER =================
local tServer=Window:CreateTab("Server","server")
local inputGameId=""
local inputServerId=""
local privateCode=""
tServer:CreateInput({Name="Private Server Code", PlaceholderText="Enter private server code", Callback=function(v) privateCode=v end})
tServer:CreateButton({Name="Join Private Server", Callback=function() joinPrivateServerSafe(privateCode) end})
tServer:CreateInput({Name="Game ID", PlaceholderText="Enter Game ID", Callback=function(v) inputGameId=v end})
tServer:CreateInput({Name="Server ID", PlaceholderText="Enter Server ID", Callback=function(v) inputServerId=v end})
tServer:CreateButton({Name="Teleport", Callback=function() if inputGameId~="" and inputServerId~="" then TeleportService:TeleportToPlaceInstance(tonumber(inputGameId), inputServerId, LocalPlayer) end end})
tServer:CreateButton({Name="Rejoin", Callback=function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end})
tServer:CreateButton({Name="Server Hop", Callback=function()
    local data=HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100"))
    if data and data.data and #data.data>0 then
        local s=data.data[math.random(#data.data)]
        TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
    end
end})

--================ ADVANCED FIXES =================
local function setBarriersCollision(state)
    local field = Workspace:FindFirstChild("Stadium") and Workspace.Stadium:FindFirstChild("Field")
    if field then
        local barriers = field:FindFirstChild("Barriers")
        if barriers then
            for _, obj in pairs(barriers:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.CanCollide = not state
                end
            end
        end
    end
    local blockPart = Workspace:FindFirstChild("Environment")
        and Workspace.Environment:FindFirstChild("StadiumBuilding")
        and Workspace.Environment.StadiumBuilding:FindFirstChild("StadiumNeons")
        and Workspace.Environment.StadiumBuilding.StadiumNeons:FindFirstChild("Part")
    if blockPart then
        blockPart.CanCollide = true
    end
end

tPlayers:CreateToggle({
    Name="Through All Barriers",
    CurrentValue=false,
    Callback=function(v)
        charThrough=v
        updateCollision()
        setBarriersCollision(v)
    end
})

--================ HEARTBEAT / MAIN LOOP =================
local delta=0
local autoGoalEnabled=false
local autoGoalTeam="Home"
local autoGoalDelay=0.6
local lastGoalTick=0
local lastFarmTick=0

RunService.Heartbeat:Connect(function(dt)
    delta=dt
    local ball=GetBall()
    local hrp=GetHRP()
    local char=LocalPlayer.Character

    -- AUTO FARM
    if autoFarmEnabled and tick()-lastFarmTick>autoFarmCooldown and ball and hrp and char and isBallMine(ball) then
        local dir=(ball.Position-hrp.Position)
        if dir.Magnitude>3 then
            hrp.CFrame=hrp.CFrame:Lerp(CFrame.new(ball.Position-dir.Unit*2),0.25)
        else
            ball.CFrame=hrp.CFrame*CFrame.new(0,0,-2.8)
            ball.AssemblyLinearVelocity=Vector3.zero
        end
        lastFarmTick=tick()
    end

    -- AUTO GOAL
    if autoGoalEnabled and tick()-lastGoalTick>=autoGoalDelay then
        local goal=getGoal(autoGoalTeam)
        if ball and goal then
            ball.CFrame=goal.CFrame+Vector3.new(0,3,0)
            ball.AssemblyLinearVelocity=Vector3.zero
            lastGoalTick=tick()
        end
    end

    -- Freeze Ball
    if ball then ball.Anchored=freezeBall end

    -- Stats Update
    local gui=LocalPlayer.PlayerGui:FindFirstChild("GameGui")
    if gui then
        local stats=gui.LobbyHUD.Topbar.Leaderstats
        coinsLabel:Set({Title="Coins", Content=stats.Coins.Container.Amount.Text})
        lvlLabel:Set({Title="Level", Content=stats.Experience.Container.Amount.Text})
        xpLabel:Set({Title="XP", Content=stats.Experience.Container.Other.Text})
    end

    -- Troll Reach
    if trollReach and ball and hrp and (ball.Position - hrp.Position).Magnitude <= trollDist then
        ball.AssemblyLinearVelocity = hrp.CFrame.LookVector * 35
    end

    -- Normal Reach (V1)
    if LolReach and ball and hrp and (ball.Position - hrp.Position).Magnitude <= normalDist then
        ball.AssemblyLinearVelocity = Vector3.zero
        ball.CFrame = hrp.CFrame * CFrame.new(0,0,-3)
    end

    -- New Reach Visual
if newReachEnabled and hrp and char then
    if not newReachPart then
        newReachPart = Instance.new("Part")
        newReachPart.Size = Vector3.new(27,27,27)
        newReachPart.Transparency = 0.7
        newReachPart.Anchored = true
        newReachPart.CanCollide = false
        newReachPart.Material = Enum.Material.Neon
        newReachPart.Color = Color3.fromRGB(255,0,0)
        newReachPart.Parent = Workspace -- Parent Workspace to avoid issues
    end
    newReachPart.CFrame = hrp.CFrame
  end
end)
