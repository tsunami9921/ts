-- Maded by Tsubasa

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Teams = game:GetService("Teams")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local LoadingActive = false
local SoundService game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local function StartLoadingScreen()
	if LoadingActive then return end
	LoadingActive = true

	-- GUI
	local gui = Instance.new("ScreenGui")
	gui.Name = "LoadingScreen"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = PlayerGui

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromScale(1,1)
	bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
	bg.Parent = gui

	-- TITLE
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,0,0,80)
	title.Position = UDim2.new(0,0,0.05,0)
	title.BackgroundTransparency = 1
	title.Text = "TsurenStudios"
	title.TextColor3 = Color3.fromRGB(0,170,255)
	title.TextScaled = true
	title.Font = Enum.Font.GothamBold
	title.Parent = bg

	task.spawn(function()
		while gui.Parent do
			title.TextTransparency = 0
			task.wait(0.6)
			title.TextTransparency = 0.5
			task.wait(0.6)
		end
	end)

	-- CONSOLE
	local consoleFrame = Instance.new("Frame")
	consoleFrame.Size = UDim2.fromScale(0.6,0.45)
	consoleFrame.Position = UDim2.fromScale(0.2,0.3)
	consoleFrame.BackgroundColor3 = Color3.fromRGB(10,10,10)
	consoleFrame.BorderColor3 = Color3.fromRGB(0,255,0)
	consoleFrame.BorderSizePixel = 2
	consoleFrame.Parent = bg
	Instance.new("UICorner", consoleFrame).CornerRadius = UDim.new(0,8)

	local consoleText = Instance.new("TextLabel")
	consoleText.Size = UDim2.new(1,-10,1,-10)
	consoleText.Position = UDim2.new(0,5,0,5)
	consoleText.BackgroundTransparency = 1
	consoleText.TextXAlignment = Enum.TextXAlignment.Left
	consoleText.TextYAlignment = Enum.TextYAlignment.Top
	consoleText.TextWrapped = true
	consoleText.RichText = true
	consoleText.Text = ""
	consoleText.Font = Enum.Font.Code
	consoleText.TextSize = 18
	consoleText.TextColor3 = Color3.fromRGB(0,255,0)
	consoleText.Parent = consoleFrame

	local logs = {}
	local function addLog(msg)
		table.insert(logs, msg)
		if #logs > 20 then
			table.remove(logs,1)
		end
		consoleText.Text = table.concat(logs, "\n")
	end

	-- SAFE LOG
	if LogService then
		LogService.MessageOut:Connect(function(message)
			addLog("> "..message)
		end)
	end

	-- 🎵 MUSIC (FIXED)
	local music = Instance.new("Sound")
	music.SoundId = "rbxassetid://9045130736"
	music.Volume = 1
	music.Looped = false
	music.Parent = gui -- 🔥 GUI içine koyduk
	task.wait(0.2)
	music:Play()

	-- FAKE LOGS
	task.spawn(function()
		local fakeLogs = {
			"Initializing TsurenStudios Client...",
			"Loading assets...",
			"Checking environment...",
			"Mounting services...",
			"Preparing client...",
			"Finalizing..."
		}
		for _,v in ipairs(fakeLogs) do
			addLog(v)
			task.wait(1.2)
		end
	end)

	-- AFTER 16s
	task.delay(16, function()
		music:Stop()
		consoleFrame.Visible = false

		-- ❤️ HEART CONTAINER (SMALL)
		local heartFrame = Instance.new("Frame")
		heartFrame.Size = UDim2.fromScale(0.4,0.4) -- 👈 KÜÇÜK
		heartFrame.Position = UDim2.fromScale(0.3,0.3)
		heartFrame.BackgroundTransparency = 1
		heartFrame.Parent = bg

		local heart = Instance.new("TextLabel")
		heart.Size = UDim2.fromScale(1,1)
		heart.BackgroundTransparency = 1
		heart.TextColor3 = Color3.fromRGB(255,0,0)
		heart.TextScaled = false
		heart.TextSize = 18 -- 👈 BOYUT FIX
		heart.Font = Enum.Font.Code
		heart.TextXAlignment = Enum.TextXAlignment.Center
		heart.TextYAlignment = Enum.TextYAlignment.Center
		heart.Parent = heartFrame

		local heartPattern = {
			"0000110000110000",
			"0011111001111100",
			"0111111111111110",
			"1111111111111111",
			"1111111111111111",
			"0111111111111110",
			"0011111111111100",
			"0001111111111000",
			"0000111111110000",
			"0000011111100000",
			"0000001111000000",
			"0000000110000000",
		}

		local heartText = ""
		for _,line in ipairs(heartPattern) do
			for c in line:gmatch(".") do
				heartText ..= (c == "1" and "█" or " ")
			end
			heartText ..= "\n"
		end

		heart.Text = heartText

		-- CLOSE
		task.delay(3, function()
			local tween = TweenService:Create(bg, TweenInfo.new(1), {
				Position = UDim2.new(0,0,2,0)
			})
			tween:Play()
			tween.Completed:Connect(function()
				gui:Destroy()
				LoadingActive = false
			end)
		end)
	end)

	while LoadingActive do task.wait() end
end

StartLoadingScreen()
repeat task.wait() until not LoadingActive
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "TsurenStudios | SLS 🌸",
    LoadingTitle = "TsurenStudios",
    LoadingSubtitle = "Made by Tsubasa ♥️",
    Theme = "Bloom"
})


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

-- TeamModule
--local TeamModule = {}
--do
   -- local ReplicatedStorage = game:GetService("ReplicatedStorage")
   -- local TeamsService = game:GetService("Teams")
    --local LocalPlayer = game.Players.LocalPlayer

    
        --local teamList = {TeamsService:WaitForChild("Home"), TeamsService:WaitForChild("Away")}
        --local randomTeam = teamList[math.random(1, #teamList)]

        -- ReplicatedStorage üzerinden Join isteği
        --local RE = ReplicatedStorage:WaitForChild("__GamemodeComm"):WaitForChild("RE"):WaitForChild("_RequestJoin")
        -- RE:FireServer(randomTeam)
    -- end
-- end

local Hotkeys = {
    Fly = Enum.KeyCode.F,           
    AutoFarm = Enum.KeyCode.G,      
    Reach = Enum.KeyCode.R           
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


UIS.InputBegan:Connect(function(input, gp)
    if gp then return end


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

    
    if input.KeyCode == Enum.KeyCode.B then
        local ball, hrp = GetBall(), GetHRP()
        if ball and hrp then
            ball.CFrame = hrp.CFrame * CFrame.new(0,0,-4)
            ball.AssemblyLinearVelocity = Vector3.zero
        end
    end

     if input.KeyCode == Enum.KeyCode.N then
        freezeBall = not freezeBall
        Rayfield:Notify({
            Title="Freeze Ball",
            Content=freezeBall and "ENABLED" or "DISABLED",
            Duration=2
        })
    end

    
    if input.KeyCode == Enum.KeyCode.H then
        goalEnabledHome = not goalEnabledHome
        applyGoal("Home", goalEnabledHome)
    end

    if input.KeyCode == Enum.KeyCode.J then
        goalEnabledAway = not goalEnabledAway
        applyGoal("Away", goalEnabledAway)
    end

    
    if input.KeyCode == Enum.KeyCode.K then
        charThrough = not charThrough
        updateCollision()
        setBarriersCollision(charThrough)
    end

    
    if input.KeyCode == Enum.KeyCode.L and StaminaController then
        staminaOn = not staminaOn
        StaminaController.HasInfiniteStamina:set(staminaOn)
    end

    
    if input.KeyCode == Enum.KeyCode.P then
        setFPS(not fpsEnabled)
    end
end)

HotkeyEvents.Fly.Event:Connect(function(v)
    flyEnabled = v
    if v then startFly() else stopFly() end
end)


HotkeyEvents.AutoFarm.Event:Connect(function(v)
    autoFarmEnabled = v
end)


HotkeyEvents.Reach.Event:Connect(function(v)
    trollReach = v
    LolReach = v
    newReachEnabled = v
end)


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
local pointsLabel = WelcomeTab:CreateParagraph({Title="Points", Content="Loading..."})

-- TSURENMODULE
local TsurenModule = {}

function TsurenModule.FalseGoalHitbox()
    for _, player in game.Players:GetPlayers() do
        if player.Team ~= game.Players.LocalPlayer.Team and player.Team ~= nil then
            local enemyTeam = player.Team
            local goal = workspace:FindFirstChild("Stadium") and workspace.Stadium.Teams:FindFirstChild(enemyTeam.Name)
            if goal and goal:FindFirstChild("Goal") and goal.Goal:FindFirstChild("Hitbox") then
                goal.Goal.Hitbox.Size = Vector3.new(31.327,11.278,8.289)
            end
        end
    end
end


function TsurenModule.TrueAutoShoot()
    local ball = workspace:FindFirstChild("Misc") and workspace.Misc:FindFirstChild("Football")
    if not ball then return end

    local args = {
        "ShotActivated",
        ball,
        Vector3.new(ball.Position.X, ball.Position.Y, ball.Position.Z),
        Vector3.new(ball.Position.X + 5, ball.Position.Y + 1, ball.Position.Z + 5)
    }

    local ActionService = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0")
        :WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ActionService")
        :WaitForChild("RE"):WaitForChild("PerformAction")

    pcall(function()
        ActionService:FireServer(unpack(args))
    end)
end

function TsurenModule.TrueAutoGetBall()
    local player = game.Players.LocalPlayer
    for _, p in pairs(game.Players:GetPlayers()) do
        if p:GetAttribute("HasBall", false) and p.Team ~= player.Team and p:GetAttribute("TeamPosition") ~= "GK" then
            local character = player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then return end

            local originalCFrame = character.HumanoidRootPart.CFrame
            character:PivotTo(p.Character.HumanoidRootPart.CFrame)

            local tackleArgs = {"TackleActivated", 9999999999.99}
            local TackleRF = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
                :WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ActionService")
                :WaitForChild("RF"):WaitForChild("PerformActionThenGet")
            pcall(function()
                TackleRF:InvokeServer(unpack(tackleArgs))
                TackleRF:InvokeServer(unpack(tackleArgs))
                TackleRF:InvokeServer(unpack(tackleArgs))
            end)

            character:PivotTo(originalCFrame)
        end
    end
end

-- Top bizde mi kontrolü
local function HasBall()
    local ball = workspace:FindFirstChild("Misc") and workspace.Misc:FindFirstChild("Football")
    local player = game.Players.LocalPlayer
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not ball or not hrp then return false end

    local ok, owner = pcall(function() return ball:GetNetworkOwner() end)
    if ok and owner == player then
        return true
    end

    if (ball.Position - hrp.Position).Magnitude < 6 then
        return true
    end

    return false
end

local MainTab = Window:CreateTab("Main (New)","layers")

-- References
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Modules
local TsurenModule = TsurenModule -- yukarda zaten var

-- AutoFarm state
local AutoFarmEnabled = false

-- Notification Helper (CoreGui)
local function SendNotification(title, text, duration)
    duration = duration or 3
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration,
        Button1 = "OK"
    })
end

-- Check if player has ball
local function HasBall()
    return LocalPlayer:GetAttribute("HasBall") or false
end

-- Get player who has ball (rakip)
local function GetBallHolder()
    for _, p in pairs(Players:GetPlayers()) do
        if p:GetAttribute("HasBall") and p.Team ~= LocalPlayer.Team then
            return p
        end
    end
    return nil
end

-- AutoShoot fix: top pozisyonuna göre
local function AutoShoot()
    local ball = workspace:FindFirstChild("Misc") and workspace.Misc:FindFirstChild("Football")
    if not ball then return end

    local goalPos
    for _, pl in pairs(Players:GetPlayers()) do
        if pl.Team ~= LocalPlayer.Team and pl.Team ~= nil then
            local enemyGoal = workspace:FindFirstChild("Stadium") and workspace.Stadium.Teams:FindFirstChild(pl.Team.Name)
            if enemyGoal and enemyGoal:FindFirstChild("Goal") then
                goalPos = enemyGoal.Goal.Position
                break
            end
        end
    end
    if not goalPos then return end

    local args = {
        "ShotActivated",
        ball,
        ball.Position,
        goalPos + Vector3.new(0,5,0) -- biraz yukarıdan
    }

    local ActionService = ReplicatedStorage:WaitForChild("Packages")
        :WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0")
        :WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ActionService")
        :WaitForChild("RE"):WaitForChild("PerformAction")

    pcall(function()
        ActionService:FireServer(unpack(args))
    end)
end

-- Main AutoFarm loop
local function StartAutoFarm()
    -- Team kontrol
    if not LocalPlayer.Team then
        SendNotification("Auto Farm", "Join a Team First!", 3)
        return
    end

    SendNotification("Auto Farm", "Auto Farm Started!", 3)

    spawn(function()
        while AutoFarmEnabled do
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("Hitbox") and character:FindFirstChild("HumanoidRootPart") then
                
                -- Hitbox büyüt
                character.Hitbox.Size = Vector3.new(500,50,500)

                -- Orta noktada bekle
                local stadium = workspace:FindFirstChild("Stadium")
                if stadium and stadium:FindFirstChild("Field") and stadium.Field:FindFirstChild("Grass") then
                    character.HumanoidRootPart.CFrame = stadium.Field.Grass.CFrame + Vector3.new(0,20,0)
                end

                local ballHolder = GetBallHolder()

                if HasBall() then
                    -- Top bizdeyse auto shoot
                    pcall(AutoShoot)
                elseif ballHolder then
                    -- Rakipteyse teleport + tackle
                    if ballHolder.Character and ballHolder.Character:FindFirstChild("HumanoidRootPart") then
                        local originalCFrame = character.HumanoidRootPart.CFrame
                        character:PivotTo(ballHolder.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,0))
                        pcall(TsurenModule.TrueAutoGetBall)
                        character:PivotTo(originalCFrame)
                    end
                else
                    -- Top boşta → kale shoot
                    pcall(AutoShoot)
                end

                -- Enemy goal hitbox büyüt
                for _, pl in pairs(Players:GetPlayers()) do
                    if pl.Team ~= LocalPlayer.Team and pl.Team ~= nil then
                        local enemyGoal = workspace:FindFirstChild("Stadium") and workspace.Stadium.Teams:FindFirstChild(pl.Team.Name)
                        if enemyGoal and enemyGoal:FindFirstChild("Goal") and enemyGoal.Goal:FindFirstChild("Hitbox") then
                            enemyGoal.Goal.Hitbox.Size = Vector3.new(800,50,800)
                            task.wait(0.2)
                            enemyGoal.Goal.Hitbox.Size = Vector3.new(4.521,5.73,2.648)
                        end
                    end
                end
            end
            task.wait(0.2)
        end

        -- Toggle kapatıldığında hitbox resetle
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Hitbox") then
            character.Hitbox.Size = Vector3.new(4.521,5.73,2.398)
        end

        SendNotification("Auto Farm", "Auto Farm Stopped!", 3)
    end)
end

-- Rayfield MainTab Toggle
MainTab:CreateToggle({
    Name = "AutoFarm (Beta)",
    CurrentValue = false,
    Flag = "AutoFarmToggle",
    Callback = function(state)
        AutoFarmEnabled = state
        if AutoFarmEnabled then
            StartAutoFarm()
        end
    end,
})


local BringBallEnabled = false
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Saf karakter alma
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

-- Rakip oyuncu topa sahip mi kontrol
local function PlayerHasBall()
    for _, p in pairs(Players:GetPlayers()) do
        if p:GetAttribute("HasBall", false) and p.Team ~= LocalPlayer.Team and p:GetAttribute("TeamPosition") ~= "GK" then
            return p
        end
    end
    return nil
end

-- Local player topa sahip mi
local function LocalHasBall()
    local char = getCharacter()
    local ball = workspace:FindFirstChild("Misc") and workspace.Misc:FindFirstChild("Football")
    if not ball or not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local ok, owner = pcall(function() return ball:GetNetworkOwner() end)
    if ok and owner == LocalPlayer then return true end
    if (ball.Position - char.HumanoidRootPart.Position).Magnitude < 6 then return true end
    return false
end

-- Loop başlat, ama toggle true olana kadar hiçbir şey yapma
spawn(function()
    while true do
        task.wait(0.2)

        if not BringBallEnabled then continue end -- TOGGLE KAPALIYSA SKIP

        local char = getCharacter()
        if not char or not char:FindFirstChild("Hitbox") then continue end

        -- Toggle açıkken hitbox büyüt
        char.Hitbox.Size = Vector3.new(500,50,500)

        local enemyWithBall = PlayerHasBall()

        if enemyWithBall then
            -- Rakip topa sahipse tackle (teleport yok)
            local currentCFrame = char.HumanoidRootPart.CFrame
            char:PivotTo(enemyWithBall.Character.HumanoidRootPart.CFrame)

            local tackleArgs = {"TackleActivated", 9999999999.99}
            local TackleRF = game:GetService("ReplicatedStorage"):WaitForChild("Packages")
                :WaitForChild("_Index"):WaitForChild("sleitnick_knit@1.7.0")
                :WaitForChild("knit"):WaitForChild("Services"):WaitForChild("ActionService")
                :WaitForChild("RF"):WaitForChild("PerformActionThenGet")
            TackleRF:InvokeServer(unpack(tackleArgs))
            TackleRF:InvokeServer(unpack(tackleArgs))
            TackleRF:InvokeServer(unpack(tackleArgs))

            char:PivotTo(currentCFrame)
        end

        if LocalHasBall() then
            -- Bizdeyse shoot yap
            pcall(function()
                TsurenModule.TrueAutoShoot()
            end)
        end
    end
end)
-- Bring Ball Toggle
MainTab:CreateToggle({
    Name = "Bring Ball (Beta)",
    CurrentValue = false,
    Flag = "BringBallToggle",
    Callback = function(state)
        BringBallEnabled = state
        local char = getCharacter()
        if not char then return end

        local hitbox = char:WaitForChild("Hitbox")
        if not hitbox then return end

        if state then
            -- Bring Ball aktifken hitbox büyüt
            hitbox.Size = Vector3.new(500,50,50)
        else
            -- Toggle kapatıldığında eski boyutuna döndür
            hitbox.Size = Vector3.new(4.5209999, 5.73, 2.398)
        end
    end,
})

-- Anti-AFK Toggle
MainTab:CreateToggle({
    Name = "Anti-AFK (Beta)",
    CurrentValue = true, -- Script açılır açılmaz aktif olsun
    Flag = "AntiAFKToggle",
    Callback = function(state)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        local vu = game:GetService("VirtualUser")

        if state then
            -- Eğer zaten bağlı değilse bağla
            if not _G.AntiAFKConnection then
                _G.AntiAFKConnection = LocalPlayer.Idled:Connect(function()
                    vu:CaptureController()
                    vu:ClickButton2(Vector2.new())
                end)
            end
        else
            -- Kapattığında bağlantıyı kes
            if _G.AntiAFKConnection then
                _G.AntiAFKConnection:Disconnect()
                _G.AntiAFKConnection = nil
            end
        end
    end,
})
                        
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


tPlayers:CreateToggle({
    Name="Show FPS (F7)",
    CurrentValue=false,
    Callback=setFPS
})


UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.F7 then
        setFPS(not fpsEnabled)
    end
end)


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
local SharedInterfaceStates=require(ReplicatedStorage.Shared.States)
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


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer

local Knit = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"))
local PacksService = Knit.GetService("PacksService")

local PacksData = require(
	ReplicatedStorage:WaitForChild("Shared")
		:WaitForChild("Defaults")
		:WaitForChild("Packs")
)

local Enums = require(
	ReplicatedStorage:WaitForChild("Shared")
		:WaitForChild("Enums")
)

local PackTypes = {}
for name in pairs(PacksData.ItemData) do
	table.insert(PackTypes, name)
end
table.sort(PackTypes)

local SelectedPack = PackTypes[1]
local SelectedCurrency = "Points"
local AutoBuy = false
local Buying = false

local CurrencyMap = {
	["Points"] = Enums.Currency.Primary,
	["Coins"] = Enums.Currency.Primary, -- fallback (oyunda coins yok)
	["SkillPoints"] = "SkillPoints",
	["Robux"] = "Robux"
}

local function ResolvePurchaseOption(packName, wanted)
	local pack = PacksData.ItemData[packName]
	if not pack then return nil end

	local mapped = CurrencyMap[wanted]
	if pack.PurchaseOptions[mapped] then
		return mapped
	end

	if pack.PurchaseOptions[Enums.Currency.Primary] then
		return Enums.Currency.Primary
	end
	if pack.PurchaseOptions.SkillPoints then
		return "SkillPoints"
	end
	if pack.PurchaseOptions.Robux then
		return "Robux"
	end

	return nil
end

local function BuyPack()
	if Buying then return end
	Buying = true

	local option = ResolvePurchaseOption(SelectedPack, SelectedCurrency)
	if not option then
		Rayfield:Notify({
			Title = "Pack Error",
			Content = "There is no suitable currency for this pack.",
			Duration = 4
		})
		Buying = false
		return
	end

	pcall(function()
		PacksService:ProcessPurchase(SelectedPack, option)
	end)

	task.wait(1)
	Buying = false
end

-- AUTO BUY LOOP
task.spawn(function()
	while task.wait(2) do
		if AutoBuy and not Buying then
			BuyPack()
		end
	end
end)

-- ================================
-- REDEEM CODES
-- ================================
local Coupons = {
	"PACKS","SLS25","100kLikes","battlepass","xmas","90kLikes","80kLikes",
	"console!","70kLikes","Part1","60kLikes","50kLikes","GKFix!",
	"40kLikes","30KLIKES","slscomp","25klikes","49kmembers",
	"goalsaver","goalscorer","number1soccergame","islandmapforever",
	"Darkvaderbovin","SeniorYeet","newyears2026","veterantalking",
	"johnsnewyear","MrCooperth","Robloxpls"
}

local RedeemRF
pcall(function()
	RedeemRF =
		ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"]
			.knit.Services.RewardsService.RF.RedeemCode
end)

-- ================================
-- UI
-- ================================
local PacksTab = Window:CreateTab("Packs", "shopping-cart")

PacksTab:CreateDropdown({
	Name = "Pack",
	Options = PackTypes,
	CurrentOption = SelectedPack,
	Callback = function(v)
		SelectedPack = type(v) == "table" and v[1] or v
	end
})

PacksTab:CreateDropdown({
	Name = "Currency",
	Options = {"Points", "Coins", "SkillPoints", "Robux"},
	CurrentOption = SelectedCurrency,
	Callback = function(v)
		SelectedCurrency = type(v) == "table" and v[1] or v
	end
})

PacksTab:CreateButton({
	Name = "Buy Pack",
	Callback = BuyPack
})

PacksTab:CreateToggle({
	Name = "Auto Buy",
	CurrentValue = false,
	Callback = function(v)
		AutoBuy = v
	end
})

local RedeemTab = Window:CreateTab("Redeem", "gift")

RedeemTab:CreateButton({
	Name = "Redeem All Codes",
	Callback = function()
		if not RedeemRF then
			StarterGui:SetCore("SendNotification", {
				Title = "Error",
				Text = "Redeem: can't found RemoteFunction! for Codes",
				Duration = 5
			})
			return
		end

		for _, code in ipairs(Coupons) do
			local ok, result = pcall(function()
				return RedeemRF:InvokeServer(code)
			end)

			if ok and result == true then
				print("redeem successful worked code is:", code)
			end

			task.wait(0.25)
		end

		Rayfield:Notify({
			Title = "Redeem",
			Content = "redeem code is tryed times up or deleted.",
			Duration = 4
		})
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
    {id="17454350795", name="Shh - ⭐"},
    {id="118995435851830", name="God Mode Awakening🔥  - ⭐"},
    {id="13233771992", name="Take The L - ⭐"},
    {id="109755476052324", name="Soon - ⭐"},
    {id="16302284541", name='Yellow Card - ⭐'},
    {id="103273929159626", name="Adidas - ⭐"},
    {id="111241337069546", name="Soon - ⭐"},
    {id="90980126975445", name="Soon - ⭐"},
    {id="106640307740815", name="Soon - ⭐"},
    {id="132074413582912", name="Soon - ⭐"},
    {id="121020540386418", name="Soon - ⭐"},
    {id="100282947534083", name="Soon - ⭐"},
    {id="109585245141415", name="Soon - ⭐"},
    {id="16499681915", name="T-Rex - ⭐"},
    {id="82999087084315", name="Soon - ⭐"},
    {id="139973403632033", name="Soon - ⭐"},
    {id="102610758906338", name="Soon - ⭐"},
    {id="83169082048183", name='Soon - ⭐'},
    {id="85143829531506", name="Soon - ⭐"},
    {id="99068367180942", name="Soon - ⭐"},
    {id="101848273620506", name="Soon - ⭐"},
    {id="139537277486789", name="Soon - ⭐"},
    {id="126168053681827", name="Soon - ⭐"}
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
    local WeatherState=require(ReplicatedStorage.Shared.States).Player.Preferences.Weather
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
		pointsLabel:Set({Title="Skills Points", Content=stats.SkillPoints.Container.Amount.Text})
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
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local MusicList = {
	["Stay With Me"] = 137717310854691,
	["Gondor Theme"] = 9123456789,
	["Night Drive"] = 8234567891,
	["Lonely"] = 7345678912,
	["Memory"] = 6456789123
}

local function normalize(str)
	return string.lower(string.gsub(str or "","[%s%-_]",""))
end

local MusicSound = Instance.new("Sound")
MusicSound.Volume = 0.6
MusicSound.Parent = SoundService

local EQ = Instance.new("EqualizerSoundEffect")
EQ.LowGain = 8
EQ.MidGain = 0
EQ.HighGain = -3
EQ.Parent = MusicSound

local Compressor
pcall(function()
	Compressor = Instance.new("CompressorSoundEffect")
	Compressor.Threshold = -30
	Compressor.Ratio = 4
	Compressor.MakeupGain = 3
	Compressor.Parent = MusicSound
end)

local function ToggleBass(on)
	pcall(function()
		EQ.Enabled = on
		if Compressor then
			Compressor.Enabled = on
		end
	end)
end

local gui = Instance.new("ScreenGui",PlayerGui)
gui.Name = "TsurenStudios"
gui.ResetOnSpawn = false
gui.Enabled = false

local main = Instance.new("Frame",gui)
main.Size = UDim2.fromScale(0.42,0.32)
main.Position = UDim2.fromScale(0.29,0.25)
main.BackgroundColor3 = Color3.fromRGB(15,15,20)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,10)

do
	local dragging, dragStart, startPos
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = main.Position
		end
	end)
	UIS.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,38)
title.BackgroundTransparency = 1
title.Text = "TsurenStudios | Music Admin"
title.TextColor3 = Color3.fromRGB(0,170,255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

local box = Instance.new("TextBox",main)
box.Size = UDim2.new(0.9,0,0,36)
box.Position = UDim2.fromScale(0.05,0.27)
box.PlaceholderText = "Made By | Tsubasa"
box.Text = ""
box.TextColor3 = Color3.new(1,1,1)
box.BackgroundColor3 = Color3.fromRGB(25,25,30)
box.Font = Enum.Font.Code
box.TextSize = 16
box.ClearTextOnFocus = false
Instance.new("UICorner",box).CornerRadius = UDim.new(0,8)

local listFrame = Instance.new("Frame",main)
listFrame.Size = UDim2.new(0.6,0,0.39,0)
listFrame.Position = UDim2.fromScale(0.06,0.50)
listFrame.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout",listFrame)
layout.Padding = UDim.new(0,4)

local function clearButtons()
	for _,v in ipairs(listFrame:GetChildren()) do
		if v:IsA("TextButton") then v:Destroy() end
	end
end

local function createButton(name)
	local b = Instance.new("TextButton",listFrame)
	b.Size = UDim2.new(1,0,0,24)
	b.BackgroundColor3 = Color3.fromRGB(20,30,45)
	b.TextColor3 = Color3.fromRGB(0,170,255)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.Text = name
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)
	b.MouseButton1Click:Connect(function()
		box.Text = "play "..name
		clearButtons()
	end)
end

box:GetPropertyChangedSignal("Text"):Connect(function()
	clearButtons()
	local words = {}
	for w in box.Text:gmatch("%S+") do table.insert(words,w) end
	local last = words[#words] or ""
	local key = normalize(last)
	if key == "" then return end

	if normalize(words[1]) == "play" then
		for name,_ in pairs(MusicList) do
			if normalize(name):find(key,1,true) then
				createButton(name)
			end
		end
	end
end)

box.FocusLost:Connect(function(enter)
	if not enter then return end
	local cmd,args = box.Text:match("^(%S+)%s*(.*)$")
	if not cmd then return end
	cmd = cmd:lower()
	if cmd == "play" then
		for name,id in pairs(MusicList) do
			if normalize(name) == normalize(args) then
				MusicSound.SoundId = "rbxassetid://"..id
				MusicSound:Play()
			end
		end
	elseif cmd == "stop" then
		MusicSound:Stop()
	elseif cmd == "pause" then
		MusicSound:Pause()
	elseif cmd == "resume" then
		MusicSound:Resume()
	elseif cmd == "volume" then
		local v = tonumber(args)
		if v then MusicSound.Volume = math.clamp(v,0,1) end
	elseif cmd == "bass" then
		ToggleBass(args == "on")
	end
end)

local timeLabel = Instance.new("TextLabel",main)
timeLabel.Size = UDim2.new(0,120,0,18)
timeLabel.Position = UDim2.fromScale(0.5,0.9)
timeLabel.AnchorPoint = Vector2.new(0.5,0.5)
timeLabel.BackgroundTransparency = 1
timeLabel.Font = Enum.Font.Code
timeLabel.TextSize = 14
timeLabel.TextColor3 = Color3.fromRGB(200,200,200)
timeLabel.Text = "Waiting Music..."

RunService.RenderStepped:Connect(function()
	if MusicSound.IsLoaded then
		timeLabel.Text = string.format("%02d:%02d / %02d:%02d",
			MusicSound.TimePosition//60, MusicSound.TimePosition%60,
			MusicSound.TimeLength//60, MusicSound.TimeLength%60)
	end
end)


local vis = Instance.new("Frame",main)
vis.Size = UDim2.new(0.9,0,0,6)
vis.Position = UDim2.fromScale(0.05,0.92)
vis.BackgroundTransparency = 1

local bars = {}
for i=1,20 do
	local bar = Instance.new("Frame",vis)
	bar.Size = UDim2.new(0.04,0,0.2,0)
	bar.Position = UDim2.fromScale((i-1)*0.05,0.5)
	bar.AnchorPoint = Vector2.new(0,0.5)
	bar.BackgroundColor3 = Color3.fromHSV(i/20,1,1)
	bars[i] = bar
end

RunService.RenderStepped:Connect(function()
	if MusicSound.IsPlaying then
		local l = MusicSound.PlaybackLoudness / 500
		for i,b in ipairs(bars) do
			b.Size = UDim2.new(0.04,0,math.clamp(l*(i/20),0.1,1),0)
		end
	end
end)


local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local gui = PlayerGui:WaitForChild("TsurenStudios", 5)
if not gui then
	warn("GUI bulunamadı!")
end

local VERIFY_ICON = utf8.char(0xE000)
local VerifyEnabled = false

local function HandleCommand(text)
	text = text:lower()

	if text == ";t close" and gui then
		gui.Enabled = false
		return true
	end

	if text == ";t open" and gui then
		gui.Enabled = true
		return true
	end

	if text == ";t verify" then
		VerifyEnabled = true
		return true
	end

	if text == ";t unverify" then
		VerifyEnabled = false
		return true
	end

	return false
end

TextChatService.OnIncomingMessage = function(chatMessage: TextChatMessage)
	local props = Instance.new("TextChatMessageProperties")

	if not chatMessage.TextSource then
		return props
	end

	if chatMessage.TextSource.UserId ~= LocalPlayer.UserId then
		return props
	end

	local text = chatMessage.Text
	if not text then
		return props
	end

	if HandleCommand(text) then
		props.Text = ""
		props.PrefixText = ""
		return props
	end

	if VerifyEnabled then
		props.PrefixText = string.gsub(
			chatMessage.PrefixText,
			":$",
			VERIFY_ICON .. ":"
		)
	end

	return props
end
