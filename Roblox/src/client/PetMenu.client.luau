local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local petFolder = ReplicatedStorage:WaitForChild("PetEvents")
local buyPetEvent = petFolder:WaitForChild("BuyPet")
local equipPetEvent = petFolder:WaitForChild("EquipPet")
local sellPetEvent = petFolder:WaitForChild("SellPet")
local getPetListEvent = petFolder:WaitForChild("GetPetList")
local getOwnedPetsEvent = petFolder:WaitForChild("GetOwnedPets")

local PET_COST = 100

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PetGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- Pet button
local petButton = Instance.new("TextButton")
petButton.Size = UDim2.new(0, 70, 0, 70)
petButton.Position = UDim2.new(1, -86, 1, -166)
petButton.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
petButton.Text = "🐾"
petButton.TextSize = 32
petButton.Font = Enum.Font.GothamBold
petButton.BorderSizePixel = 0
petButton.Parent = screenGui

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0, 18)
c1.Parent = petButton

local stroke1 = Instance.new("UIStroke")
stroke1.Color = Color3.fromRGB(60, 130, 60)
stroke1.Thickness = 2
stroke1.Parent = petButton

-- Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 300, 0, 480)
panel.Position = UDim2.new(1, -390, 1, -560)
panel.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
panel.BorderSizePixel = 0
panel.Visible = false
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 20)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(100, 180, 100)
panelStroke.Thickness = 2
panelStroke.Parent = panel

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🐾  PET SHOP"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -42, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 10
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	panel.Visible = false
end)

-- Tabs
local tabShop = Instance.new("TextButton")
tabShop.Size = UDim2.new(0.5, -6, 0, 34)
tabShop.Position = UDim2.new(0, 6, 0, 58)
tabShop.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
tabShop.TextColor3 = Color3.fromRGB(255, 255, 255)
tabShop.Text = "🛒 Shop"
tabShop.TextSize = 14
tabShop.Font = Enum.Font.GothamBold
tabShop.BorderSizePixel = 0
tabShop.Parent = panel

local tabShopCorner = Instance.new("UICorner")
tabShopCorner.CornerRadius = UDim.new(0, 10)
tabShopCorner.Parent = tabShop

local tabMyPets = Instance.new("TextButton")
tabMyPets.Size = UDim2.new(0.5, -6, 0, 34)
tabMyPets.Position = UDim2.new(0.5, 0, 0, 58)
tabMyPets.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tabMyPets.TextColor3 = Color3.fromRGB(180, 180, 180)
tabMyPets.Text = "🐾 My Pets"
tabMyPets.TextSize = 14
tabMyPets.Font = Enum.Font.GothamBold
tabMyPets.BorderSizePixel = 0
tabMyPets.Parent = panel

local tabMyPetsCorner = Instance.new("UICorner")
tabMyPetsCorner.CornerRadius = UDim.new(0, 10)
tabMyPetsCorner.Parent = tabMyPets

-- Scroll shop
local shopScroll = Instance.new("ScrollingFrame")
shopScroll.Size = UDim2.new(1, -16, 1, -108)
shopScroll.Position = UDim2.new(0, 8, 0, 100)
shopScroll.BackgroundTransparency = 1
shopScroll.ScrollBarThickness = 3
shopScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 180, 100)
shopScroll.BorderSizePixel = 0
shopScroll.Visible = true
shopScroll.Parent = panel

local shopLayout = Instance.new("UIListLayout")
shopLayout.Padding = UDim.new(0, 6)
shopLayout.Parent = shopScroll

-- Scroll my pets
local myPetsScroll = Instance.new("ScrollingFrame")
myPetsScroll.Size = UDim2.new(1, -16, 1, -108)
myPetsScroll.Position = UDim2.new(0, 8, 0, 100)
myPetsScroll.BackgroundTransparency = 1
myPetsScroll.ScrollBarThickness = 3
myPetsScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 180, 100)
myPetsScroll.BorderSizePixel = 0
myPetsScroll.Visible = false
myPetsScroll.Parent = panel

local myPetsLayout = Instance.new("UIListLayout")
myPetsLayout.Padding = UDim.new(0, 6)
myPetsLayout.Parent = myPetsScroll

-- Tab switching
tabShop.MouseButton1Click:Connect(function()
	shopScroll.Visible = true
	myPetsScroll.Visible = false
	tabShop.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
	tabShop.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabMyPets.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	tabMyPets.TextColor3 = Color3.fromRGB(180, 180, 180)
end)

tabMyPets.MouseButton1Click:Connect(function()
	shopScroll.Visible = false
	myPetsScroll.Visible = true
	tabMyPets.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
	tabMyPets.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabShop.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	tabShop.TextColor3 = Color3.fromRGB(180, 180, 180)
	loadMyPets()
end)

-- Carica shop
local function loadShop()
	for _, c in ipairs(shopScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	local petList = getPetListEvent:InvokeServer()
	local data = getOwnedPetsEvent:InvokeServer()

	for _, petName in ipairs(petList) do
		local isOwned = false
		for _, owned in ipairs(data.owned) do
			if owned == petName then isOwned = true break end
		end

		local card = Instance.new("Frame")
		card.Size = UDim2.new(1, 0, 0, 60)
		card.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		card.BorderSizePixel = 0
		card.Parent = shopScroll

		local cardCorner = Instance.new("UICorner")
		cardCorner.CornerRadius = UDim.new(0, 12)
		cardCorner.Parent = card

		local cardStroke = Instance.new("UIStroke")
		cardStroke.Color = isOwned and Color3.fromRGB(100, 180, 100) or Color3.fromRGB(50, 50, 50)
		cardStroke.Thickness = 1
		cardStroke.Parent = card

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -120, 1, 0)
		nameLabel.Position = UDim2.new(0, 14, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = "🐾 " .. petName
		nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
		nameLabel.TextSize = 14
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = card

		local buyBtn = Instance.new("TextButton")
		buyBtn.Size = UDim2.new(0, 90, 0, 36)
		buyBtn.Position = UDim2.new(1, -100, 0.5, -18)
		buyBtn.BorderSizePixel = 0
		buyBtn.Font = Enum.Font.GothamBold
		buyBtn.TextSize = 13
		buyBtn.Parent = card

		local buyCorner = Instance.new("UICorner")
		buyCorner.CornerRadius = UDim.new(0, 10)
		buyCorner.Parent = buyBtn

		if isOwned then
			buyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			buyBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
			buyBtn.Text = "✓ Owned"
		else
			buyBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
			buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			buyBtn.Text = "🪙 " .. PET_COST

			buyBtn.MouseButton1Click:Connect(function()
				buyPetEvent:FireServer(petName)
				buyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
				buyBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
				buyBtn.Text = "✓ Owned"
				cardStroke.Color = Color3.fromRGB(100, 180, 100)
			end)
		end
	end

	shopScroll.CanvasSize = UDim2.new(0, 0, 0, #petList * 66)
end

-- Carica my pets
function loadMyPets()
	for _, c in ipairs(myPetsScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end

	local data = getOwnedPetsEvent:InvokeServer()

	if #data.owned == 0 then
		local emptyLabel = Instance.new("TextLabel")
		emptyLabel.Size = UDim2.new(1, 0, 0, 50)
		emptyLabel.BackgroundTransparency = 1
		emptyLabel.Text = "No pets yet! Buy some 🐾"
		emptyLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
		emptyLabel.TextSize = 14
		emptyLabel.Font = Enum.Font.Gotham
		emptyLabel.Parent = myPetsScroll
		return
	end

	for _, petName in ipairs(data.owned) do
		local isEquipped = false
		for _, e in ipairs(data.equipped) do
			if e == petName then isEquipped = true break end
		end

		local card = Instance.new("Frame")
		card.Size = UDim2.new(1, 0, 0, 60)
		card.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
		card.BorderSizePixel = 0
		card.Parent = myPetsScroll

		local cardCorner = Instance.new("UICorner")
		cardCorner.CornerRadius = UDim.new(0, 12)
		cardCorner.Parent = card

		local cardStroke = Instance.new("UIStroke")
		cardStroke.Color = isEquipped and Color3.fromRGB(100, 180, 100) or Color3.fromRGB(50, 50, 50)
		cardStroke.Thickness = 1
		cardStroke.Parent = card

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -210, 1, 0)
		nameLabel.Position = UDim2.new(0, 14, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = (isEquipped and "✅ " or "💤 ") .. petName
		nameLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
		nameLabel.TextSize = 13
		nameLabel.Font = Enum.Font.GothamBold
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.Parent = card

		-- Bottone equip (a sinistra)
		local equipBtn = Instance.new("TextButton")
		equipBtn.Size = UDim2.new(0, 90, 0, 36)
		equipBtn.Position = UDim2.new(1, -200, 0.5, -18)
		equipBtn.BorderSizePixel = 0
		equipBtn.Font = Enum.Font.GothamBold
		equipBtn.TextSize = 13
		equipBtn.Parent = card

		local equipCorner = Instance.new("UICorner")
		equipCorner.CornerRadius = UDim.new(0, 10)
		equipCorner.Parent = equipBtn

		-- Bottone sell (a destra)
		local sellBtn = Instance.new("TextButton")
		sellBtn.Size = UDim2.new(0, 90, 0, 36)
		sellBtn.Position = UDim2.new(1, -100, 0.5, -18)
		sellBtn.BackgroundColor3 = Color3.fromRGB(180, 120, 0)
		sellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		sellBtn.Text = "🪙 Sell"
		sellBtn.TextSize = 13
		sellBtn.Font = Enum.Font.GothamBold
		sellBtn.BorderSizePixel = 0
		sellBtn.Parent = card

		local sellCorner = Instance.new("UICorner")
		sellCorner.CornerRadius = UDim.new(0, 10)
		sellCorner.Parent = sellBtn

		-- Stato corrente equipaggiamento
		local currentlyEquipped = isEquipped

		local function updateEquipBtn()
			if currentlyEquipped then
				equipBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
				equipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				equipBtn.Text = "Unequip"
				nameLabel.Text = "✅ " .. petName
				cardStroke.Color = Color3.fromRGB(100, 180, 100)
			else
				equipBtn.BackgroundColor3 = Color3.fromRGB(100, 180, 100)
				equipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				equipBtn.Text = "Equip"
				nameLabel.Text = "💤 " .. petName
				cardStroke.Color = Color3.fromRGB(50, 50, 50)
			end
		end

		updateEquipBtn()

		equipBtn.MouseButton1Click:Connect(function()
			currentlyEquipped = not currentlyEquipped
			equipPetEvent:FireServer(petName, currentlyEquipped)
			updateEquipBtn()
		end)

		sellBtn.MouseButton1Click:Connect(function()
			sellPetEvent:FireServer(petName)
			card:Destroy()
			task.delay(0.3, loadShop)
		end)
	end

	myPetsScroll.CanvasSize = UDim2.new(0, 0, 0, #data.owned * 66)
end

-- Apri/chiudi
petButton.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
	if panel.Visible then
		loadShop()
	end
end)