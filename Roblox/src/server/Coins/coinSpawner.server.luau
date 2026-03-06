local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local assetsFolder = ServerStorage:WaitForChild("Assets")
local modelsFolder = assetsFolder:WaitForChild("Models")
local coinTemplate = modelsFolder:WaitForChild("Coin")

-- ATTENZIONE QUI: La cartella nel Workspace DEVE chiamarsi esattamente "CoinAreas"
local coinAreas = Workspace:WaitForChild("CoinAreas")
local activeCoinFolder = coinAreas:WaitForChild("ActiveCoins")

local spawnInterval = 5

task.spawn(function()
    while true do
        for _, area in pairs(coinAreas:GetChildren()) do
            if area:IsA("BasePart") then
                local coinClone = coinTemplate:Clone()
                
                local randomX = (math.random() - 0.5) * area.Size.X
                local randomZ = (math.random() - 0.5) * area.Size.Z
                
                -- Spawna la moneta 3 stud sopra la zona per non incastrarla nel pavimento
                local spawnPosition = area.Position + Vector3.new(randomX, 3, randomZ)
                coinClone.Position = spawnPosition
                
                local coinAmount = math.random(1, 5)
                coinClone:SetAttribute("coinAmount", coinAmount)
                
                local billboard = coinClone:FindFirstChild("BillboardGui")
                if billboard and billboard:FindFirstChild("TextLabel") then
                    billboard.TextLabel.Text = "$" .. tostring(coinAmount)
                end
                
                coinClone.Parent = activeCoinFolder
                
                -- SISTEMA DI RACCOLTA INTEGRATO (Addio script collect!)
                local collected = false
                coinClone.Touched:Connect(function(part)
                    if collected then return end
                    
                    local character = part.Parent
                    local humanoid = character:FindFirstChild("Humanoid")
                    
                    if humanoid then
                        local player = Players:GetPlayerFromCharacter(character)
                        if player then
                            local leaderstats = player:FindFirstChild("leaderstats")
                            if leaderstats then
                                local coins = leaderstats:FindFirstChild("Coins")
                                if coins then
                                    collected = true
                                    coins.Value += coinAmount -- Aggiunge i soldi
                                    coinClone:Destroy() -- Fa sparire la moneta
                                end
                            end
                        end
                    end
                end)
                
            end
        end
        task.wait(spawnInterval)
    end
end)