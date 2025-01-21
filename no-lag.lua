-- Function to optimize game settings for better performance
local function optimizePerformance()
	-- Reduce graphics quality
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

	-- Disable unnecessary effects
	game.Lighting.GlobalShadows = false
	game.Lighting.FogEnd = 9e9
	game.Lighting.Brightness = 1

	-- Remove decals and textures
	local function clearTextures(object)
		for _, descendant in pairs(object:GetDescendants()) do
			if descendant:IsA("Decal") or descendant:IsA("Texture") or descendant:IsA("SurfaceAppearance") then
				descendant:Destroy()
			end
		end
	end

	-- Clear all textures from workspace
	clearTextures(game.Workspace)

	-- Optionally clear textures from ReplicatedStorage or other services
	if game:FindFirstChild("ReplicatedStorage") then
		clearTextures(game.ReplicatedStorage)
	end

	if game:FindFirstChild("ServerStorage") then
		clearTextures(game.ServerStorage)
	end

	-- Remove textures from Player characters (if they already exist)
	for _, player in pairs(game.Players:GetPlayers()) do
		if player.Character then
			clearTextures(player.Character)
		end
	end

	-- Connect to new player characters being added
	game.Players.PlayerAdded:Connect(function(player)
		player.CharacterAdded:Connect(function(character)
			clearTextures(character)
		end)
	end)
end

-- Function to create a full-screen white UI
local function createWhiteScreenUI(isEnabled)
	local player = game.Players.LocalPlayer
	local screenGui = player.PlayerGui:FindFirstChild("WhiteScreenGui")

	if not screenGui then
		screenGui = Instance.new("ScreenGui")
		screenGui.Name = "WhiteScreenGui"
		screenGui.IgnoreGuiInset = true
		screenGui.DisplayOrder = 10 -- Ensure this UI is on top of others
		screenGui.Parent = player.PlayerGui

		local frame = Instance.new("Frame")
		frame.Name = "WhiteFrame"
		frame.Parent = screenGui
		frame.Size = UDim2.new(1, 0, 1, 0) -- Full-screen size
		frame.Position = UDim2.new(0, 0, 0, 0)
		frame.BackgroundColor3 = Color3.new(1, 1, 1) -- White color
		frame.BorderSizePixel = 0 -- Remove the border, if any
	end

	screenGui.Enabled = isEnabled
end

-- Function to rejoin the game after a specified time
local function rejoinAfterTime(rejoinTime)
	wait(rejoinTime * 60) -- Convert minutes to seconds
	game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end

-- Create UI with toggles, performance stats, and input field
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local mainGui = Instance.new("ScreenGui", playerGui)
mainGui.Name = "MainSettingsGui"
mainGui.DisplayOrder = 11 -- Ensure it overlays other UIs

local frame = Instance.new("Frame", mainGui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.5, -125, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.8, 0.8, 0.8)
frame.Active = true

local whiteScreenToggle = Instance.new("TextButton", frame)
whiteScreenToggle.Size = UDim2.new(0, 230, 0, 30)
whiteScreenToggle.Position = UDim2.new(0, 10, 0, 10)
whiteScreenToggle.Text = "White Screen: ON"

local autoRejoinToggle = Instance.new("TextButton", frame)
autoRejoinToggle.Size = UDim2.new(0, 230, 0, 30)
autoRejoinToggle.Position = UDim2.new(0, 10, 0, 50)
autoRejoinToggle.Text = "Auto Rejoin: ON"

local rejoinTimeInput = Instance.new("TextBox", frame)
rejoinTimeInput.Size = UDim2.new(0, 230, 0, 30)
rejoinTimeInput.Position = UDim2.new(0, 10, 0, 90)
rejoinTimeInput.Text = "30"
rejoinTimeInput.PlaceholderText = "Rejoin Time (min)"

local fpsLabel = Instance.new("TextLabel", frame)
fpsLabel.Size = UDim2.new(0, 230, 0, 30)
fpsLabel.Position = UDim2.new(0, 10, 0, 120)
fpsLabel.Text = "FPS: Calculating..."
fpsLabel.BackgroundTransparency = 1

local pingLabel = Instance.new("TextLabel", frame)
pingLabel.Size = UDim2.new(0, 230, 0, 30)
pingLabel.Position = UDim2.new(0, 10, 0, 140)
pingLabel.Text = "Ping: Calculating..."
pingLabel.BackgroundTransparency = 1

local timePlayedLabel = Instance.new("TextLabel", frame)
timePlayedLabel.Size = UDim2.new(0, 230, 0, 30)
timePlayedLabel.Position = UDim2.new(0, 10, 0, 160)
timePlayedLabel.Text = "Time Played: 0s"
timePlayedLabel.BackgroundTransparency = 1

local whiteScreenEnabled = true
local autoRejoinEnabled = true
local timePlayed = 0

-- FPS tracker
local RunService = game:GetService("RunService")
local fps = 0
local lastUpdate = tick()

local function formatTimePlayed(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60

	if hours > 0 then
		return string.format("%dh %dm %ds", hours, minutes, secs)
	elseif minutes > 0 then
		return string.format("%dm %ds", minutes, secs)
	else
		return string.format("%ds", secs)
	end
end

-- Time Played Tracker
RunService.Heartbeat:Connect(function(deltaTime)
	timePlayed += deltaTime
	timePlayedLabel.Text = "Time Played: " .. formatTimePlayed(math.floor(timePlayed))
end)

-- FPS Tracker
RunService.RenderStepped:Connect(function(deltaTime)
	fps = math.floor(1 / deltaTime)
	if tick() - lastUpdate >= 1 then
		fpsLabel.Text = "FPS: " .. fps
		lastUpdate = tick()
	end
end)

-- Ping tracker
local function updatePing()
	while true do
		local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
		pingLabel.Text = "Ping: " .. ping .. " ms"
		wait(1)
	end
end
spawn(updatePing)

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
			wait(rejoinTime * 60)
			game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
		else
			rejoinTimeInput.Text = "30"
		end
	end
end)

createWhiteScreenUI(true) -- White screen enabled on join
-- Initial execution of functions on join
optimizePerformance()

