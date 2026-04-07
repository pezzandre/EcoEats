-- File: server/Food/water.server.luau
local Workspace = game:GetService("Workspace")
local FoodBase = require(script.Parent:WaitForChild("FoodBase"))

local foodFolder = Workspace:WaitForChild("Food")
local waterObj = foodFolder:WaitForChild("Water")

-- Questa riga capisce in automatico se l'Acqua è un Modello o un pezzo singolo
local waterPart = waterObj:IsA("Model") and (waterObj.PrimaryPart or waterObj:FindFirstChildWhichIsA("BasePart")) or waterObj

-- Sblocchiamo la fisica
if waterPart then
    waterPart.Anchored = false
end

-- Creiamo l'oggetto Water (tempi altissimi, ma non verranno mai usati)
local water = FoodBase.new(waterObj, 9999, 9999)

-- Attiviamo la raccolta
water:setupPickup(waterPart, "Water")

-- NESSUN startAging() -> L'acqua non scadrà mai e resterà sempre FRESH (Stato 1).