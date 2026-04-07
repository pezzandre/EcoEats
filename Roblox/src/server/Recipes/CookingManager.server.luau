-- File: server/Recipes/CookingManager.server.luau
local Workspace = game:GetService("Workspace")
local CookingBase = require(script.Parent:WaitForChild("CookingBase"))

local kitchenFolder = Workspace:WaitForChild("Kitchen")
local listFolder = script.Parent:WaitForChild("List")

-- 1. TROVIAMO TUTTE LE POSTAZIONI E LE PREPARIAMO
local stations = {}

for _, item in ipairs(kitchenFolder:GetChildren()) do
    if item:IsA("Model") then
        -- Raggruppiamo le postazioni per nome (es. tutte le "Pan" insieme)
        if not stations[item.Name] then 
            stations[item.Name] = {} 
        end
        
        local stationObj = CookingBase.new(item)
        stationObj:setup()
        
        table.insert(stations[item.Name], stationObj)
    end
end

-- 2. CARICAMENTO AUTOMATICO DELLE RICETTE
-- Legge da solo TUTTI i file presenti nella cartella "List"
for _, module in ipairs(listFolder:GetChildren()) do
    if module:IsA("ModuleScript") then
        local recipeData = require(module)
        
        -- Controlliamo se esiste la postazione richiesta (es. "Pan")
        local targetStations = stations[recipeData.Station]
        
        if targetStations then
            -- Aggiungiamo la ricetta a tutte le padelle trovate
            for _, stationObj in ipairs(targetStations) do
                stationObj:addRecipe(recipeData.Name, recipeData.Ingredients)
            end
        else
        end
    end
end