-- File: server/Food/water.server.luau
local Workspace = game:GetService("Workspace")
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = Workspace:WaitForChild("Food")
local waterObj = foodFolder:WaitForChild("Water")

-- Troviamo i 2 pezzi esatti
local bottlePart = waterObj:WaitForChild("Bottle") 
local capPart = waterObj:WaitForChild("Cap")

-- Impostiamo una PrimaryPart al Modello
waterObj.PrimaryPart = bottlePart

-- 1. SALDIAMO I PEZZI
local weld = Instance.new("WeldConstraint")
weld.Part0 = capPart
weld.Part1 = bottlePart
weld.Parent = capPart

-- 2. SBLOCCHIAMO LA FISICA DI ENTRAMBI (Importante!)
bottlePart.Anchored = false
capPart.Anchored = false

-- Creiamo l'oggetto Water (tempi altissimi, ma non verranno mai usati)
local water = FoodBase.new(waterObj, 9999, 9999)

-- Attiviamo la raccolta (passiamo la PrimaryPart)
water:setupPickup(bottlePart, "Water")

-- NESSUN startAging() -> L'acqua non scadrà mai e resterà sempre FRESH (Stato 1).