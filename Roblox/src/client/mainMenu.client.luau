-- File: StarterPlayer/StarterPlayerScripts/MainMenu.client.luau
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. SCHERMO PRINCIPALE (IgnoreGuiInset = true per Full Screen totale)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EcoEatsGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true -- FIX: Copre anche la barra superiore di Roblox
screenGui.Parent = playerGui

-- 2. SFONDO PRINCIPALE
local mainBackground = Instance.new("Frame")
mainBackground.Size = UDim2.fromScale(1, 1)
mainBackground.BackgroundColor3 = Color3.fromRGB(20, 20, 30) -- Blu notte scuro
mainBackground.Parent = screenGui

-- CONTENITORE CENTRALE (Per allineare tutto perfettamente)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.fromScale(0.6, 0.7) -- Prende il 60% in larghezza e 70% in altezza
contentFrame.Position = UDim2.fromScale(0.2, 0.15) -- Centrato
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainBackground

-- LAYOUT AUTOMATICO (Mette gli elementi in colonna e li centra)
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Vertical
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, 25) -- Spazio fisso di 25 pixel tra gli elementi
uiListLayout.Parent = contentFrame

-- 3. TITOLO (EcoEats con bordo)
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.fromScale(1, 0.25) -- Largo quanto il contenitore
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "EcoEats"
titleLabel.TextColor3 = Color3.fromRGB(255, 215, 0) -- Oro brillante
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.Parent = contentFrame

-- Bordo del titolo per leggibilità
local titleStroke = Instance.new("UIStroke")
titleStroke.Thickness = 3
titleStroke.Color = Color3.fromRGB(255, 255, 255) -- Bordo bianco
titleStroke.Parent = titleLabel

-- 4. PULSANTE PLAY (Verde con angoli tondi)
local playButton = Instance.new("TextButton")
playButton.Name = "PlayButton"
playButton.Size = UDim2.fromScale(0.5, 0.15) -- Più largo
playButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34) -- Verde foresta
playButton.Text = "PLAY"
playButton.TextColor3 = Color3.fromRGB(255, 255, 255)
playButton.TextScaled = true
playButton.Font = Enum.Font.Gotham
playButton.Parent = contentFrame

-- Angoli tondi per Play
local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 15) -- Arrotondamento di 15px
playCorner.Parent = playButton

-- Bordo sottile per Play
local playStroke = Instance.new("UIStroke")
playStroke.Thickness = 2
playStroke.Color = Color3.fromRGB(255, 255, 255)
playStroke.Parent = playButton

-- 5. PULSANTE ISTRUZIONI (Blu, più piccolo)
local infoButton = Instance.new("TextButton")
infoButton.Name = "InfoButton"
infoButton.Size = UDim2.fromScale(0.35, 0.1) -- Più piccolo del Play button
infoButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180) -- Blu acciaio
infoButton.Text = "HOW TO PLAY"
infoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
infoButton.TextScaled = true
infoButton.Font = Enum.Font.FredokaOne
infoButton.Parent = contentFrame

-- Angoli tondi per Istruzioni
local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = infoButton

---------------------------------------------------------------------------------
-- SISTEMA DEL PANNELLO ISTRUZIONI (MODAL)
---------------------------------------------------------------------------------

-- Pannello istruzioni (nascosto di default)
local infoModal = Instance.new("Frame")
infoModal.Name = "InfoModal"
infoModal.Size = UDim2.fromScale(0.5, 0.5) -- 50% dello schermo
infoModal.Position = UDim2.fromScale(0.25, 0.25) -- Centrato
infoModal.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
infoModal.Visible = false -- Nascosto
infoModal.ZIndex = 10 -- Sopra a tutto il resto
infoModal.Parent = mainBackground

local modalCorner = Instance.new("UICorner")
modalCorner.CornerRadius = UDim.new(0, 20)
modalCorner.Parent = infoModal

-- Testo delle istruzioni
local infoText = Instance.new("TextLabel")
infoText.Size = UDim2.fromScale(0.8, 0.7)
infoText.Position = UDim2.fromScale(0.1, 0.1)
infoText.BackgroundTransparency = 1
infoText.Text = "1. Collect Apple & Banana.\n2. Put them in the Pan.\n3. Make FastFood!\nDon't waste food!"
infoText.TextColor3 = Color3.fromRGB(240, 240, 240)
infoText.TextScaled = true
infoText.Font = Enum.Font.FredokaOne
infoText.Parent = infoModal

-- Pulsante Chiudi (X in alto a destra)
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
-- Usiamo grandezze fisse (40x40 pixel) per non farlo deformare
closeButton.Size = UDim2.new(0, 40, 0, 40) 
closeButton.AnchorPoint = Vector2.new(1, 0) -- Lo "agganciamo" dall'angolo in alto a destra
closeButton.Position = UDim2.new(1, -10, 0, 10) -- Lo mettiamo a 10 pixel dai bordi
closeButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50) -- Rosso vivo
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.FredokaOne
closeButton.ZIndex = 11 
closeButton.Parent = infoModal

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0) -- Cerchio perfetto
closeCorner.Parent = closeButton

-- La logica per chiudere
closeButton.MouseButton1Click:Connect(function()
    infoModal.Visible = false
end)

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0) -- Cerchio perfetto
closeCorner.Parent = closeButton

---------------------------------------------------------------------------------
-- LOGICA DEI CLICK
---------------------------------------------------------------------------------

-- Click su PLAY: distrugge il menu
playButton.MouseButton1Click:Connect(function()
    print("▶️ Play clicked! Game started.")
    screenGui:Destroy()
end)

-- Click su ISTRUZIONI: mostra il pannello
infoButton.MouseButton1Click:Connect(function()
    infoModal.Visible = true
end)

-- Click su CHIUDI (X): nasconde il pannello
closeButton.MouseButton1Click:Connect(function()
    infoModal.Visible = false
end)