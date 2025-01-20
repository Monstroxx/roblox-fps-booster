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
local function enableWhiteMode()
    -- Set ambient light to white
    game.Lighting.Ambient = Color3.new(1, 1, 1)
    
    -- Set outdoor ambient to white
    game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
    
    -- Set background color to white
    game.Lighting.ColorShift_Top = Color3.new(1, 1, 1)
    game.Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
end

-- Function to create a full-screen white UI
local function createWhiteScreenUI()
    local player = game.Players.LocalPlayer
    local screenGui = Instance.new("ScreenGui")
    local frame = Instance.new("Frame")
    
    screenGui.IgnoreGuiInset = true -- Ignore Roblox UI insets
    screenGui.Parent = player:WaitForChild("PlayerGui")
    frame.Parent = screenGui
    frame.Size = UDim2.new(1, 0, 1, 0)  -- Full-screen size
    frame.Position = UDim2.new(0, 0, 0, 0)
    frame.BackgroundColor3 = Color3.new(1, 1, 1)  -- White color
    frame.BorderSizePixel = 0  -- Remove the border, if any
end

-- Execute the functions
optimizePerformance()
enableWhiteMode()
createWhiteScreenUI()
