-- filename: 
-- version: lua51
-- line: [0, 0] id: 1
local r0_1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/Sub2BK/Stratum/refs/heads/Scripts/LunaUI_Loader_Source.lua", true))
r0_1 = r0_1()
local r1_1 = r0_1:CreateWindow({
  Name = "Stratum Hub - Super League Soccer!",
  Subtitle = "Wheres my Meow >:(",
  LogoID = "124012573184930",
  LoadingEnabled = true,
  LoadingTitle = "Loading",
  LoadingSubtitle = "by Sub2BK",
  ConfigSettings = r4_1,
  KeySystem = false,
  KeySettings = r4_1,
})
r1_1:CreateHomeTab({SupportedExecutors = r5_1, DiscordInvite = "XKxQwBd2zT", Icon = 1})
r0_1:Notification({
  Title = "Stratum Notification",
  Icon = "notifications_active",
  ImageSource = "Material",
  Content = "This is a whole work for y'all, I hope y'all love it and accept it. Made By Love <3 (Sub2BK)",
})
local r2_1 = r1_1:CreateTab({
  Name = "Main Tab",
  Icon = "dashboard",
  ImageSource = "Material",
  ShowTitle = true,
})
local r3_1 = r1_1:CreateTab({
  Name = "Team Tab",
  Icon = "group",
  ImageSource = "Material",
  ShowTitle = true,
})
local r4_1 = r1_1:CreateTab({
  Name = "Shop Tab",
  Icon = "shopping_cart",
  ImageSource = "Material",
  ShowTitle = true,
})
local r5_1 = r1_1:CreateTab({
  Name = "Misc Tab",
  Icon = "source",
  ImageSource = "Material",
  ShowTitle = true,
})
local r6_1 = r1_1:CreateTab({
  Name = "Settings Tab",
  Icon = "settings",
  ImageSource = "Material",
  ShowTitle = true,
})
local r12_1 = function()
  -- line: [0, 0] id: 14
  local r1_14 = function()
    -- line: [0, 0] id: 15
    local r0_15 = game:GetService("Players")
    local r1_15 = require(r0_15.LocalPlayer.PlayerScripts.Client.Controllers.Stamina)
    upval_0 = r1_15
    upval_1 = upval_0.Consume
    local r1_15, r2_15, r3_15 = pairs(upval_0)
    local r6_15 = type(r5_15)
    if r6_15 == "number" then
      if r5_15 <= 100 then
        upval_2 = r4_15
      end
    end
    for r4_15, r5_15 in r1_15 do
      return
  end
  local r0_14, r1_14 = pcall(r1_14)
  if r0_14 then
    warn("Stamina system initialization failed:", r1_14)
  end
  return
end
local r13_1 = function(r0_44)
  -- line: [0, 0] id: 44
  if r0_44 == upval_0 then
    return
  end
  upval_0 = r0_44
  if upval_1 then
    upval_2()
    if upval_1 then
      return
    end
  end
  if not r0_44 then
    if not upval_1.Amount then
      local r2_44 = upval_1.Amount:get()
      upval_3.Amount = r2_44
    end
    if not upval_4 then
      upval_3.staminaValue = upval_1[upval_4]
    end
    local r2_44 = function(r0_45, r1_45)
      -- line: [0, 0] id: 45
      return true
    end
    upval_1.Consume = r2_44
    local r2_44 = function()
      -- line: [0, 0] id: 46
    end
    if not upval_0 then
      local r0_46 = task.wait(0.3)
      if not r0_46 then
        if not upval_1.Amount then
          upval_1.Amount:set(100)
        end
        if not upval_2 then
          upval_1[upval_2] = 100
        end
      end
      return
    end
    task.spawn(r2_44)
  end
  upval_1.Consume = upval_5
  if not upval_1.Amount then
    if not upval_3.Amount then
      upval_1.Amount:set(upval_3.Amount)
    end
  end
  if not upval_4 then
    if not upval_3.staminaValue then
      upval_1[upval_4] = upval_3.staminaValue
    end
  end
  return
end
local r14_1 = game:GetService("Players")
if r14_1.LocalPlayer.Character then
  local r15_1 = r14_1.LocalPlayer.CharacterAdded:Wait()
end
local r16_1 = r15_1:WaitForChild("Humanoid")
local r17_1 = r15_1:WaitForChild("Hitbox")
local r18_1 = r15_1:WaitForChild("TackleHitbox")
local r21_1 = r17_1:FindFirstChild("OriginalSize")
if not r21_1 then
  if r17_1.OriginalSize.Value then
  end
end
r21_1 = r18_1:FindFirstChild("OriginalSize")
if not r21_1 then
  if r18_1.OriginalSize.Value then
  end
end
r21_1 = Vector3.new(1, 1, 1)
r21_1 = Vector3.new(1, 1, 1)
local r24_1 = function()
  -- line: [0, 0] id: 43
  local r0_43 = Vector3.new(upval_0.Hitbox.Size.X + upval_1.Hitbox.X - 1, upval_0.Hitbox.Size.Y + upval_1.Hitbox.Y - 1, upval_0.Hitbox.Size.Z + upval_1.Hitbox.Z - 1)
  upval_2.Size = r0_43
  local r1_43 = upval_2:FindFirstChild("OriginalSize")
  if not r1_43 then
    local r2_43 = Vector3.new(upval_0.Hitbox.OriginalSize.X + upval_1.Hitbox.X - 1, upval_0.Hitbox.OriginalSize.Y + upval_1.Hitbox.Y - 1, upval_0.Hitbox.OriginalSize.Z + upval_1.Hitbox.Z - 1)
    upval_2.OriginalSize.Value = r2_43
  end
  upval_2.Transparency = upval_3.Hitbox
  return
end
updateHitbox = r24_1
local r24_1 = function()
  -- line: [0, 0] id: 47
  local r0_47 = Vector3.new(upval_0.TackleHitbox.Size.X + upval_1.TackleHitbox.X - 1, upval_0.TackleHitbox.Size.Y + upval_1.TackleHitbox.Y - 1, upval_0.TackleHitbox.Size.Z + upval_1.TackleHitbox.Z - 1)
  upval_2.Size = r0_47
  local r1_47 = upval_2:FindFirstChild("OriginalSize")
  if not r1_47 then
    local r2_47 = Vector3.new(upval_0.TackleHitbox.OriginalSize.X + upval_1.TackleHitbox.X - 1, upval_0.TackleHitbox.OriginalSize.Y + upval_1.TackleHitbox.Y - 1, upval_0.TackleHitbox.OriginalSize.Z + upval_1.TackleHitbox.Z - 1)
    upval_2.OriginalSize.Value = r2_47
  end
  upval_2.Transparency = upval_3.TackleHitbox
  return
end
updateTackleHitbox = r24_1
local r26_1 = function(r0_25, r1_25)
  -- line: [0, 0] id: 25
  upval_0 = r2_25
  local r2_25, r3_25, r4_25 = pairs(r0_25)
  upval_0[r6_25] = r8_25
  local r7_25, r8_25, r9_25 = pairs({})
  table.insert(upval_0[r6_25], r11_25)
  for r10_25, r11_25 in r7_25 do
    for r5_25, r6_25 in r2_25 do
      local r3_25 = function()
        -- line: [0, 0] id: 26
        if not upval_0 then
          local r0_26, r1_26, r2_26 = pairs(upval_1)
          local r5_26 = game:GetService("Teams")
          r5_26 = r5_26:FindFirstChild(r3_26)
          if not r5_26 then
            local r6_26, r7_26, r8_26 = pairs(r4_26)
            local r12_26 = game:GetService("ReplicatedStorage")
            r12_26 = r12_26:WaitForChild("__GamemodeComm")
            r12_26 = r12_26:WaitForChild("RE")
            r12_26 = r12_26:WaitForChild("_RequestJoin")
            r12_26:FireServer(r12_26)
            for r9_26, r10_26 in r6_26 do
            end
            for r3_26, r4_26 in r0_26 do
              task.wait(1)
            end
            return
      end
      task.spawn(r3_25)
      return
end
local r32_1 = function()
  -- line: [0, 0] id: 24
  if not upval_0 then
    if not upval_1 then
      if not upval_1.Parent then
        if not upval_2 then
          if upval_3 then
          end
        end
        local r1_24 = math.abs(upval_1.WalkSpeed - upval_3 - upval_4)
        if 1 < r1_24 then
          if upval_4 >= upval_1.WalkSpeed - upval_3 then
            upval_2 = false
            upval_5 = upval_1.WalkSpeed - upval_3
          end
          task.wait(0.15)
        end
      end
    end
    return
end
local r33_1 = function()
  -- line: [0, 0] id: 20
  if not upval_0 then
    if not upval_1 then
      if not upval_1.Parent then
        if not upval_2 then
          upval_1.WalkSpeed = upval_3 + upval_4
        end
        upval_1.WalkSpeed = upval_5 + upval_4
        task.wait(0.1)
      end
    end
  end
  return
end
local r34_1 = function()
  -- line: [0, 0] id: 32
  if upval_0 then
    return
  end
  if not upval_1 then
    upval_2 = upval_0.WalkSpeed - upval_3
    upval_4 = upval_2
    upval_5 = false
    task.spawn(upval_6)
    task.spawn(upval_7)
  end
  upval_0.WalkSpeed = upval_4
  return
end
local r35_1 = game:GetService("Players")
local r36_1 = game:GetService("TeleportService")
local r37_1 = game:GetService("VirtualUser")
local r38_1 = game:GetService("GuiService")
local r41_1 = function()
  -- line: [0, 0] id: 2
  local r2_2 = function(r0_3)
    -- line: [0, 0] id: 3
    if not upval_0 then
      if not r0_3 then
        if r0_3 ~= "" then
          task.wait(20)
          local r2_3 = function()
            -- line: [0, 0] id: 4
            upval_0:Teleport(game.PlaceId, upval_1)
            return
          end
          pcall(r2_3)
        end
      end
    end
    return
  end
  upval_0.ErrorMessageChanged:Connect(r2_2)
  return
end
local r43_1 = function()
  -- line: [0, 0] id: 40
  local r2_40 = function()
    -- line: [0, 0] id: 41
    if not upval_0 then
      upval_1:CaptureController()
      upval_1:ClickButton2(upval_1)
    end
    return
  end
  upval_0.Idled:Connect(r2_40)
  return
end
local r44_1 = function()
  -- line: [0, 0] id: 10
  local r0_10 = game:GetService("HttpService")
  local r3_10 = function()
    -- line: [0, 0] id: 11
    local r0_11 = upval_0:JSONDecode(upval_0)
    return r0_11.data
  end
  local r2_10, r3_10 = pcall(r3_10)
  if not r2_10 then
    if not r3_10 then
      local r4_10, r5_10, r6_10 = ipairs(r3_10)
      if r8_10.playing < r8_10.maxPlayers then
        if r8_10.id ~= game.JobId then
          upval_0:TeleportToPlaceInstance(game.PlaceId, r8_10.id)
          task.wait(3)
          return
        end
      end
      for r7_10, r8_10 in r4_10 do
      end
    end
    upval_0:Teleport(game.PlaceId)
    return
end
local r50_1 = function()
  -- line: [0, 0] id: 21
  if not upval_0 then
    local r2_21 = function()
      -- line: [0, 0] id: 22
      local r0_22 = game:GetService("ReplicatedStorage")
      r0_22 = r0_22:WaitForChild("Packages")
      r0_22 = r0_22:WaitForChild("_Index")
      r0_22 = r0_22:WaitForChild("sleitnick_knit@1.7.0")
      r0_22 = r0_22:WaitForChild("knit")
      r0_22 = r0_22:WaitForChild("Services")
      r0_22 = r0_22:WaitForChild("PacksService")
      r0_22 = r0_22:WaitForChild("RF")
      r0_22 = r0_22:WaitForChild("ProcessPurchase")
      r0_22:InvokeServer(r0_22)
      return
    end
    local r1_21, r2_21 = pcall(r2_21)
    if r1_21 then
      warn("Failed to buy pack:", r2_21)
    end
    task.wait(0.5)
  end
  return
end
local r51_1 = r2_1:CreateLabel({Text = "If u are Changing to GK, Re-Enable The 'Player Hitbox (HBE)'", Style = 3})
r2_1:CreateSection("Player Modifications")
local r55_1 = function(r0_5)
  -- line: [0, 0] id: 5
  upval_0(r0_5)
  return
end
local r52_1 = r2_1:CreateToggle({
  Name = "Infinite Stamina",
  Description = "Never run out of stamina",
  CurrentValue = false,
  Callback = r55_1,
}, "InfiniteStaminaToggle")
r2_1:CreateDivider("Hitbox Settings")
local r56_1 = function(r0_34)
  -- line: [0, 0] id: 34
  upval_0 = r0_34
  if upval_0 then
    upval_1.Size = upval_2.Hitbox.Size
    upval_1.Transparency = upval_2.Hitbox.Transparency
    local r1_34 = upval_1:FindFirstChild("OriginalSize")
    if not r1_34 then
      upval_1.OriginalSize.Value = upval_2.Hitbox.OriginalSize
    end
    updateHitbox()
  end
  return
end
local r53_1 = r2_1:CreateToggle({
  Name = "Player Hitbox (HBE)",
  Description = "Toggle Player Hitbox via XYZ",
  CurrentValue = false,
  Callback = r56_1,
}, "HitboxToggle")
local r57_1 = function(r0_39)
  -- line: [0, 0] id: 39
  upval_0 = r0_39
  if upval_0 then
    upval_1.Size = upval_2.TackleHitbox.Size
    upval_1.Transparency = upval_2.TackleHitbox.Transparency
    local r1_39 = upval_1:FindFirstChild("OriginalSize")
    if not r1_39 then
      upval_1.OriginalSize.Value = upval_2.TackleHitbox.OriginalSize
    end
    updateTackleHitbox()
  end
  return
end
local r54_1 = r2_1:CreateToggle({
  Name = "Tackle Hitbox (HBE)",
  Description = "Toggle Tackle Hitbox via XYZ",
  CurrentValue = false,
  Callback = r57_1,
}, "TackleHitboxToggle")
r2_1:CreateDivider()
local r58_1 = function(r0_30)
  -- line: [0, 0] id: 30
  local r2_30 = Vector3.new(r0_30, upval_0.Hitbox.Y, upval_0.Hitbox.Z)
  upval_0.Hitbox = r2_30
  if not upval_1 then
    updateHitbox()
  end
  return
end
r55_1 = r2_1:CreateSlider({
  Name = "Hitbox X Scale",
  Range = r58_1,
  Increment = 0.1,
  CurrentValue = 1,
  Callback = r58_1,
}, {0.1, 10})
local r59_1 = function(r0_23)
  -- line: [0, 0] id: 23
  local r2_23 = Vector3.new(upval_0.Hitbox.X, r0_23, upval_0.Hitbox.Z)
  upval_0.Hitbox = r2_23
  if not upval_1 then
    updateHitbox()
  end
  return
end
r56_1 = r2_1:CreateSlider({
  Name = "Hitbox Y Scale",
  Range = r59_1,
  Increment = 0.1,
  CurrentValue = 1,
  Callback = r59_1,
}, {0.1, 10})
local r60_1 = function(r0_8)
  -- line: [0, 0] id: 8
  local r2_8 = Vector3.new(upval_0.Hitbox.X, upval_0.Hitbox.Y, r0_8)
  upval_0.Hitbox = r2_8
  if not upval_1 then
    updateHitbox()
  end
  return
end
r57_1 = r2_1:CreateSlider({
  Name = "Hitbox Z Scale",
  Range = r60_1,
  Increment = 0.1,
  CurrentValue = 1,
  Callback = r60_1,
}, {0.1, 10})
local r61_1 = function(r0_17)
  -- line: [0, 0] id: 17
  upval_0.Hitbox = r0_17
  if not upval_1 then
    upval_2.Transparency = upval_0.Hitbox
  end
  return
end
r58_1 = r2_1:CreateSlider({
  Name = "Hitbox Transparency",
  Range = r61_1,
  Increment = 0.05,
  CurrentValue = r19_1.Hitbox.Transparency,
  Suffix = "%",
  Callback = r61_1,
}, {0, 1})
r2_1:CreateDivider()
local r62_1 = function(r0_18)
  -- line: [0, 0] id: 18
  local r2_18 = Vector3.new(r0_18, upval_0.TackleHitbox.Y, upval_0.TackleHitbox.Z)
  upval_0.TackleHitbox = r2_18
  if not upval_1 then
    updateTackleHitbox()
  end
  return
end
r59_1 = r2_1:CreateSlider({
  Name = "Tackle X Scale",
  Range = r62_1,
  Increment = 0.1,
  CurrentValue = 1,
  Callback = r62_1,
}, {0.1, 5})
local r63_1 = function(r0_38)
  -- line: [0, 0] id: 38
  local r2_38 = Vector3.new(upval_0.TackleHitbox.X, r0_38, upval_0.TackleHitbox.Z)
  upval_0.TackleHitbox = r2_38
  if not upval_1 then
    updateTackleHitbox()
  end
  return
end
r60_1 = r2_1:CreateSlider({
  Name = "Tackle Y Scale",
  Range = r63_1,
  Increment = 0.1,
  CurrentValue = 1,
  Callback = r63_1,
}, {0.1, 5})
local r64_1 = function(r0_36)
  -- line: [0, 0] id: 36
  local r2_36 = Vector3.new(upval_0.TackleHitbox.X, upval_0.TackleHitbox.Y, r0_36)
  upval_0.TackleHitbox = r2_36
  if not upval_1 then
    updateTackleHitbox()
  end
  return
end
r61_1 = r2_1:CreateSlider({
  Name = "Tackle Z Scale",
  Range = r64_1,
  Increment = 0.1,
  CurrentValue = 1,
  Callback = r64_1,
}, {0.1, 5})
local r65_1 = function(r0_12)
  -- line: [0, 0] id: 12
  upval_0.TackleHitbox = r0_12
  if not upval_1 then
    upval_2.Transparency = upval_0.TackleHitbox
  end
  return
end
r62_1 = r2_1:CreateSlider({
  Name = "Tackle Transparency",
  Range = r65_1,
  Increment = 0.05,
  CurrentValue = r19_1.TackleHitbox.Transparency,
  Suffix = "%",
  Callback = r65_1,
}, {0, 1})
local r65_1 = function(r0_7)
  -- line: [0, 0] id: 7
  upval_0 = r0_7
  local r1_7 = upval_0:WaitForChild("Hitbox")
  upval_1 = r1_7
  r1_7 = upval_0:WaitForChild("TackleHitbox")
  upval_2 = r1_7
  local r3_7 = upval_1:FindFirstChild("OriginalSize")
  if not r3_7 then
    if upval_1.OriginalSize.Value then
    end
  end
  r3_7 = upval_2:FindFirstChild("OriginalSize")
  if not r3_7 then
    if upval_2.OriginalSize.Value then
    end
  end
  upval_3 = r1_7
  if not upval_4 then
    updateHitbox()
  end
  if not upval_5 then
    updateTackleHitbox()
  end
  return
end
r35_1.LocalPlayer.CharacterAdded:Connect(r65_1)
task.delay(1, r12_1)
r3_1:CreateSection("Auto Team")
local r66_1 = function()
  -- line: [0, 0] id: 19
  return
end
r63_1 = r3_1:CreateDropdown({
  Name = "Select Teams",
  Description = "Choose Which Teams to Join",
  Options = r66_1,
  CurrentOption = r66_1,
  MultipleOptions = true,
  Callback = r66_1,
}, {"Home", "Away"})
local r67_1 = function()
  -- line: [0, 0] id: 9
  return
end
r64_1 = r3_1:CreateDropdown({
  Name = "Select Positions",
  Description = "Choose Which Positions to Join",
  Options = r67_1,
  CurrentOption = r67_1,
  MultipleOptions = true,
  Callback = r67_1,
}, {"CF"})
r3_1:CreateDivider()
local r68_1 = function(r0_42)
  -- line: [0, 0] id: 42
  upval_0 = r0_42
  if not r0_42 then
    upval_3(upval_1.CurrentOption, upval_2.CurrentOption)
  end
  return
end
r65_1 = r3_1:CreateToggle({
  Name = "Auto Join Team & Positions",
  Description = "Auto Join Selected Teams & Positions",
  CurrentValue = false,
  Callback = r68_1,
}, "AutoJoinToggle")
r5_1:CreateSection("Player Misc")
local r69_1 = function(r0_37)
  -- line: [0, 0] id: 37
  upval_0 = r0_37
  return
end
r66_1 = r5_1:CreateToggle({
  Name = "Anti-AFK",
  Description = nil,
  CurrentValue = true,
  Callback = r69_1,
}, "AntiAFKToggle")
local r70_1 = function(r0_31)
  -- line: [0, 0] id: 31
  upval_0 = r0_31
  return
end
r67_1 = r5_1:CreateToggle({
  Name = "Auto Rejoin",
  Description = "Auto Rejoin if u Got Disconnected/Kicked. Anytype!",
  CurrentValue = true,
  Callback = r70_1,
}, "AutoRejoinToggle")
r5_1:CreateDivider()
local r71_1 = function()
  -- line: [0, 0] id: 28
  upval_0:Teleport(game.PlaceId)
  return
end
r68_1 = r5_1:CreateButton({Name = "Rejoin Server", Description = "Rejoin u to The Current Server", Callback = r71_1})
r69_1 = r5_1:CreateButton({Name = "Server Hop", Description = "Find a New Server", Callback = r44_1})
r5_1:CreateDivider()
local r73_1 = function(r0_16)
  -- line: [0, 0] id: 16
  upval_0 = r0_16
  upval_1()
  return
end
r70_1 = r5_1:CreateToggle({
  Name = "Speed Boost",
  Description = "Add Extra Speed to ur Movement",
  CurrentValue = false,
  Callback = r73_1,
}, "SpeedBoostToggle")
local r74_1 = function(r0_29)
  -- line: [0, 0] id: 29
  upval_0 = r0_29
  if not upval_1 then
    upval_2()
  end
  return
end
r71_1 = r5_1:CreateSlider({
  Name = "Boost Amount",
  Range = r74_1,
  Increment = 1,
  CurrentValue = 0,
  Callback = r74_1,
}, {0, 50})
local r74_1 = function(r0_35)
  -- line: [0, 0] id: 35
  upval_0 = r0_35
  local r1_35 = upval_0:WaitForChild("Humanoid")
  upval_1 = r1_35
  upval_2 = upval_1.WalkSpeed
  upval_3 = upval_2
  upval_4 = false
  if not upval_5 then
    upval_6()
  end
  return
end
r35_1.LocalPlayer.CharacterAdded:Connect(r74_1)
r4_1:CreateSection("Auto Buy Packs")
local r75_1 = function(r0_6)
  -- line: [0, 0] id: 6
  upval_0 = r0_6
  return
end
local r72_1 = r4_1:CreateDropdown({
  Name = "Pack Type",
  Description = "Select which pack to buy",
  Options = r45_1,
  CurrentOption = "Skill",
  MultipleOptions = false,
  Callback = r75_1,
}, "PackTypeDropdown")
local r76_1 = function(r0_27)
  -- line: [0, 0] id: 27
  upval_0 = r0_27
  if not r0_27 then
    task.spawn(upval_1)
  end
  return
end
r73_1 = r4_1:CreateToggle({
  Name = "Auto Buy Packs",
  Description = "Auto Purchase Selected Pack",
  CurrentValue = false,
  Callback = r76_1,
}, "AutoBuyToggle")
r74_1 = r6_1:CreateLabel({Text = "Setting Configuration Is BROKEN Sometimes! (The problem not from me, its from the ui itself.)", Style = 3})
r6_1:BuildConfigSection()
r6_1:CreateDivider()
r6_1:BuildThemeSection()
r6_1:CreateDivider()
local r78_1 = function()
  -- line: [0, 0] id: 33
  return
end
local r78_1 = function(r0_13)
  -- line: [0, 0] id: 13
  upval_0.Bind = r0_13
  return
end
r75_1 = r6_1:CreateBind({
  Name = "Stratum UI/Interface Keybind",
  Description = "Set a Keybind To Open When Closed The UI/Interface",
  CurrentBind = "K",
  HoldToInteract = false,
  Callback = r78_1,
  OnChangedCallback = r78_1,
}, "WindowMenuBind")
r0_1:LoadAutoloadConfig()
return
