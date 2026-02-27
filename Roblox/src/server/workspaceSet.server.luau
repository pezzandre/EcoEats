local baseplate = game.Workspace.Baseplate
baseplate.Material = "Brick"
baseplate.Transparency = 0.5

for i = 0, 10, 1 do
    baseplate.BrickColor = BrickColor.new("Toothpaste")
    task.wait(1)
    baseplate.BrickColor = BrickColor.new("Really red")
    task.wait(1)
    baseplate.BrickColor = BrickColor.new("Gold")
end
    

