-- File: server/Food/apple.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = workspace:WaitForChild("Food")
local appleModel = foodFolder:WaitForChild("Apple")

-- Troviamo i 3 pezzi della mela (Fai attenzione alle maiuscole/minuscole esatte che mi hai scritto!)
local fruitPart = appleModel:WaitForChild("Fruit")
local leafPart = appleModel:WaitForChild("Leaf")
local sternPart = appleModel:WaitForChild("Stem")

-- 1. SALDIAMO I PEZZI A TERRA
-- Saldiamo la foglia al frutto
local weldLeaf = Instance.new("WeldConstraint")
weldLeaf.Part0 = fruitPart
weldLeaf.Part1 = leafPart
weldLeaf.Parent = fruitPart

-- Saldiamo il picciolo al frutto
local weldStern = Instance.new("WeldConstraint")
weldStern.Part0 = fruitPart
weldStern.Part1 = sternPart
weldStern.Parent = fruitPart

-- Sblocchiamo la fisica (Ricorda che su Roblox Studio devono avere la spunta su Anchored!)
fruitPart.Anchored = false
leafPart.Anchored = false
sternPart.Anchored = false

-- 2. DEFINIAMO I COLORI
-- Colori Freschi
local COLOR_FRESH_FRUIT = Color3.fromRGB(220, 20, 60)   -- Rosso acceso
local COLOR_FRESH_LEAF = Color3.fromRGB(50, 205, 50)    -- Verde brillante
local COLOR_FRESH_STERN = Color3.fromRGB(139, 69, 19)   -- Marrone legno

-- Colori da Recuperare (Ammaccata/Ossidata)
local COLOR_REC_FRUIT = Color3.fromRGB(160, 82, 45)     -- Rosso scuro/Marrone
local COLOR_REC_LEAF = Color3.fromRGB(154, 205, 50)     -- Verde ingiallito
local COLOR_REC_STERN = Color3.fromRGB(101, 67, 33)     -- Marrone scuro

-- Colori Avariati (Marcia)
local COLOR_SPOIL_FRUIT = Color3.fromRGB(80, 50, 30)    -- Marrone scuro/marcio
local COLOR_SPOIL_LEAF = Color3.fromRGB(139, 137, 137)  -- Grigio/Foglia secca morta
local COLOR_SPOIL_STERN = Color3.fromRGB(60, 40, 20)    -- Nero/Marrone scurissimo

-- Impostiamo i colori iniziali (Fresca)
fruitPart.Color = COLOR_FRESH_FRUIT
leafPart.Color = COLOR_FRESH_LEAF
sternPart.Color = COLOR_FRESH_STERN

fruitPart.Material = Enum.Material.SmoothPlastic 

-- 3. CREIAMO LA MELA E ATTIVIAMO IL PICKUP
-- Tempi: 18s per ammaccarsi, 36s per marcire
local apple = FoodBase.new(appleModel, 18, 36)

-- Passiamo il pezzo principale (Fruit) e il nome ("Mela")
apple:setupPickup(fruitPart, "Mela")

-- 4. GESTIAMO IL CAMBIO DI STATO
function apple:onStateChanged()
	if self.currentState == FoodBase.FoodState.RECOVERABLE then
		fruitPart.Color = COLOR_REC_FRUIT
		leafPart.Color = COLOR_REC_LEAF
		sternPart.Color = COLOR_REC_STERN
		
		fruitPart.Material = Enum.Material.Plastic 
		
		self.prompt.ActionText = "Raccogli (Ammaccata)"
		print("🍎 STATO CAMBIATO: La mela è ammaccata (ottima per una torta)!")
		
	elseif self.currentState == FoodBase.FoodState.SPOILED then
		fruitPart.Color = COLOR_SPOIL_FRUIT
		leafPart.Color = COLOR_SPOIL_LEAF
		sternPart.Color = COLOR_SPOIL_STERN
		
		-- Cambiamo materiale per farla sembrare marcia
		fruitPart.Material = Enum.Material.Mud 
		leafPart.Material = Enum.Material.Fabric -- Effetto strano per la foglia secca
		
		self.prompt.ActionText = "Raccogli (Marcia)"
		print("🍎 STATO CAMBIATO: La mela è marcia da buttare!")
	end
end

-- Avviamo il timer della mela!
apple:startAging()