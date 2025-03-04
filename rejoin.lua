-- Auto-Rejoin Script mit verstecktem UI
-- Zeigt die verbleibende Zeit bis zum Rejoin an

-- Dienste
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- UI-Schutz mit gethui()
local function getSafeUI()
    return gethui() or CoreGui
end

-- UI erstellen
local ui = Instance.new("ScreenGui")
ui.Name = "HiddenUI"
ui.Parent = getSafeUI()

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 50)
frame.Position = UDim2.new(0.5, -100, 0, 10)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Parent = ui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.TextScaled = true
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Parent = frame

-- Countdown & Auto-Rejoin
local countdown = 1080 -- 18 Minuten in Sekunden
local function updateTimer()
    while countdown > 0 do
        label.Text = "Rejoin in: " .. countdown .. "s"
        task.wait(1)
        countdown = countdown - 1
    end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
end

local player = game.Players.LocalPlayer
local filePath = "playerData.json"
local lastUpdateTime = tick()


-- Funktion, um regelmäßig die Datei zu aktualisieren
local function updatePlayerData()
    local playerData = {
        status = "active",
        placeId = game.PlaceId,
        playerName = player.Name,
        lastUpdate = tick()
    }

    -- Die Datei regelmäßig überschreiben (nur zu Demonstrationszwecken, funktioniert nur auf PC, nicht auf Android)
    local jsonData = game:GetService("HttpService"):JSONEncode(playerData)
    writeToFile(filePath, jsonData)  -- Ersetzt durch eine Methode zum Speichern der Datei auf deinem PC
end

-- Update alle 5 Sekunden
while true do
    updatePlayerData()
    wait(5)  -- Alle 5 Sekunden aktualisieren
end

task.spawn(updateTimer)
