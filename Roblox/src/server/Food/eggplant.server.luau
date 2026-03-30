-- File: server/Food/eggplant.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = workspace:WaitForChild("Food")
local eggplantModel = foodFolder:WaitForChild("Eggplant")

-- Troviamo i 2 pezzi della melanzana (NOMI INVERTITI!)
local stemPart = eggplantModel:WaitForChild("MeshPart") -- Questa è la foglia/picciolo
local mainPart = eggplantModel:WaitForChild("EggTemplate") -- Questo è il corpo della melanzana

-- 1. SALDIAMO I PEZZI A TERRA (Così non si smonta)
local weld = Instance.new("WeldConstraint")
weld.Part0 = mainPart
weld.Part1 = stemPart
weld.Parent = mainPart

-- Sblocchiamo la fisica (Ricorda: su Roblox Studio devono partire con Anchored = true!)
mainPart.Anchored = false
stemPart.Anchored = false

-- 2. DEFINIAMO I COLORI
-- Colori Freschi
local COLOR_FRESH_BODY = Color3.fromRGB(75, 0, 130)  -- Viola scuro
local COLOR_FRESH_STEM = Color3.fromRGB(34, 139, 34) -- Verde vivo

-- Colori da Recuperare (Avvizzita/Opaca)
local COLOR_REC_BODY = Color3.fromRGB(105, 75, 120)  -- Viola sbiadito
local COLOR_REC_STEM = Color3.fromRGB(107, 142, 35)  -- Verde oliva

-- Colori Avariati (Marcia)
local COLOR_SPOIL_BODY = Color3.fromRGB(40, 30, 40)  -- Quasi nero/marcio
local COLOR_SPOIL_STEM = Color3.fromRGB(101, 67, 33) -- Marrone secco

-- Impostiamo i colori iniziali (Fresca)
mainPart.Color = COLOR_FRESH_BODY
stemPart.Color = COLOR_FRESH_STEM

-- 3. CREIAMO LA MELANZANA E ATTIVIAMO IL PICKUP
-- Tempi: 22s e 45s
local eggplant = FoodBase.new(eggplantModel, 22, 45)

eggplant:setupPickup(mainPart, "Melanzana")

-- 4. GESTIAMO IL CAMBIO DI STATO
function eggplant:onStateChanged()
	if self.currentState == FoodBase.FoodState.RECOVERABLE then
		mainPart.Color = COLOR_REC_BODY
		stemPart.Color = COLOR_REC_STEM
		
		mainPart.Material = Enum.Material.Plastic 
		
		self.prompt.ActionText = "Raccogli (Avvizzita)"
		print("🍆 STATO CAMBIATO: La melanzana è avvizzita!")
		
	elseif self.currentState == FoodBase.FoodState.SPOILED then
		mainPart.Color = COLOR_SPOIL_BODY
		stemPart.Color = COLOR_SPOIL_STEM
		
		mainPart.Material = Enum.Material.Mud
		stemPart.Material = Enum.Material.Wood
		
		self.prompt.ActionText = "Raccogli (Marcia)"
		print("🍆 STATO CAMBIATO: La melanzana è marcia da buttare!")
	end
end

-- Avviamo il timer della melanzana!
eggplant:startAging()