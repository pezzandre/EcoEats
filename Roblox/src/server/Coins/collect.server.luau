local coin = script.Parent
local Players = game:GetService("Players")

-- Questa variabile evita che il giocatore raccolga la stessa moneta più volte in una frazione di secondo
local collected = false 

coin.Touched:Connect(function(part)
    if collected then return end
    
    local character = part.Parent
    local humanoid = character:FindFirstChild("Humanoid")
    
    -- Controlla se a toccare la moneta è stato un giocatore
    if humanoid then
        local player = Players:GetPlayerFromCharacter(character)
        if player then
            local leaderstats = player:WaitForChild("leaderstats")
            local coins = leaderstats:WaitForChild("Coins")
            
            if coins then
                collected = true
                
                -- Prende il valore generato dallo spawner (oppure dà 1 se non lo trova)
                local amount = coin:GetAttribute("coinAmount") or 1
                
                -- Aggiunge i soldi e distrugge la moneta
                coins.Value += amount
                coin:Destroy()
            end
        end
    end
end)