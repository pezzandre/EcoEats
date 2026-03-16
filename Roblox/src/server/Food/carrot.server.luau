-- File: server/Food/carrot.server.luau
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = workspace:WaitForChild("Food")
local carrotModel = foodFolder:WaitForChild("Carrot")

-- Troviamo i 3 pezzi della carota
-- Nota: siccome la parte principale si chiama "Carrot" come il modello, usiamo nomi chiari per le variabili
local mainCarrot = carrotModel:WaitForChild("Carrot")
local headPart = carrotModel:WaitForChild("Head")
local herbPart = carrotModel:WaitForChild("Herb")

-- 1. SALDIAMO I PEZZI A TERRA (Così non si smonta)
local weldHead = Instance.new("WeldConstraint")
weldHead.Part0 = mainCarrot
weldHead.Part1 = headPart
weldHead.Parent = mainCarrot

local weldHerb = Instance.new("WeldConstraint")
weldHerb.Part0 = mainCarrot
weldHerb.Part1 = herbPart
weldHerb.Parent = mainCarrot

-- Sblocchiamo la fisica
mainCarrot.Anchored = false
headPart.Anchored = false
herbPart.Anchored = false

-- 2. DEFINIAMO I COLORI
-- Colori Freschi
local COLOR_FRESH_CARROT = Color3.fromRGB(255, 140, 0) -- Arancione vivo
local COLOR_FRESH_HERB = Color3.fromRGB(50, 205, 50)   -- Verde brillante

-- Colori da Recuperare (Molliccia/Avvizzita per minestrone)
local COLOR_REC_CARROT = Color3.fromRGB(200, 100, 30)  -- Arancione spento
local COLOR_REC_HERB = Color3.fromRGB(107, 142, 35)    -- Verde oliva/secco

-- Colori Avariati (Marcia/Liquida per compost)
local COLOR_SPOIL_CARROT = Color3.fromRGB(75, 50, 25)  -- Marrone scuro
local COLOR_SPOIL_HERB = Color3.fromRGB(47, 79, 79)    -- Grigio/Verde marcio

-- Impostiamo i colori iniziali (Fresca)
mainCarrot.Color = COLOR_FRESH_CARROT
headPart.Color = COLOR_FRESH_HERB
herbPart.Color = COLOR_FRESH_HERB

-- 3. CREIAMO LA CAROTA E ATTIVIAMO IL PICKUP
-- Mettiamo tempi leggermente diversi dalla banana, es: 20s e 40s
local carrot = FoodBase.new(carrotModel, 20, 40)

-- Magia! Passiamo il pezzo principale e il nome al FoodBase
carrot:setupPickup(mainCarrot, "Carota")

-- 4. GESTIAMO IL CAMBIO DI STATO
function carrot:onStateChanged()
	if self.currentState == FoodBase.FoodState.RECOVERABLE then
		mainCarrot.Color = COLOR_REC_CARROT
		headPart.Color = COLOR_REC_HERB
		herbPart.Color = COLOR_REC_HERB
		
		self.prompt.ActionText = "Raccogli (Avvizzita)"
		print("🥕 STATO CAMBIATO: La carota è molliccia!")
		
	elseif self.currentState == FoodBase.FoodState.SPOILED then
		mainCarrot.Color = COLOR_SPOIL_CARROT
		headPart.Color = COLOR_SPOIL_HERB
		herbPart.Color = COLOR_SPOIL_HERB
		
		-- Cambiamo materiale per farla sembrare marcia
		mainCarrot.Material = Enum.Material.Mud
		headPart.Material = Enum.Material.Grass
		herbPart.Material = Enum.Material.Grass
		
		self.prompt.ActionText = "Raccogli (Marcia)"
		print("🥕 STATO CAMBIATO: La carota è marcia da buttare!")
	end
end

-- Avviamo il timer della carota!
carrot:startAging()