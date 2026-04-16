local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 1. Creazione della GUI principale
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlsHUD"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- 2. Creazione del Frame (lo sfondo nero semitrasparente)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 75) -- Dimensioni rettangolo
frame.Position = UDim2.new(0, 20, 1, -95) -- In basso a sinistra
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.4 -- Trasparenza
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Bordi arrotondati
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 5)
corner.Parent = frame

-- 3. Testo per lo Sprint (Shift)
local sprintLabel = Instance.new("TextLabel")
sprintLabel.Name = "SprintLabel"
sprintLabel.Size = UDim2.new(1, -20, 0.5, 0)
sprintLabel.Position = UDim2.new(0, 10, 0, 5)
sprintLabel.BackgroundTransparency = 1
sprintLabel.Text = "SHIFT"
sprintLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sprintLabel.TextXAlignment = Enum.TextXAlignment.Left
sprintLabel.Font = Enum.Font.GothamBold
sprintLabel.TextSize = 24
sprintLabel.Parent = frame
