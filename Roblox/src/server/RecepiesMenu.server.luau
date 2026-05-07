local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🏳️ Flag: "🇨🇭" = European/Swiss, "🇺🇸" = American
local recipes = {
	-- KitchenBoard
	{Name = "CutApple", Station = "🔪 KitchenBoard", Ingredients = {"🍎 Apple", "🍎 Apple"}, Flag = "🇨🇭"},
	{Name = "SlicedTomato", Station = "🔪 KitchenBoard", Ingredients = {"🍅 Tomato", "🍅 Tomato"}, Flag = "🇨🇭"},
	{Name = "FrenchFries", Station = "🔪 KitchenBoard", Ingredients = {"🥔 Potato", "🥔 Potato"}, Flag = "🇺🇸"},
	{Name = "Salad", Station = "🔪 KitchenBoard", Ingredients = {"🍅 Tomato", "🥕 Carrot", "🍶 OliveOil"}, Flag = "🇨🇭"},
	{Name = "Burger", Station = "🔪 KitchenBoard", Ingredients = {"🍞 Bread", "🥩 Pork", "🧀 Cheese"}, Flag = "🇺🇸"},
	{Name = "FishBurger", Station = "🔪 KitchenBoard", Ingredients = {"🍞 Bread", "🐟 Fish", "🧀 Cheese"}, Flag = "🇺🇸"},
	-- Pan
	{Name = "Omelette", Station = "🍳 Pan", Ingredients = {"🥚 Egg", "🍶 OliveOil"}, Flag = "🇨🇭"},

	-- Fryer
	{Name = "FrenchFriesCooked", Station = "🔥 Fryer", Ingredients = {"🍟 FrenchFries", "🍶 OliveOil"}, Flag = "🇺🇸"},
	{Name = "ChickenNuggets", Station = "🔥 Fryer", Ingredients = {"🍗 chicken_nugget", "🍶 OliveOil"}, Flag = "🇺🇸"},

	-- Mixer
	{Name = "MilkShakeChocolate", Station = "🥣 Mixer", Ingredients = {"🍫 Chocolate", "🥛 Milk"}, Flag = "🇺🇸"},
	{Name = "MilkShakeApple", Station = "🥣 Mixer", Ingredients = {"🍎 Apple", "🥛 Milk"}, Flag = "🇺🇸"},
	{Name = "MilkShakeCherry", Station = "🥣 Mixer", Ingredients = {"🍒 Cherry", "🥛 Milk"}, Flag = "🇺🇸"},
	{Name = "MilkShakeBanana", Station = "🥣 Mixer", Ingredients = {"🍌 Banana", "🥛 Milk"}, Flag = "🇺🇸"},
	{Name = "CookieDough", Station = "🥣 Mixer", Ingredients = {"🌾 Flour", "🍫 Chocolate", "🍬 Sugar", "🥚 Egg", "🥛 Milk"}, Flag = "🇺🇸"},
	{Name = "CakeDough", Station = "🥣 Mixer", Ingredients = {"🌾 Flour", "🥚 Egg", "🥛 Milk", "🍬 Sugar", "🍯 HoneyJar"}, Flag = "🇨🇭"},

	-- Microwave
	{Name = "Cookies", Station = "📦 Microwave", Ingredients = {"🍪 CookieDough"}, Flag = "🇺🇸"},
	{Name = "Cake", Station = "📦 Microwave", Ingredients = {"🎂 CakeDough"}, Flag = "🇨🇭"},

	-- Pot
	{Name = "SpaghettiPomodoro", Station = "🥘 Pot", Ingredients = {"🍝 Pasta", "🍅 Tomato", "💧 Water", "🍶 OliveOil"}, Flag = "🇨🇭"},

	-- Assemblaggi finali
	{Name = "FastFood", Station = "🔪 KitchenBoard", Ingredients = {"🍔 Burger", "🍟 FrenchFriesCooked"}, Flag = "🇺🇸"},
}

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RecipeGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 0
screenGui.Parent = player.PlayerGui

-- Tasto ricette
local recipeButton = Instance.new("TextButton")
recipeButton.Size = UDim2.new(0, 70, 0, 70)
recipeButton.Position = UDim2.new(1, -86, 1, -246)
recipeButton.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
recipeButton.Text = "📖"
recipeButton.TextSize = 32
recipeButton.Font = Enum.Font.GothamBold
recipeButton.BorderSizePixel = 0
recipeButton.Parent = screenGui

local c1 = Instance.new("UICorner")
c1.CornerRadius = UDim.new(0, 18)
c1.Parent = recipeButton

local stroke1 = Instance.new("UIStroke")
stroke1.Color = Color3.fromRGB(30, 80, 160)
stroke1.Thickness = 2
stroke1.Parent = recipeButton

-- Panel
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 360, 0, 520)
panel.Position = UDim2.new(0.5, -180, 0.5, -260)
panel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 10
panel.Parent = screenGui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 20)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.fromRGB(50, 120, 200)
panelStroke.Thickness = 2
panelStroke.Parent = panel

-- Title bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 52)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
titleBar.BorderSizePixel = 0
titleBar.Parent = panel

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 20)
titleCorner.Parent = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
titleFix.BorderSizePixel = 0
titleFix.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "📖  RECIPES"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 22
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.Position = UDim2.new(1, -44, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 11
closeBtn.Parent = titleBar

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
	panel.Visible = false
end)

-- Scroll
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -60)
scroll.Position = UDim2.new(0, 8, 0, 58)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 3
scroll.ScrollBarImageColor3 = Color3.fromRGB(50, 120, 200)
scroll.BorderSizePixel = 0
scroll.ZIndex = 10
scroll.Parent = panel

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 12)
layout.Parent = scroll

-- Crea card per ogni ricetta
local totalHeight = 0

for _, recipe in ipairs(recipes) do
	local cardHeight = 90 + (#recipe.Ingredients * 24)

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, 0, 0, cardHeight)
	card.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	card.BorderSizePixel = 0
	card.ZIndex = 10
	card.Parent = scroll

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 14)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Color = Color3.fromRGB(50, 120, 200)
	cardStroke.Thickness = 1.5
	cardStroke.Parent = card

	-- Barra colorata a sinistra
	local colorBar = Instance.new("Frame")
	colorBar.Size = UDim2.new(0, 5, 1, 0)
	colorBar.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
	colorBar.BorderSizePixel = 0
	colorBar.ZIndex = 11
	colorBar.Parent = card

	local colorBarCorner = Instance.new("UICorner")
	colorBarCorner.CornerRadius = UDim.new(0, 4)
	colorBarCorner.Parent = colorBar

	-- Bandiera provenienza
	local flagLabel = Instance.new("TextLabel")
	flagLabel.Size = UDim2.new(0, 36, 0, 30)
	flagLabel.Position = UDim2.new(1, -40, 0, 6)
	flagLabel.BackgroundTransparency = 1
	flagLabel.Text = recipe.Flag
	flagLabel.TextSize = 20
	flagLabel.Font = Enum.Font.Gotham
	flagLabel.TextXAlignment = Enum.TextXAlignment.Center
	flagLabel.TextYAlignment = Enum.TextYAlignment.Center
	flagLabel.ZIndex = 12
	flagLabel.Parent = card

	-- Nome ricetta
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -60, 0, 30)
	nameLabel.Position = UDim2.new(0, 16, 0, 8)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "🍽️  " .. recipe.Name
	nameLabel.TextColor3 = Color3.fromRGB(255, 210, 50)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.ZIndex = 11
	nameLabel.Parent = card

	-- Stazione
	local stationLabel = Instance.new("TextLabel")
	stationLabel.Size = UDim2.new(1, -20, 0, 22)
	stationLabel.Position = UDim2.new(0, 16, 0, 36)
	stationLabel.BackgroundTransparency = 1
	stationLabel.Text = "📍 " .. recipe.Station
	stationLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	stationLabel.TextSize = 13
	stationLabel.Font = Enum.Font.Gotham
	stationLabel.TextXAlignment = Enum.TextXAlignment.Left
	stationLabel.ZIndex = 11
	stationLabel.Parent = card

	-- Divisore
	local divider = Instance.new("Frame")
	divider.Size = UDim2.new(1, -20, 0, 1)
	divider.Position = UDim2.new(0, 10, 0, 62)
	divider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	divider.BorderSizePixel = 0
	divider.ZIndex = 11
	divider.Parent = card

	-- Label ingredienti titolo
	local ingTitle = Instance.new("TextLabel")
	ingTitle.Size = UDim2.new(1, -20, 0, 18)
	ingTitle.Position = UDim2.new(0, 16, 0, 66)
	ingTitle.BackgroundTransparency = 1
	ingTitle.Text = "Ingredients:"
	ingTitle.TextColor3 = Color3.fromRGB(120, 120, 120)
	ingTitle.TextSize = 11
	ingTitle.Font = Enum.Font.Gotham
	ingTitle.TextXAlignment = Enum.TextXAlignment.Left
	ingTitle.ZIndex = 11
	ingTitle.Parent = card

	-- Ingredienti
	for j, ingredient in ipairs(recipe.Ingredients) do
		local ingLabel = Instance.new("TextLabel")
		ingLabel.Size = UDim2.new(1, -20, 0, 22)
		ingLabel.Position = UDim2.new(0, 16, 0, 84 + (j - 1) * 24)
		ingLabel.BackgroundTransparency = 1
		ingLabel.Text = "  ▸  " .. ingredient
		ingLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
		ingLabel.TextSize = 13
		ingLabel.Font = Enum.Font.Gotham
		ingLabel.TextXAlignment = Enum.TextXAlignment.Left
		ingLabel.ZIndex = 11
		ingLabel.Parent = card
	end

	totalHeight = totalHeight + cardHeight + 12
end

scroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)

-- Apri/chiudi
recipeButton.MouseButton1Click:Connect(function()
	panel.Visible = not panel.Visible
end)