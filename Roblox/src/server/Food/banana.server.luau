-- File: server/Food/banana.server.luau
local Players = game:GetService("Players")
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = workspace:WaitForChild("Food")
local bananaModel = foodFolder:WaitForChild("Banana")

-- Troviamo i pezzi
local mainPeel = bananaModel:WaitForChild("Meshes/bananaPeel_Cube")
local tipsPeel = bananaModel:WaitForChild("Meshes/bananaPeel_Cube.001")

-- 1. LA FISICA: Saldiamo i pezzi originali così non si smontano mai!
local baseWeld = Instance.new("WeldConstraint")
baseWeld.Part0 = mainPeel
baseWeld.Part1 = tipsPeel
baseWeld.Parent = mainPeel

-- Ora possiamo sbloccare l'Anchor in totale sicurezza, la banana cadrà a terra intera
mainPeel.Anchored = false
tipsPeel.Anchored = false

local COLOR_FRESH = Color3.fromRGB(255, 225, 53)
local COLOR_RECOVERABLE = Color3.fromRGB(139, 69, 19)
local COLOR_SPOILED = Color3.fromRGB(30, 30, 30)

mainPeel.Color = COLOR_FRESH

-- CREIAMO L'INTERAZIONE (Il pulsante E)
local prompt = Instance.new("ProximityPrompt")
prompt.ActionText = "Raccogli Banana" 
prompt.ObjectText = "Banana"
prompt.HoldDuration = 0.5 
prompt.MaxActivationDistance = 8 
prompt.Parent = mainPeel 

local banana = FoodBase.new(bananaModel, 15, 30)

-- Quando cambia stato
function banana:onStateChanged()
	if self.currentState == FoodBase.FoodState.RECOVERABLE then
		mainPeel.Color = COLOR_RECOVERABLE
		
		prompt.ActionText = "Raccogli Banana (Macchiata)"
		print("🍌 STATO CAMBIATO: La banana è macchiata!")
		
	elseif self.currentState == FoodBase.FoodState.SPOILED then
		mainPeel.Color = COLOR_SPOILED
		
		mainPeel.Material = Enum.Material.Grass
		tipsPeel.Material = Enum.Material.Grass
		
		prompt.ActionText = "Raccogli Banana (Avariata)"
		print("🍌 STATO CAMBIATO: La banana è avariata!")
	end
end

banana:startAging()

-- COSA SUCCEDE QUANDO IL GIOCATORE PREME "E"
prompt.Triggered:Connect(function(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	local coins = leaderstats and leaderstats:FindFirstChild("Coins")
	
	-- Assegniamo le monete in base allo stato
	local nomeTool = "Banana"
	
	if banana.currentState == FoodBase.FoodState.FRESH then
		if coins then coins.Value += 3 end
		print("Hai raccolto una banana fresca! +3 Coins.")
		nomeTool = "Banana Fresca"
		
	elseif banana.currentState == FoodBase.FoodState.RECOVERABLE then
		if coins then coins.Value += 2 end
		print("Hai raccolto una banana macchiata! +2 Coins.")
		nomeTool = "Banana Macchiata"
		
	elseif banana.currentState == FoodBase.FoodState.SPOILED then
		if coins then coins.Value += 1 end
		print("Hai raccolto una banana avariata! +1 Coin.")
		nomeTool = "Banana Avariata"
	end
	
	-- Creiamo il Tool
	local tool = Instance.new("Tool")
	tool.Name = nomeTool
	tool.RequiresHandle = true
	tool.CanBeDropped = true -- 2. ABILITIAMO IL DROP! (Premi Backspace per lanciarla)
	
	-- Prepariamo i pezzi per la mano
	local handle = mainPeel:Clone()
	handle.Name = "Handle"
	handle:ClearAllChildren() -- Puliamo i vecchi Weld e il bottone "E" clonato
	
	local tips = tipsPeel:Clone()
	tips:ClearAllChildren()
	
	-- Saldiamo di nuovo i pezzi per la versione che tieni in mano
	local toolWeld = Instance.new("WeldConstraint")
	toolWeld.Part0 = handle
	toolWeld.Part1 = tips
	toolWeld.Parent = handle
	
	handle.Parent = tool
	tips.Parent = tool
	
	-- Mettiamo il Tool nello zaino del giocatore
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		tool.Parent = backpack
	end
	
	-- Distruggiamo la banana originale a terra
	bananaModel:Destroy()
end)