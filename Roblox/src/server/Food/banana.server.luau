-- File: server/Food/banana.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = workspace:WaitForChild("Food")
local bananaModel = foodFolder:WaitForChild("Banana")

local mainPeel = bananaModel:WaitForChild("Meshes/bananaPeel_Cube")
local tipsPeel = bananaModel:WaitForChild("Meshes/bananaPeel_Cube.001")

-- Saldiamo i pezzi originali a terra per non farli smontare
local baseWeld = Instance.new("WeldConstraint")
baseWeld.Part0 = mainPeel
baseWeld.Part1 = tipsPeel
baseWeld.Parent = mainPeel

mainPeel.Anchored = false
tipsPeel.Anchored = false

local COLOR_FRESH = Color3.fromRGB(255, 225, 53)
local COLOR_RECOVERABLE = Color3.fromRGB(139, 69, 19)
local COLOR_SPOILED = Color3.fromRGB(30, 30, 30)

mainPeel.Color = COLOR_FRESH

-- Creiamo la logica dell'invecchiamento
local banana = FoodBase.new(bananaModel, 15, 30)

-- Diciamo al FoodBase di attivare la raccolta
-- Passiamo il pezzo principale (mainPeel) e il nome ("Banana")
-- ====================================================
banana:setupPickup(mainPeel, "Banana")

-- Quando cambia stato modifichiamo solo l'aspetto e il testo del pulsante
function banana:onStateChanged()
	if self.currentState == FoodBase.FoodState.RECOVERABLE then
		mainPeel.Color = COLOR_RECOVERABLE
		
		-- Possiamo accedere al pulsante "E" usando self.prompt
		self.prompt.ActionText = "Raccogli (Macchiata)"
		print("🍌 STATO CAMBIATO: La banana è macchiata!")
		
	elseif self.currentState == FoodBase.FoodState.SPOILED then
		mainPeel.Color = COLOR_SPOILED
		
		mainPeel.Material = Enum.Material.Grass
		tipsPeel.Material = Enum.Material.Grass
		
		self.prompt.ActionText = "Raccogli (Avariata)"
		print("🍌 STATO CAMBIATO: La banana è avariata!")
	end
end

-- Avviamo il timer
banana:startAging()