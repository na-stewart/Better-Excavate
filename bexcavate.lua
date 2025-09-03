local args = { ... }
local turn_right = true
local width = assert(tonumber(args[1]), "Usage: bexcavate <Width> <Depth> <Length>")
local length = assert(tonumber(args[3]) - 1, "Usage: bexcavate <Width> <Depth> <Length>")
local depth = assert(tonumber(args[2]), "Usage: bexcavate <Width> <Depth> <Length>")
local Fuel_per_layer = (width * length) + width + length +1 -- calculates worst case

 
local function rotate_right()
    turtle.turnRight()
    turtle.turnRight()
end

 
local function torch_placement_check(x, z)
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
        if slot > 0 then
            turtle.select(slot)  
            rotate_right()
            turtle.place()
            rotate_right()
        end
    end
end
 
 
local function forward()
    while not turtle.forward() do
        turtle.dig()
        turtle.attack()
        sleep()
    end
end
 
 
local function turn_around()
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
 
 
local function reset()
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
    turtle.digDown()
    turtle.down()
end
 
local function fueling()
    turtle.select(1)
    local current_fuel_level = turtle.getFuelLevel()
    if current_fuel_level == "unlimited" then --no need to refuel when its unlimited
        return
    end
    if current_fuel_level >= Fuel_per_layer  then --exit func when fuel is sufficient
        return
    end

    print("Insufficient Fuel. Please add Fuel to Slot 1")
    while current_fuel_level < Fuel_per_layer do
        if turtle.refuel(1) then
            print("Refueling. (Current Fuel is " .. tostring(turtle.getFuelLevel()) .. " )" )
        end
        current_fuel_level = turtle.getFuelLevel()
    end
end

print("Better Excavate")
print("https://github.com/na-stewart/Better-Excavate")
print("------------------------------------")
print("Excavation initiated, please monitor occasionally.")
print("Add Fuel to Slot 1.")
for y = 1, depth do
    fueling()
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
    print("Layer completed, " .. depth - y .." left to go.")
    print("Fuel Level: " .. tostring(turtle.getFuelLevel()))
end
print("Excavation complete, enjoy :)")
