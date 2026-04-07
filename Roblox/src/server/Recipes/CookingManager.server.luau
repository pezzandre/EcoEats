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

-- ... (parte iniziale del tuo script rimane uguale)

-- 2. CARICAMENTO DA UN UNICO FILE
local RecipesModule = require(script.Parent:WaitForChild("RecipesList"))

for _, recipeData in ipairs(RecipesModule.List) do
    -- Controlliamo se esiste la postazione richiesta
    local targetStations = stations[recipeData.Station]
    
    if targetStations then
        -- Aggiungiamo la ricetta a tutte le postazioni corrispondenti
        for _, stationObj in ipairs(targetStations) do
            stationObj:addRecipe(recipeData.Name, recipeData.Ingredients)
        end
        print("📖 Ricetta caricata: " .. recipeData.Name .. " per " .. recipeData.Station)
    else
        warn("⚠️ Attenzione: Nessuna postazione chiamata '" .. recipeData.Station .. "' trovata per la ricetta " .. recipeData.Name)
    end
end