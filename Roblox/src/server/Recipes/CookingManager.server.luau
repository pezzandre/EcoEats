local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CookingBase = require(script.Parent:WaitForChild("CookingBase"))
local kitchenFolder = Workspace:WaitForChild("Kitchen")

local updateUIEvent = Instance.new("RemoteEvent")
updateUIEvent.Name = "CookingUpdateUI"
updateUIEvent.Parent = ReplicatedStorage

local removeIngredientEvent = Instance.new("RemoteEvent")
removeIngredientEvent.Name = "RemoveIngredientEvent"
removeIngredientEvent.Parent = ReplicatedStorage

CookingBase.setSharedEvent(updateUIEvent)

local stations = {}
for _, item in ipairs(kitchenFolder:GetChildren()) do
	if item:IsA("Model") then
		if not stations[item.Name] then
			stations[item.Name] = {}
		end
		local stationObj = CookingBase.new(item)
		stationObj:setup()
		table.insert(stations[item.Name], stationObj)
	end
end

local RecipesModule = require(script.Parent:WaitForChild("RecipesList"))
for _, recipeData in ipairs(RecipesModule.List) do
	local targetStations = stations[recipeData.Station]
	if targetStations then
		for _, stationObj in ipairs(targetStations) do
			stationObj:addRecipe(recipeData.Name, recipeData.Ingredients)
		end
		print("📖 Ricetta caricata: " .. recipeData.Name .. " per " .. recipeData.Station)
	else
		warn("⚠️ Nessuna postazione '" .. recipeData.Station .. "' per la ricetta " .. recipeData.Name)
	end
end

removeIngredientEvent.OnServerEvent:Connect(function(player, model, index)
	print("📡 Server: Rimuovi ingrediente #" .. tostring(index) .. " da " .. tostring(model))
	for _, stationList in pairs(stations) do
		for _, stationObj in ipairs(stationList) do
			if stationObj.model == model then
				stationObj:removeIngredient(player, index)
				return
			end
		end
	end
	warn("⚠️ Stazione non trovata per removeIngredient")
end)