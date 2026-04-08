local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local moneyGui = Instance.new("ScreenGui")
moneyGui.Name = "MoneyHUD"
moneyGui.ResetOnSpawn = false
moneyGui.Parent = playerGui

local container = Instance.new("Frame")
container.Name = "MoneyContainer"
container.Size = UDim2.fromOffset(200, 50)
container.Position = UDim2.new(1, -20, 0, 20)
container.AnchorPoint = Vector2.new(1, 0)
container.BackgroundTransparency = 0.3
container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
container.Parent = moneyGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = container

local coinEmoji = Instance.new("TextLabel")
coinEmoji.Size = UDim2.fromScale(0.3, 1)
coinEmoji.BackgroundTransparency = 1
coinEmoji.Text = "💰"
coinEmoji.TextScaled = true
coinEmoji.Parent = container

local amountLabel = Instance.new("TextLabel")
amountLabel.Size = UDim2.fromScale(0.7, 1)
amountLabel.Position = UDim2.fromScale(0.3, 0)
amountLabel.BackgroundTransparency = 1
amountLabel.Text = "0"
amountLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
amountLabel.TextScaled = true
amountLabel.Font = Enum.Font.FredokaOne
amountLabel.Parent = container

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Parent = amountLabel

local changeLabel = Instance.new("TextLabel")
changeLabel.Size = UDim2.fromScale(1, 0.8)
changeLabel.Position = UDim2.new(0, 0, 1, 5)
changeLabel.BackgroundTransparency = 1
changeLabel.Visible = false
changeLabel.TextScaled = true
changeLabel.Font = Enum.Font.FredokaOne
changeLabel.Parent = container

-- LOGICA

local leaderstats = player:WaitForChild("leaderstats")
local coinsValue = leaderstats:WaitForChild("Coins") -- era "Money", ora "Coins"

local lastCoins = coinsValue.Value
amountLabel.Text = tostring(lastCoins)

local function animateChange(diff)
    changeLabel.Text = (diff > 0 and "+" or "") .. diff
    changeLabel.TextColor3 = diff > 0 and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    changeLabel.Visible = true
    changeLabel.TextTransparency = 0
    changeLabel.Position = UDim2.new(0, 0, 1, 5)

    local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = TweenService:Create(changeLabel, tweenInfo, {
        Position = UDim2.new(0, 0, 1, -60),
        TextTransparency = 1
    })
    tween:Play()
    tween.Completed:Connect(function()
        changeLabel.Visible = false
    end)
end

coinsValue.Changed:Connect(function(newValue)
    local diff = newValue - lastCoins
    lastCoins = newValue
    amountLabel.Text = tostring(newValue)
    if diff ~= 0 then
        animateChange(diff)
    end
end)