-- File: StarterPlayerScripts/LanguageManager.client.luau
-- Gestisce la lingua globale del gioco (IT/EN)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- ============================================================
-- CREA IL VALORE GLOBALE DELLA LINGUA (accessibile da tutti)
-- ============================================================
local langFolder = Instance.new("Folder")
langFolder.Name = "LanguageSettings"
langFolder.Parent = ReplicatedStorage

local langValue = Instance.new("StringValue")
langValue.Name = "CurrentLanguage"
langValue.Value = "EN" -- Default: Inglese
langValue.Parent = langFolder

local langChanged = Instance.new("BindableEvent")
langChanged.Name = "LanguageChanged"
langChanged.Parent = langFolder

-- SetLanguageEvent è creato dal server (LanguageSetup.server.lua in ServerScriptService)
local setLanguageEvent = ReplicatedStorage:WaitForChild("SetLanguageEvent")

-- ============================================================
-- PULSANTE LINGUA - SEMPRE VISIBILE IN ALTO A DESTRA
-- ============================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LanguageGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local langBtn = Instance.new("TextButton")
langBtn.Name = "LangButton"
langBtn.Size = UDim2.new(0, 90, 0, 38)
langBtn.Position = UDim2.new(1, -100, 0, 10)
langBtn.AnchorPoint = Vector2.new(0, 0)
langBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.Text = "🇬🇧 EN"
langBtn.TextSize = 16
langBtn.Font = Enum.Font.Gotham
langBtn.BorderSizePixel = 0
langBtn.ZIndex = 100
langBtn.Parent = screenGui

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = langBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(255, 255, 255)
btnStroke.Thickness = 1.5
btnStroke.Parent = langBtn

-- ============================================================
-- TOGGLE LINGUA (invariato, aggiungiamo solo FireServer)
-- ============================================================
langBtn.MouseButton1Click:Connect(function()
	if langValue.Value == "EN" then
		langValue.Value = "IT"
		langBtn.Text = "🇮🇹 IT"
	else
		langValue.Value = "EN"
		langBtn.Text = "🇬🇧 EN"
	end
	langChanged:Fire(langValue.Value)
	-- Avvisa il server NPC della nuova lingua
	setLanguageEvent:FireServer(langValue.Value)
end)

-- OrderGui rimosso: gli ordini si vedono solo sul billboard sopra l'NPC

-- ============================================================
-- TRADUZIONE SHOP
-- Lo ShopGui ha i testi hardcoded in IT. Quando si passa a EN
-- li cerchiamo e li sostituiamo, e viceversa.
-- ============================================================
local SHOP = {
	-- { it = "testo italiano", en = "english text" }
	{ it = "Esplodi un player",    en = "Explode a player"  },
	{ it = "Esplodi TUTTI",        en = "Explode EVERYONE"  },
	{ it = "Ingrandisci (30s)",    en = "Enlarge (30s)"     },
	{ it = "Velocità 200 (30s)",   en = "Speed 200 (30s)"   },
	{ it = "Rimpicciolisci (30s)", en = "Shrink (30s)"      },
	{ it = "🛍️  SHOP",            en = "🛍️  SHOP"          }, -- uguale, ma per sicurezza
	{ it = "🎯  Scegli target",    en = "🎯  Choose target" },
}

-- Costruiamo una mappa bidirezionale: qualsiasi testo → { it, en }
local SHOP_MAP = {}
for _, entry in ipairs(SHOP) do
	SHOP_MAP[entry.it] = entry
	SHOP_MAP[entry.en] = entry
end

local function updateShop()
	local lang = langValue.Value
	local playerGui = player.PlayerGui
	local shopGui = playerGui:FindFirstChild("ShopGui")
	if not shopGui then return end

	for _, desc in ipairs(shopGui:GetDescendants()) do
		if desc:IsA("TextLabel") or desc:IsA("TextButton") then
			local entry = SHOP_MAP[desc.Text]
			if entry then
				desc.Text = (lang == "IT") and entry.it or entry.en
			end
		end
	end
end

-- Aggiorna shop quando cambia lingua
langChanged.Event:Connect(function()
	updateShop()
end)



-- ============================================================
-- DIZIONARIO NOMI CIBO (EN interno → nome tradotto)
-- ============================================================
local FOOD_NAMES = {
	EN = {
		Apple = "Apple", Banana = "Banana", Carrot = "Carrot",
		Cherry = "Cherry", ChickenWing = "Chicken Wing",
		Chocolate = "Chocolate", Eggplant = "Eggplant",
		Flour = "Flour", HoneyJar = "Honey Jar", OliveOil = "Olive Oil",
		Pork = "Pork", Rice = "Rice", Sugar = "Sugar",
		Tomato = "Tomato", Cheese = "Cheese", Bread = "Bread",
		Egg = "Egg", Fish = "Fish", Milk = "Milk",
		Pasta = "Pasta", Potato = "Potato",
		chicken_nugget = "Chicken Nugget",
		-- Piatti
		Burger = "Burger", Cake = "Cake", CookieDough = "Cookie Dough",
		Cookies = "Cookies", CutApple = "Cut Apple",
		FastFood = "Fast Food", FrenchFries = "French Fries",
		FrenchFriesCooked = "Fried Chips", FishBurger = "Fish Burger",
		MilkShakeApple = "Apple Milkshake", MilkShakeBanana = "Banana Milkshake",
		MilkShakeCherry = "Cherry Milkshake", MilkShakeChocolate = "Chocolate Milkshake",
		Omelette = "Omelette", Salad = "Salad",
		SlicedTomato = "Sliced Tomato", SpaghettiPomodoro = "Spaghetti al Pomodoro",
		CakeDough = "Cake Dough", ChickenNuggets = "Chicken Nuggets",
	},
	IT = {
		Apple = "Mela", Banana = "Banana", Carrot = "Carota",
		Cherry = "Ciliegia", ChickenWing = "Ala di Pollo",
		Chocolate = "Cioccolato", Eggplant = "Melanzana",
		Flour = "Farina", HoneyJar = "Vasetto di Miele", OliveOil = "Olio d'Oliva",
		Pork = "Maiale", Rice = "Riso", Sugar = "Zucchero",
		Tomato = "Pomodoro", Cheese = "Formaggio", Bread = "Pane",
		Egg = "Uovo", Fish = "Pesce", Milk = "Latte",
		Pasta = "Pasta", Potato = "Patata",
		chicken_nugget = "Nugget di Pollo",
		-- Piatti
		Burger = "Burger", Cake = "Torta", CookieDough = "Impasto Biscotti",
		Cookies = "Biscotti", CutApple = "Mela a Fette",
		FastFood = "Fast Food", FrenchFries = "Patatine Crude",
		FrenchFriesCooked = "Patatine Fritte", FishBurger = "Burger di Pesce",
		MilkShakeApple = "Milkshake alla Mela", MilkShakeBanana = "Milkshake alla Banana",
		MilkShakeCherry = "Milkshake alla Ciliegia", MilkShakeChocolate = "Milkshake al Cioccolato",
		Omelette = "Frittata", Salad = "Insalata",
		SlicedTomato = "Pomodoro a Fette", SpaghettiPomodoro = "Spaghetti al Pomodoro",
		CakeDough = "Impasto Torta", ChickenNuggets = "Nugget di Pollo",
	}
}

local function translateFood(foodName)
	local lang = langValue.Value
	local dict = FOOD_NAMES[lang] or FOOD_NAMES["EN"]
	return dict[foodName] or foodName -- fallback: nome originale
end

-- ============================================================
-- BILLBOARD NPC LOCALE (ogni client gestisce il proprio)
-- Il server manda chiavi, il client traduce e aggiorna il suo billboard
-- ============================================================
local BILLBOARD_TESTI = {
	EN = {
		waiting   = "⏳ Waiting...",
		vuole     = "🍴 I want: ",
		escl      = "!",
		grazie    = "✅ Thanks ",
		grazie2   = "! 🪙",
		sbagliato = "❌ That's not what I want!",
	},
	IT = {
		waiting   = "⏳ In attesa...",
		vuole     = "🍴 Voglio: ",
		escl      = "!",
		grazie    = "✅ Grazie ",
		grazie2   = "! 🪙",
		sbagliato = "❌ Non è quello che voglio!",
	}
}

local function BT() return BILLBOARD_TESTI[langValue.Value] or BILLBOARD_TESTI["EN"] end

-- Crea il billboard locale sopra la testa dell'NPC
-- (ogni client ha il suo, invisibile agli altri)
local localBillboard = nil

local function setupLocalBillboard()
	-- Cerca l'NPC tramite ExclamationBillboard creato dal server
	local npcModel = nil
	local head = nil

	-- Aspetta che ExclamationBillboard esista (il server lo crea all'avvio)
	for i = 1, 20 do
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name == "ExclamationBillboard" and obj:IsA("BillboardGui") then
				head = obj.Parent -- ExclamationBillboard.Parent = Head
				npcModel = head.Parent -- Head.Parent = NPC Model
				break
			end
		end
		if head then break end
		task.wait(0.5)
	end

	if not head then
		warn("[LanguageManager] Billboard NPC non trovato dopo 10s")
		return
	end

	local head = npcModel:FindFirstChild("Head")
	if not head then return end

	-- Rimuovi billboard locale precedente se esiste
	local oldBb = head:FindFirstChild("LocalOrderBillboard")
	if oldBb then oldBb:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "LocalOrderBillboard"
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 5, 0)
	billboard.AlwaysOnTop = false
	billboard.MaxDistance = 60
	billboard.LightInfluence = 1
	billboard.Parent = head

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
	bg.BorderSizePixel = 0
	bg.Parent = billboard

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = bg

	local label = Instance.new("TextLabel")
	label.Name = "OrderText"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(0, 0, 0)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Text = BT().waiting
	label.Parent = bg

	localBillboard = billboard
end

local function setLocalBillboardText(text, color)
	if not localBillboard or not localBillboard.Parent then
		setupLocalBillboard()
		if not localBillboard then return end
	end
	local bg = localBillboard:FindFirstChildOfClass("Frame")
	if bg then
		bg.BackgroundColor3 = color or Color3.fromRGB(255, 200, 50)
		local lbl = bg:FindFirstChild("OrderText")
		if lbl then lbl.Text = text end
	end
end

-- Salva ultimo stato billboard per poterlo ritradurre al cambio lingua
local lastBillboardStato = "WAITING"
local lastBillboardDato = ""
local lastBillboardColore = Color3.fromRGB(255, 200, 50)

local function applyBillboardStato(stato, dato, colore)
	local bt = BT()
	if stato == "ORDER" then
		-- Traduce il nome del cibo nella lingua corrente
		setLocalBillboardText(bt.vuole .. translateFood(dato) .. bt.escl, colore)
	elseif stato == "THANKS" then
		-- "dato" è il nome del player, non si traduce
		setLocalBillboardText(bt.grazie .. dato .. bt.grazie2, colore)
	elseif stato == "WRONG" then
		setLocalBillboardText(bt.sbagliato, colore)
	elseif stato == "WAITING" then
		setLocalBillboardText(bt.waiting, colore)
	end
end

-- Ascolta eventi dal server NPC e aggiorna il billboard locale
local npcBillboardEvent = ReplicatedStorage:WaitForChild("NpcBillboardEvent")
npcBillboardEvent.OnClientEvent:Connect(function(stato, dato, colore)
	lastBillboardStato = stato
	lastBillboardDato = dato
	lastBillboardColore = colore
	applyBillboardStato(stato, dato, colore)
end)

-- Quando cambia la lingua, riapplica l'ultimo stato tradotto nella nuova lingua
langChanged.Event:Connect(function()
	updateShop()
	applyBillboardStato(lastBillboardStato, lastBillboardDato, lastBillboardColore)
end)

-- Setup iniziale billboard dopo che il mondo è caricato
task.spawn(function()
	task.wait(3)
	setupLocalBillboard()
end)

-- Primo aggiornamento dopo 2s (aspetta che ShopGui sia creato)
task.spawn(function()
	task.wait(2)
	updateShop()
end)