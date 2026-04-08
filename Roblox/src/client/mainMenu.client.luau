-- File: StarterPlayer/StarterPlayerScripts/MainMenu.client.luau
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. SCHERMO PRINCIPALE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EcoEatsGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- 2. SFONDO PRINCIPALE
local mainBackground = Instance.new("Frame")
mainBackground.Size = UDim2.fromScale(1, 1)
mainBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainBackground.Parent = screenGui

-- CONTENITORE CENTRALE
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.fromScale(0.6, 0.7) 
contentFrame.Position = UDim2.fromScale(0.2, 0.15) 
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainBackground

-- LAYOUT AUTOMATICO
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, 25) 
uiListLayout.Parent = contentFrame

-- 3. TITOLO
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.fromScale(1, 0.35) -- MODIFICATO: da 0.25 a 0.35 per renderlo più grande!
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "EcoEats"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.Parent = contentFrame

local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 3
titleStroke.Color = Color3.fromRGB(255, 255, 255)
titleStroke.Parent = titleLabel

-- 4. PULSANTE PLAY
local playButton = Instance.new("TextButton")
playButton.Name = "PlayButton"
playButton.Size = UDim2.fromScale(0.5, 0.15) 
playButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34) 
playButton.Text = "PLAY"
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.TextScaled = true
playButton.Font = Enum.Font.Gotham
playButton.Parent = contentFrame

local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 15) 
playCorner.Parent = playButton

local playStroke = Instance.new("UIStroke")
playStroke.Thickness = 2
playStroke.Color = Color3.fromRGB(255, 255, 255)
playStroke.Parent = playButton

-- 5. PULSANTE ISTRUZIONI
local infoButton = Instance.new("TextButton")
infoButton.Name = "InfoButton"
infoButton.Size = UDim2.fromScale(0.35, 0.1) 
infoButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180) 
infoButton.Text = "HOW TO PLAY"
infoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infoButton.TextScaled = true
infoButton.Font = Enum.Font.FredokaOne
infoButton.Parent = contentFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = infoButton

---------------------------------------------------------------------------------
-- SISTEMA DEL PANNELLO ISTRUZIONI (MODAL)
---------------------------------------------------------------------------------

-- Pannello istruzioni
local infoModal = Instance.new("Frame")
infoModal.Name = "InfoModal"
infoModal.Size = UDim2.fromScale(0.6, 0.6) 
infoModal.Position = UDim2.fromScale(0.2, 0.2) 
infoModal.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
infoModal.Visible = false 
infoModal.ZIndex = 10 
infoModal.Parent = mainBackground

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 20)
modalCorner.Parent = infoModal

-- Testo delle istruzioni (Ripulito dal duplicato)
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.fromScale(0.9, 0.8)
infoText.Position = UDim2.fromScale(0.05, 0.1)
infoText.BackgroundTransparency = 1
infoText.Text = [[
Welcome to EcoEats! 🌍🍳

1. GATHER fresh ingredients around the kitchen.
2. COOK recipes by adding ingredients to Pans and Ovens.
3. WATCH OUT! Food spoils over time. Don't let it rot!
4. RECYCLE! Throw spoiled food in the Compost Bin, not the trash.

Cook fast, waste less, and become the ultimate Eco-Chef!
]]
infoText.TextColor3 = Color3.fromRGB(240, 240, 240)
infoText.TextScaled = false          
infoText.TextSize = 24                               -- MODIFICATO: Ingrandito da 18 a 24
infoText.TextWrapped = true          
infoText.TextYAlignment = Enum.TextYAlignment.Center -- MODIFICATO: Centrato sulla Y (invece di Top)
infoText.Font = Enum.Font.FredokaOne
infoText.ZIndex = 11                 
infoText.Parent = infoModal

-- Pulsante Chiudi (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 40, 0, 40) 
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.Position = UDim2.new(1, -10, 0, 10)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50) 
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.FredokaOne
closeButton.ZIndex = 11 
closeButton.Parent = infoModal

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0) 
closeCorner.Parent = closeButton

---------------------------------------------------------------------------------
-- LOGICA DEI CLICK
---------------------------------------------------------------------------------

playButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

infoButton.MouseButton1Click:Connect(function()
    infoModal.Visible = true
end)

closeButton.MouseButton1Click:Connect(function()
    infoModal.Visible = false
end)