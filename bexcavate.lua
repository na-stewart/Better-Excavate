local args = { ... }
local turn_right = true
local width = assert(tonumber(args[1]), "Usage: bexcavate <Width> <Height> <Length>")
local length = assert(tonumber(args[3]) - 1, "Usage: bexcavate <Width> <Height> <Length>")
local height = assert(tonumber(args[2]), "Usage: bexcavate <Width> <Height> <Length>")
 
 
function rotate_right()
    turtle.turnRight()
    turtle.turnRight()
end
 
 
function torch_placement_check(x, z)
    if (x % 8) == 0 and (z % 8) == 0 then
        local slot = 0
        local success, data = turtle.inspectDown()
        if success == false then return end
        for i = 1, 16, 1 do
            data = turtle.getItemDetail(i)
            if data ~= nil and data.name == "minecraft:torch" then
                slot = i
            end
        end
        place_torch(slot)
    end
end
 
 
function place_torch(slot)
    if slot > 0 then
        turtle.select(slot)  
        rotate_right()
        turtle.place()
        rotate_right()
     end
end
 
 
function forward()
    while not turtle.forward() do
        turtle.dig()
        turtle.attack()
        os.sleep()
    end
end
 
 
function turn_around()
    if turn_right then
        turtle.turnRight()
        turtle.dig()
        forward()
        turtle.turnRight()
        turn_right = false
    else    
        turtle.turnLeft()
        turtle.dig()
        forward()
        turtle.turnLeft()
        turn_right = true      
    end
end
 
 
function reset()
    turtle.turnRight()
    if turn_right then
        turtle.turnRight()
        for z = 1, length, 1 do
            forward()
        end
        turtle.turnRight()
    end
    for x = 1, width - 1, 1 do
        forward()
    end
    turtle.turnRight()
    turtle.digUp()
    turtle.up()
end
 
 
function refuel()
    turtle.select(1)
    turtle.refuel()
end  
 
 
print("Better Excavate by sunsetdev")
print("https://github.com/sunset-developer")
print("------------------------------------")
print("Excavation initiated, please monitor occasionally.")
for y = 1, height do
    refuel()
    turn_right = true
    for x = 1, width, 1 do
        for z = 1, length, 1 do
            turtle.dig()
            forward()
            torch_placement_check(x, z)          
        end
        if x < width then
            turn_around()
        else
            reset()
        end
    end
    print("Layer completed, " .. height - y .." left to go.")
end
print("Excavation complete, enjoy :)")
