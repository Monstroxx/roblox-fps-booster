-- Function to optimize game settings for better performance
local function optimizePerformance()
    -- Reduce graphics quality
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    -- Disable unnecessary effects
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    game.Lighting.Brightness = 1
    
    -- Remove decals and textures
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
end

-- Function to enable white mode
local function enableWhiteMode(isEnabled)
    if isEnabled then
        game.Lighting.Ambient = Color3.new(1, 1, 1)
        game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        game.Lighting.ColorShift_Top = Color3.new(1, 1, 1)
        game.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
    else
        -- Optionally reset to default colors here
        -- game.Lighting.Ambient = Color3.new(...)
    end
end

-- Function to create a full-screen white UI
local function createWhiteScreenUI(isEnabled)
    local player = game.Players.LocalPlayer
    local screenGui = player.PlayerGui:FindFirstChild("WhiteScreenGui")

    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "WhiteScreenGui"
        screenGui.IgnoreGuiInset = true
        screenGui.Parent = player.PlayerGui
        
        local frame = Instance.new("Frame")
        frame.Name = "WhiteFrame"
        frame.Parent = screenGui
        frame.Size = UDim2.new(1, 0, 1, 0)  -- Full-screen size
        frame.Position = UDim2.new(0, 0, 0, 0)
        frame.BackgroundColor3 = Color3.new(1, 1, 1)  -- White color
        frame.BorderSizePixel = 0  -- Remove the border, if any
    end

    screenGui.Enabled = isEnabled
end

-- Function to rejoin the game after a specified time
local function rejoinAfterTime(rejoinTime)
    wait(rejoinTime * 60) -- Convert minutes to seconds
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end

-- Create UI with toggles and input field
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mainGui = Instance.new("ScreenGui", playerGui)
mainGui.Name = "MainSettingsGui"

local frame = Instance.new("Frame", mainGui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
frame.Active = true
frame.Draggable = true -- Make frame draggable

local whiteScreenToggle = Instance.new("TextButton", frame)
whiteScreenToggle.Size = UDim2.new(0, 180, 0, 30)
whiteScreenToggle.Position = UDim2.new(0, 10, 0, 10)
whiteScreenToggle.Text = "White Screen: ON"

local autoRejoinToggle = Instance.new("TextButton", frame)
autoRejoinToggle.Size = UDim2.new(0, 180, 0, 30)
autoRejoinToggle.Position = UDim2.new(0, 10, 0, 50)
autoRejoinToggle.Text = "Auto Rejoin: ON"

local rejoinTimeInput = Instance.new("TextBox", frame)
rejoinTimeInput.Size = UDim2.new(0, 180, 0, 30)
rejoinTimeInput.Position = UDim2.new(0, 10, 0, 90)
rejoinTimeInput.Text = "30"
rejoinTimeInput.PlaceholderText = "Rejoin Time (min)"

local whiteScreenEnabled = true
local autoRejoinEnabled = true

whiteScreenToggle.MouseButton1Click:Connect(function()
    whiteScreenEnabled = not whiteScreenEnabled
    whiteScreenToggle.Text = "White Screen: " .. (whiteScreenEnabled and "ON" or "OFF")
    createWhiteScreenUI(whiteScreenEnabled)
end)

autoRejoinToggle.MouseButton1Click:Connect(function()
    autoRejoinEnabled = not autoRejoinEnabled
    autoRejoinToggle.Text = "Auto Rejoin: " .. (autoRejoinEnabled and "ON" or "OFF")
end)

rejoinTimeInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local rejoinTime = tonumber(rejoinTimeInput.Text)
        if rejoinTime and rejoinTime > 0 and autoRejoinEnabled then
            rejoinAfterTime(rejoinTime)
        else
            rejoinTimeInput.Text = "30" -- Reset to default if invalid input
        end
    end
end)

-- Initial execution of functions
optimizePerformance()
enableWhiteMode(whiteScreenEnabled
