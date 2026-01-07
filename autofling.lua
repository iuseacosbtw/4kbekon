local KEYBIND=Enum.KeyCode.C

/* PLEASE READ BEFORE USING
	This script flings every player in the server for as long as you want.
	You can toggle between flinging and not flinging using the keybind above.
	You can also change the keybind if you want.

  To start flinging players, press the key.
  To stop, press the key again.
  That's literally it. You can start using the script now.
  
  This script spins your character to fling players.
  This script partially works in Natural Disaster Survival, but due to the fall damage mechanics, it may not work as expected.
  This script works in any game where player collisions exist.
  
  This script was made by "axes (@BHY94)"
*/

local player=game.Players.LocalPlayer
local character=player.Character or player.CharacterAdded:Wait()
local root=character:WaitForChild("HumanoidRootPart")
local humanoid=character:WaitForChild("Humanoid")
local mouse=player:GetMouse()
local finish=false
local toggle=false
local toggled=false
function getRoot(name)
	if name then
		if game.Players:FindFirstChild(name) then
			if game.Players:FindFirstChild(name).Character then
				local c=game.Players:FindFirstChild(name).Character
				if c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildWhichIsA("Humanoid") then
					if c.Humanoid.Health>0 then return c.HumanoidRootPart end
				end
			end
		end
	end
end

game:GetService("UserInputService").InputBegan:Connect(function(inp) 
	if inp.UserInputType==Enum.UserInputType.Keyboard then
		if inp.KeyCode==KEYBIND then
			if toggle==true then
				toggle=false
				toggled=true
			else
				toggle=true
				toggled=true
			end
		end
	end
end)
local model=nil
while not finish do
	task.wait()
	if toggle==true then
        if toggled==true then
		    toggled=false
            position=root.CFrame
        end
        local best=math.huge
        model=nil
        for _,i in ipairs(game.Players:GetPlayers()) do
            local r=getRoot(i.Name)
            if  r and i.Name~=player.Name and r.AssemblyLinearVelocity.Magnitude<best then
                model=r
                best=r.AssemblyLinearVelocity.Magnitude
            end
        end
        if model then
            root.Anchored=false
            root.CFrame=model.CFrame+model.AssemblyLinearVelocity/8
            root.AssemblyLinearVelocity=model.AssemblyLinearVelocity
            root.AssemblyAngularVelocity=Vector3.new(10000,0,0)
            humanoid.PlatformStand=true
        else
            root.Anchored=true
        end
	elseif toggled==true then
        root.Anchored=true
        root.AssemblyAngularVelocity=Vector3.new(0,0,0)
        root.AssemblyLinearVelocity=Vector3.new(0,0,0)
        root.CFrame=position
        task.wait()
        root.CFrame=position
		toggled=false
		humanoid.PlatformStand=false
		root.Anchored=false
	end
end
