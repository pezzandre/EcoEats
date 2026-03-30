-- File: server/Recipes/test.server.luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local kitchenFolder = Workspace:WaitForChild("Kitchen")
local panModel = kitchenFolder:WaitForChild("Pan")

local storageFoodFolder = ReplicatedStorage:WaitForChild("Food")
local fastFoodTemplate = storageFoodFolder:WaitForChild("FastFood")

local panContains = {
	Apple = false,
	Banana = false
}

-- Funzione per trovare il cibo
local function getFoodItem(hitPart)
	local tool = hitPart:FindFirstAncestorOfClass("Tool")
	if tool then return tool end
	
	local model = hitPart:FindFirstAncestorOfClass("Model")
	-- Ci assicuriamo che sia dentro la cartella Food e che non sia il giocatore
	if model and not model:FindFirstChild("Humanoid") and model.Parent and model.Parent.Name == "Food" then 
		return model 
	end
	
	if hitPart.Parent and hitPart.Parent.Name == "Food" then
		return hitPart
	end
	
	return nil
end

local function checkRecipe()
	if panContains.Apple and panContains.Banana then
		print("🍳 Recipe complete! Spawning FastFood...")
		
		panContains.Apple = false
		panContains.Banana = false
		
		local newFood = fastFoodTemplate:Clone()
		
		-- Usiamo GetPivot() perché la padella è un Model
		local panCFrame = panModel:GetPivot()
		newFood:PivotTo(panCFrame * CFrame.new(0, 2, 0))
		
		newFood.Parent = Workspace:WaitForChild("Food")
	end
end

local isProcessing = false

-- Funzione che scatta quando qualcosa tocca la padella
local function onPanTouched(hit)
	if isProcessing then return end
	
	local foodItem = getFoodItem(hit)
	
	if foodItem then
		isProcessing = true
		local itemName = foodItem.Name
		
		if (string.find(itemName, "Mela") or string.find(itemName, "Apple")) and not panContains.Apple then
			print("🍎 Apple added to pan!")
			panContains.Apple = true
			foodItem:Destroy() 
			
			checkRecipe()
			
		elseif string.find(itemName, "Banana") and not panContains.Banana then
			print("🍌 Banana added to pan!")
			panContains.Banana = true
			foodItem:Destroy() 
			
			checkRecipe()
		end
		
		task.wait(0.1)
		isProcessing = false
	end
end

for _, part in ipairs(panModel:GetDescendants()) do
	if part:IsA("BasePart") then
		part.Touched:Connect(onPanTouched)
	end
end