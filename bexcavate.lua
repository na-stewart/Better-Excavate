local args = { ... }
turn_right = true
local width = assert(tonumber(args[1]), "Usage: bexcavate <Width> <Height> <Length>")
local length = assert(tonumber(args[3]) - 1, "Usage: bexcavate <Width> <Height> <Length>")
local height = assert(tonumber(args[2]), "Usage: bexcavate <Width> <Height> <Length>")


function rotate_right()
	turtle.turnRight()
    turtle.turnRight()
end


function torch_placement_check(x, z)
    if (x % 7) == 0 and (z % 7) == 0 then
		slot = 0
		success, data = turtle.inspectDown()
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
	

function gravel_check()
	success, data = turtle.inspect()
    while success and data.name == "minecraft:gravel" do
    	turtle.dig()
        os.sleep(0.5)
        success, data = turtle.inspect()
     end  
end
 

function dig_forward()
    turtle.dig()
	gravel_check()
    turtle.forward()
end
 
 
function turn_around()
    if turn_right then
        turtle.turnRight()
        dig_forward()
        turtle.turnRight()
		turn_right = false
    else    
        turtle.turnLeft()
        dig_forward()
        turtle.turnLeft() 
		turn_right = true      
    end
end

 
function reset()
    turtle.turnRight()
    if turn_right then
        turtle.turnRight()
        for z = 1, length, 1 do
            turtle.forward()
        end
        turtle.turnRight()
	  end
    for x = 1, width - 1, 1 do
        turtle.forward()
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
			dig_forward()
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