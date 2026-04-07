-- File: server/Recipes/CookingBase.luau
local CookingBase = {}
CookingBase.__index = CookingBase

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local foodStorage = ReplicatedStorage:WaitForChild("Food")

function CookingBase.new(model)
    local self = setmetatable({}, CookingBase)
    
    self.model = model
    self.recipes = {} -- Partiamo con zero ricette
    self.ingredients = {} 
    
    return self
end

-- NUOVA FUNZIONE: Aggiunge una ricetta specifica alla postazione
function CookingBase:addRecipe(recipeName, requiredIngredients)
    self.recipes[recipeName] = requiredIngredients
end

function CookingBase:setup()
    local part = self.model.PrimaryPart or self.model:FindFirstChildWhichIsA("BasePart")
    
    self.prompt = Instance.new("ProximityPrompt")
    self.prompt.Name = "CookingPrompt" -- NUOVO: Nome specifico per farci trovare dal Client Script!
    self.prompt.ActionText = "Add Ingredient"
    self.prompt.ObjectText = self.model.Name
    self.prompt.HoldDuration = 0.5
    self.prompt.MaxActivationDistance = 8
    self.prompt.Enabled = false -- NUOVO: Spento di default, come i cestini!
    self.prompt.Parent = part
    
    self.prompt.Triggered:Connect(function(player)
        self:onInteract(player)
    end)
end

function CookingBase:onInteract(player)
    local character = player.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then
        print("🖐️ You are not holding any ingredient!")
        return
    end
    
    local foodName = tool:GetAttribute("FoodName")
    local foodState = tool:GetAttribute("FoodState")
    
    if not foodName then return end
    
    if foodState == 3 then
        print("🤢 You cannot cook with spoiled food!")
        return
    end
    
    table.insert(self.ingredients, foodName)
    print("🍲 Added " .. foodName .. " to " .. self.model.Name)
    
    tool:Destroy()
    self:checkRecipes()
end

function CookingBase:checkRecipes()
    local currentSorted = {}
    for _, v in ipairs(self.ingredients) do table.insert(currentSorted, v) end
    table.sort(currentSorted)
    local currentStr = table.concat(currentSorted, "+")

    for recipeName, reqIngredients in pairs(self.recipes) do
        -- Copiamo e ordiniamo quelli della ricetta
        local reqSorted = {}
        for _, v in ipairs(reqIngredients) do table.insert(reqSorted, v) end
        table.sort(reqSorted)
        local reqStr = table.concat(reqSorted, "+")
        
        -- Se le due combinazioni sono uguali (a prescindere dall'ordine), creiamo il piatto!
        if currentStr == reqStr then
            self:finishRecipe(recipeName)
            return
        end
    end
end

function CookingBase:finishRecipe(recipeName)
    print("✨ Recipe complete! Spawning: " .. recipeName)
    
    self.ingredients = {} 
    
    local template = foodStorage:FindFirstChild(recipeName)
    if template then
        local newFood = template:Clone()
        newFood:PivotTo(self.model:GetPivot() * CFrame.new(0, 2, 0)) 
        newFood.Parent = Workspace:WaitForChild("Food")
    else
        warn("❌ Errore: Non ho trovato il modello " .. recipeName .. " in ReplicatedStorage/Food")
    end
end

return CookingBase