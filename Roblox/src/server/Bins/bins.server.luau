-- File: server/Bins/bins.server.luau
local Workspace = game:GetService("Workspace")

local genericBin = Workspace:WaitForChild("Bin")
local compostBin = Workspace:WaitForChild("RBin")

local BASE_PENALTY = 10
local BASE_REWARD = 15

local genericBinPart = genericBin.PrimaryPart or genericBin:FindFirstChildWhichIsA("BasePart")
local compostBinPart = compostBin.PrimaryPart or compostBin:FindFirstChildWhichIsA("BasePart")

local function createBinPrompt(binPart, actionText, binName)
    local prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = actionText
    prompt.ObjectText = binName
    prompt.HoldDuration = 0.5
    prompt.RequiresLineOfSight = false
    -- Lo creiamo disabilitato di default, lo abiliterà il client solo se abbiamo cibo
    prompt.Enabled = false 
    prompt.Parent = binPart
    return prompt
end

local promptBin = createBinPrompt(genericBinPart, "Throw in Trash", "Generic Bin")
local promptRBin = createBinPrompt(compostBinPart, "Throw in Compost", "Compost Bin")

local function handleTrash(player, isCompost)
    local character = player.Character
    if not character then return end
    
    local equippedItem = character:FindFirstChildOfClass("Tool")
    
    -- Cerchiamo le monete nel leaderstats
    local leaderstats = player:FindFirstChild("leaderstats")
    local coins = leaderstats and leaderstats:FindFirstChild("Coins")
    
    if equippedItem then
        local foodState = equippedItem:GetAttribute("FoodState")
        
        if not foodState then return end
        
        local moneyChange = 0
        local message = ""
        
        -- LOGICA ECONOMIA
        if foodState == 1 then -- FRESH
            moneyChange = isCompost and -BASE_PENALTY or -(BASE_PENALTY * 2)
            message = isCompost and "Spreco di cibo fresco nel compost!" or "DISASTRO! Cibo fresco nell'indifferenziata!"
        elseif foodState == 2 then -- RECOVERABLE
            moneyChange = isCompost and 0 or -BASE_PENALTY
            message = isCompost and "Cibo in scadenza nel compost. Ok." or "Potevi riciclare questo cibo in scadenza!"
        elseif foodState == 3 then -- SPOILED
            moneyChange = isCompost and BASE_REWARD or 0
            message = isCompost and "Ottimo! Cibo avariato nel compost." or "Hai buttato l'umido nell'indifferenziata."
        end
        
        -- Aggiorniamo le monete (senza andare sotto lo zero)
        if coins then
            coins.Value = math.max(0, coins.Value + moneyChange)
            print(message .. " Monete: " .. moneyChange)
        end
        
        equippedItem:Destroy()
    end
end

promptBin.Triggered:Connect(function(player) handleTrash(player, false) end)
promptRBin.Triggered:Connect(function(player) handleTrash(player, true) end)