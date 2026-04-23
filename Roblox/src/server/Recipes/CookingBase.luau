local CookingBase = {}
CookingBase.__index = CookingBase

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local foodStorage = ReplicatedStorage:WaitForChild("Food")
local ingredientStorage = ServerStorage:WaitForChild("FoodTemplates")
local updateUIEvent = nil

function CookingBase.setSharedEvent(event)
	updateUIEvent = event
end

function CookingBase.new(model)
	local self = setmetatable({}, CookingBase)
	self.model = model
	self.recipes = {}
	self.ingredients = {}
	return self
end

function CookingBase:addRecipe(recipeName, requiredIngredients)
	self.recipes[recipeName] = requiredIngredients
end

function CookingBase:checkRecipes()
	local currentSorted = {}
	for _, v in ipairs(self.ingredients) do
		table.insert(currentSorted, v.name)
	end
	table.sort(currentSorted)
	local currentStr = table.concat(currentSorted, "+")

	for recipeName, reqIngredients in pairs(self.recipes) do
		local reqSorted = {}
		for _, v in ipairs(reqIngredients) do table.insert(reqSorted, v) end
		table.sort(reqSorted)
		local reqStr = table.concat(reqSorted, "+")

		if currentStr == reqStr then
			self:finishRecipe(recipeName)
			return
		end
	end
end

function CookingBase:updateUI(player)
	if updateUIEvent then
		local nameList = {}
		for _, v in ipairs(self.ingredients) do
			table.insert(nameList, v.name)
		end
		if player then
			updateUIEvent:FireClient(player, self.model, nameList)
		else
			updateUIEvent:FireAllClients(self.model, {})
		end
	end
end

function CookingBase:finishRecipe(recipeName)
	print("✨ Ricetta completata: " .. recipeName)
	self.ingredients = {}

	local template = foodStorage:FindFirstChild(recipeName)
	if template then
		local newFood = template:Clone()
		newFood:SetAttribute("FoodName", recipeName)
		newFood:SetAttribute("FoodState", 1)
		newFood.Parent = Workspace:WaitForChild("Food")
		local spawnPos = self.model:GetPivot().Position + Vector3.new(0, 2, 0)

		if newFood:IsA("Tool") then
			newFood:MoveTo(spawnPos)
			if newFood:FindFirstChild("Handle") then
				newFood.Handle.Anchored = false
				newFood.Handle.CanTouch = true
			end
		else
			newFood:PivotTo(CFrame.new(spawnPos))
		end
	else
		warn("❌ Modello " .. recipeName .. " non trovato")
	end

	self:updateUI(nil)
end

function CookingBase:removeIngredient(player, index)
	if not self.ingredients[index] then return end

	local ingredientData = self.ingredients[index]
	local foodName = ingredientData.name
	local savedAttributes = ingredientData.attributes
	local savedParts = ingredientData.savedParts or {}

	table.remove(self.ingredients, index)

	local backpack = player:FindFirstChild("Backpack")
	if not backpack then
		self:updateUI(player)
		return
	end

	local template = ingredientStorage:FindFirstChild(foodName)
	if not template then
		warn("❌ Template non trovato per: " .. foodName)
		self:updateUI(player)
		return
	end

	local modelClone = template:Clone()

	local tool = Instance.new("Tool")
	tool.RequiresHandle = true
	tool.CanBeDropped = true

	for attrName, attrValue in pairs(savedAttributes) do
		tool:SetAttribute(attrName, attrValue)
	end

	local foodState = savedAttributes["FoodState"] or 1
	local baseName = savedAttributes["FoodName"] or foodName
	if foodState == 2 then
		tool.Name = baseName .. " Bruised"
	else
		tool.Name = baseName .. " Fresh"
	end

	-- CASO 1: BasePart singola
	if modelClone:IsA("BasePart") then
		modelClone.Name = "Handle"
		modelClone.Anchored = false
		modelClone.CanCollide = false
		modelClone.Massless = true
		modelClone.Parent = tool

		local partData = savedParts["Handle"] or savedParts[modelClone.Name]
		if partData then
			modelClone.Color = partData.color
			modelClone.Material = partData.material
		end

		-- CASO 2: Model con più parti
	elseif modelClone:IsA("Model") then
		local mainPart = modelClone.PrimaryPart or modelClone:FindFirstChildWhichIsA("BasePart", true)

		if not mainPart then
			warn("❌ Nessuna BasePart trovata: " .. foodName)
			modelClone:Destroy()
			self:updateUI(player)
			return
		end

		for _, child in ipairs(modelClone:GetDescendants()) do
			if child:IsA("WeldConstraint") or child:IsA("Weld") or child:IsA("Motor6D") then
				child:Destroy()
			end
		end

		local partsToKeep = {}
		for _, child in ipairs(modelClone:GetDescendants()) do
			if child:IsA("BasePart") and child ~= mainPart then
				table.insert(partsToKeep, child)
			end
		end

		mainPart.Name = "Handle"
		mainPart.Anchored = false
		mainPart.Parent = tool

		for _, part in ipairs(partsToKeep) do
			part.Anchored = false
			part.CanCollide = false
			part.Massless = true
			part.Parent = tool

			local weld = Instance.new("WeldConstraint")
			weld.Part0 = mainPart
			weld.Part1 = part
			weld.Parent = mainPart
		end

		for _, part in ipairs(tool:GetDescendants()) do
			if part:IsA("BasePart") then
				local partData = savedParts[part.Name]
				if partData then
					part.Color = partData.color
					part.Material = partData.material
				end
			end
		end

		if modelClone.Parent then
			modelClone:Destroy()
		end
	else
		warn("❌ Tipo non supportato: " .. foodName)
		modelClone:Destroy()
		self:updateUI(player)
		return
	end

	local toolAge = savedAttributes["CurrentAge"] or 0
	local spoiledTime = savedAttributes["SpoiledTime"] or 9999
	local recoverableTime = savedAttributes["RecoverableTime"] or 9999
	local currentState = foodState

	-- ✅ Parent assegnato PRIMA del task.spawn
	tool.Parent = backpack

	task.spawn(function()
		while currentState ~= 3 and tool.Parent do
			task.wait(1)
			toolAge += 0.4
			tool:SetAttribute("CurrentAge", toolAge)

			local previousState = currentState
			if toolAge >= spoiledTime then
				currentState = 3
			elseif toolAge >= recoverableTime then
				currentState = 2
			end

			if currentState ~= previousState then
				tool:SetAttribute("FoodState", currentState)
				if currentState == 2 then
					tool.Name = baseName .. " Bruised"
				elseif currentState == 3 then
					tool.Name = baseName .. " Spoiled"
				end
			end
		end
	end)

	print("✅ Restituito '" .. tool.Name .. "' a " .. player.Name)
	self:updateUI(player)
end

function CookingBase:onInteract(player)
	local character = player.Character
	if not character then return end

	local tool = character:FindFirstChildWhichIsA("Tool")
	if not tool then
		print("⚠️ " .. player.Name .. " non ha nessun tool in mano")
		return
	end

	local foodName = tool:GetAttribute("FoodName")
	if not foodName then
		print("⚠️ Il tool non ha l'attributo FoodName")
		return
	end

	local foodState = tool:GetAttribute("FoodState") or 1
	if foodState == 3 then
		print("❌ Cibo avariato, non puoi aggiungerlo: " .. foodName)
		return
	end

	local savedAttributes = {}
	for attrName, attrValue in pairs(tool:GetAttributes()) do
		savedAttributes[attrName] = attrValue
	end

	local savedParts = {}
	for _, part in ipairs(tool:GetDescendants()) do
		if part:IsA("BasePart") then
			savedParts[part.Name] = {
				color = part.Color,
				material = part.Material,
			}
		end
	end

	table.insert(self.ingredients, {
		name = foodName,
		attributes = savedAttributes,
		savedParts = savedParts,
	})

	tool:Destroy()
	print("🥄 Aggiunto: " .. foodName .. " | Totale: " .. #self.ingredients)
	self:checkRecipes()
end

function CookingBase:setup()
	local part = self.model.PrimaryPart or self.model:FindFirstChildWhichIsA("BasePart")

	self.prompt = Instance.new("ProximityPrompt")
	self.prompt.Name = "CookingPrompt"
	self.prompt.ActionText = "Add Ingredient"
	self.prompt.ObjectText = self.model.Name
	self.prompt.HoldDuration = 0.5
	self.prompt.Parent = part

	self.prompt.Triggered:Connect(function(player)
		self:onInteract(player)
		self:updateUI(player)
	end)
end

return CookingBase