-- Auto-Rejoin Script mit verstecktem UI
-- Zeigt die verbleibende Zeit bis zum Rejoin an

-- Dienste
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

-- Lua-Skript in Roblox (so weit es geht, könnte nicht direkt funktionieren auf Android)
local filePath = "playerData.json"

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

-- Funktion, um die Datei zu schreiben
local function writeCrashSignal()
    local playerData = {
        status = "crashed",
        placeId = game.PlaceId,
        playerName = game.Players.LocalPlayer.Name
    }

    -- Hier speichern wir die Datei über externe Mechanismen (z.B. via Emulator oder Tools)
    local jsonData = game:GetService("HttpService"):JSONEncode(playerData)
    writeToFile(filePath, jsonData)  -- Diese Funktion müsste von extern kommen, wie ein Emulator
end

-- Wenn Roblox abstürzt oder der Spieler gekickt wird
game:BindToClose(function()
    writeCrashSignal()
end)

task.spawn(updateTimer)
