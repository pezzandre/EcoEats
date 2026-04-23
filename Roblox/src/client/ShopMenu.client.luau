local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local shopFolder = ReplicatedStorage:WaitForChild("ShopEvents")
local buyEffect = shopFolder:WaitForChild("BuyEffect")
local getPlayers = shopFolder:WaitForChild("GetPlayers")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ShopGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 0
screenGui.Parent = player.PlayerGui

-- Shop button
local shopButton = Instance.new("TextButton")
shopButton.Size = UDim2.new(0, 70, 0, 70)
shopButton.Position = UDim2.new(0, 16, 0.5, -35)
shopButton.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
shopButton.Text = "🛒"
shopButton.TextSize = 32
shopButton.Font = Enum.Font.GothamBold
shopButton.BorderSizePixel = 0
shopButton.Parent = screenGui

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0, 18)
c1.Parent = shopButton

local shadow1 = Instance.new("UIStroke")
shadow1.Color = Color3.fromRGB(200, 140, 0)
shadow1.Thickness = 2
shadow1.Parent = shopButton

-- Shop panel
local shopPanel = Instance.new("Frame")
shopPanel.Size = UDim2.new(0, 260, 0, 400)
shopPanel.Position = UDim2.new(0, 100, 0.5, -200)
shopPanel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
shopPanel.BorderSizePixel = 0
shopPanel.Visible = false
shopPanel.Parent = screenGui

local c2 = Instance.new("UICorner")
c2.CornerRadius = UDim.new(0, 20)
c2.Parent = shopPanel

local stroke2 = Instance.new("UIStroke")
stroke2.Color = Color3.fromRGB(255, 190, 0)
stroke2.Thickness = 2
stroke2.Parent = shopPanel

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
titleBar.BorderSizePixel = 0
titleBar.Parent = shopPanel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🛍️  SHOP"
titleLabel.TextColor3 = Color3.fromRGB(18, 18, 18)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Coins display
local coinsLabel = Instance.new("TextLabel")
coinsLabel.Size = UDim2.new(1, -20, 0, 28)
coinsLabel.Position = UDim2.new(0, 10, 0, 56)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Text = "🪙  ---"
coinsLabel.TextColor3 = Color3.fromRGB(255, 210, 50)
coinsLabel.TextSize = 17
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.TextXAlignment = Enum.TextXAlignment.Left
coinsLabel.Parent = shopPanel

local function updateCoins()
	local ls = player:FindFirstChild("leaderstats")
	if ls then
		local coins = ls:FindFirstChild("Coins")
		if coins then
			coinsLabel.Text = "🪙  " .. coins.Value
			coins.Changed:Connect(function(v)
				coinsLabel.Text = "🪙  " .. v
			end)
		end
	end
end
task.spawn(function()
	task.wait(1)
	updateCoins()
end)

-- Scroll items
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -100)
scroll.Position = UDim2.new(0, 8, 0, 92)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 190, 0)
scroll.BorderSizePixel = 0
scroll.Parent = shopPanel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = scroll

-- Player menu
local playerMenu = Instance.new("Frame")
playerMenu.Size = UDim2.new(0, 220, 0, 260)
playerMenu.Position = UDim2.new(0, 372, 0.5, -130)
playerMenu.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
playerMenu.BorderSizePixel = 0
playerMenu.Visible = false
playerMenu.Parent = screenGui

local c3 = Instance.new("UICorner")
c3.CornerRadius = UDim.new(0, 20)
c3.Parent = playerMenu

local stroke3 = Instance.new("UIStroke")
stroke3.Color = Color3.fromRGB(255, 190, 0)
stroke3.Thickness = 2
stroke3.Parent = playerMenu

local menuTitleBar = Instance.new("Frame")
menuTitleBar.Size = UDim2.new(1, 0, 0, 44)
menuTitleBar.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
menuTitleBar.BorderSizePixel = 0
menuTitleBar.Parent = playerMenu

local menuTitleCorner = Instance.new("UICorner")
menuTitleCorner.CornerRadius = UDim.new(0, 20)
menuTitleCorner.Parent = menuTitleBar

local menuTitleFix = Instance.new("Frame")
menuTitleFix.Size = UDim2.new(1, 0, 0.5, 0)
menuTitleFix.Position = UDim2.new(0, 0, 0.5, 0)
menuTitleFix.BackgroundColor3 = Color3.fromRGB(255, 190, 0)
menuTitleFix.BorderSizePixel = 0
menuTitleFix.Parent = menuTitleBar

local menuTitleLabel = Instance.new("TextLabel")
menuTitleLabel.Size = UDim2.new(1, 0, 1, 0)
menuTitleLabel.BackgroundTransparency = 1
menuTitleLabel.Text = "🎯  Scegli target"
menuTitleLabel.TextColor3 = Color3.fromRGB(18, 18, 18)
menuTitleLabel.TextSize = 18
menuTitleLabel.Font = Enum.Font.GothamBold
menuTitleLabel.Parent = menuTitleBar

local playerScroll = Instance.new("ScrollingFrame")
playerScroll.Size = UDim2.new(1, -16, 1, -52)
playerScroll.Position = UDim2.new(0, 8, 0, 48)
playerScroll.BackgroundTransparency = 1
playerScroll.ScrollBarThickness = 3
playerScroll.ScrollBarImageColor3 = Color3.fromRGB(255, 190, 0)
playerScroll.BorderSizePixel = 0
playerScroll.Parent = playerMenu

local playerLayout = Instance.new("UIListLayout")
playerLayout.Padding = UDim.new(0, 6)
playerLayout.Parent = playerScroll

-- Items list
local items = {
	{emoji = "💥", name = "Esplodi un player", effect = "explodeOne", needsTarget = true, cost = 10},
	{emoji = "💣", name = "Esplodi TUTTI", effect = "explodeAll", needsTarget = false, cost = 10},
	{emoji = "🔺", name = "Ingrandisci (30s)", effect = "bigOne", needsTarget = true, cost = 10},
	{emoji = "⚡", name = "Velocità 200 (30s)", effect = "speedOne", needsTarget = true, cost = 10},
	{emoji = "🔻", name = "Rimpicciolisci (30s)", effect = "smallOne", needsTarget = true, cost = 10},
}

local pendingEffect = nil

-- closePlayerMenu defined FIRST
local function closePlayerMenu()
	playerMenu.Visible = false
	pendingEffect = nil
	for _, c in ipairs(playerScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
end

-- Close button (after closePlayerMenu is defined)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -42, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 10
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	shopPanel.Visible = false
	closePlayerMenu()
end)

local function openPlayerMenu(effectType)
	print("🖱️ Apro menu player per effetto: " .. effectType)
	pendingEffect = effectType
	for _, c in ipairs(playerScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end

	local playerList = getPlayers:InvokeServer()
	print("👥 Players disponibili: " .. #playerList)

	if #playerList == 0 then
		print("⚠️ Nessun player disponibile")
		closePlayerMenu()
		return
	end

	for _, pName in ipairs(playerList) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 44)
		btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		btn.Text = "👤  " .. pName
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.TextSize = 16
		btn.Font = Enum.Font.GothamBold
		btn.BorderSizePixel = 0
		btn.Parent = playerScroll

		local bc = Instance.new("UICorner")
		bc.CornerRadius = UDim.new(0, 10)
		bc.Parent = btn

		local bs = Instance.new("UIStroke")
		bs.Color = Color3.fromRGB(60, 60, 60)
		bs.Thickness = 1
		bs.Parent = btn

		btn.MouseButton1Click:Connect(function()
			print("🎯 Selezionato: " .. pName)
			buyEffect:FireServer(pendingEffect, pName)
			closePlayerMenu()
		end)
	end

	playerScroll.CanvasSize = UDim2.new(0, 0, 0, #playerList * 50)
	playerMenu.Visible = true
end

-- Shop item buttons
for _, item in ipairs(items) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 62)
	btn.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	btn.BorderSizePixel = 0
	btn.Parent = scroll

	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 12)
	bc.Parent = btn

	local bs = Instance.new("UIStroke")
	bs.Color = Color3.fromRGB(50, 50, 50)
	bs.Thickness = 1
	bs.Parent = btn

	local emojiLabel = Instance.new("TextLabel")
	emojiLabel.Size = UDim2.new(0, 54, 1, 0)
	emojiLabel.Position = UDim2.new(0, 0, 0, 0)
	emojiLabel.BackgroundTransparency = 1
	emojiLabel.Text = item.emoji
	emojiLabel.TextSize = 28
	emojiLabel.Font = Enum.Font.GothamBold
	emojiLabel.Parent = btn

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -110, 0, 32)
	nameLabel.Position = UDim2.new(0, 54, 0, 6)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = item.name
	nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	nameLabel.TextSize = 15
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = btn

	local costLabel = Instance.new("TextLabel")
	costLabel.Size = UDim2.new(1, -110, 0, 20)
	costLabel.Position = UDim2.new(0, 54, 0, 36)
	costLabel.BackgroundTransparency = 1
	costLabel.Text = "🪙 " .. item.cost
	costLabel.TextColor3 = Color3.fromRGB(255, 190, 0)
	costLabel.TextSize = 13
	costLabel.Font = Enum.Font.Gotham
	costLabel.TextXAlignment = Enum.TextXAlignment.Left
	costLabel.Parent = btn

	local arrow = Instance.new("TextLabel")
	arrow.Size = UDim2.new(0, 30, 1, 0)
	arrow.Position = UDim2.new(1, -34, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "›"
	arrow.TextColor3 = Color3.fromRGB(255, 190, 0)
	arrow.TextSize = 28
	arrow.Font = Enum.Font.GothamBold
	arrow.Parent = btn

	btn.MouseButton1Click:Connect(function()
		if item.needsTarget then
			openPlayerMenu(item.effect)
		else
			buyEffect:FireServer(item.effect, nil)
		end
	end)
end

scroll.CanvasSize = UDim2.new(0, 0, 0, #items * 68)

-- Open/close shop
-- Chiudi quando il player muore
player.CharacterAdded:Connect(function()
	shopPanel.Visible = false
	closePlayerMenu()
end)

-- Open/close shop
shopButton.MouseButton1Click:Connect(function()
	shopPanel.Visible = not shopPanel.Visible
	if not shopPanel.Visible then
		closePlayerMenu()
	end
end)