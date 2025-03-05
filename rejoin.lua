-- Auto-Rejoin Script mit verstecktem UI & Datei-Heartbeat
-- Zeigt die verbleibende Zeit bis zum Rejoin an und schreibt eine Datei für Python

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

-- Speicherpfad (Android)
local filePath = "roblox_heartbeat.txt"

-- Countdown & Auto-Rejoin
local countdown = 1080 -- 18 Minuten in Sekunden
local function updateTimer()
    while countdown > 0 do
        label.Text = "Rejoin in: " .. countdown .. "s | Heartbeat: ✅"
        sendHeartbeat()
        task.wait(1)
        countdown = countdown - 1
    end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
end

-- Funktion zum Schreiben der Herzschlag-Datei
function sendHeartbeat()
    local success, err = pcall(function()
        local data = os.time() .. " " .. tostring(game.PlaceId)
        writefile(filePath, data)
    end)
    if not success then
        warn("[Monitor]: Konnte Herzschlag nicht schreiben: " .. tostring(err))
        label.Text = "Rejoin in: " .. countdown .. "s | Heartbeat: ❌"
    end
end

-- Starte Herzschlag und Countdown
task.spawn(updateTimer)
