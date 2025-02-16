local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local pathToLabels = LocalPlayer.PlayerGui.Main.CelebrationShop.Content.Frame
local lastTexts = {}
local changesLog = {}

local function logChange(text, index)
    local changeEntry = {
        labelIndex = index,
        newText = text,
        timestamp = os.time()
    }
    table.insert(changesLog, changeEntry)

    local jsonData = HttpService:JSONEncode(changesLog)
    writefile("LabelChangesLog.json", jsonData)
    print(changeEntry)
end

local function checkLabels()
    for i = 1, 6 do
        local labelPath = pathToLabels[tostring(i)].Top.TextLabel
        local currentText = labelPath.Text

        if lastTexts[i] ~= currentText then
            lastTexts[i] = currentText
            logChange(currentText, i)
        end
    end
end

local function toggleUI()
    local shop = LocalPlayer.PlayerGui.Main.CelebrationShop
    local isOpen = shop:GetAttribute("Opened")
    shop:SetAttribute("Opened", not isOpen)
end

toggleUI()

while true do
    checkLabels()
    task.wait(1)
end

