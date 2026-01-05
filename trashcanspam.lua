local KEYBIND=Enum.KeyCode.C

local player=game.Players.LocalPlayer
local character=player.Character
local humanoid=character:WaitForChild("Humanoid")
local root=character:WaitForChild("HumanoidRootPart")

local mouse=player:GetMouse()

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
local model
local model2
local position
function getRoot(name)
	if game.Players:FindFirstChild(name) then
		if game.Players:FindFirstChild(name).Character then
			local c=game.Players:FindFirstChild(name).Character
			if c:FindFirstChild("HumanoidRootPart") and c:FindFirstChildWhichIsA("Humanoid") then
				if c.Humanoid.Health>0 then return c.HumanoidRootPart end
			end
		end
	end
end
local c2=workspace.DescendantAdded:Connect(function(a)
    if a.Name=="Death Counter" then
        if a.Parent.Name~=character.Name and getRoot(a.Parent.Name) and not a.Parent:FindFirstChild("dEaWARNING") then
            local n=Instance.new("Highlight")
            n.Parent=a.Parent
            n.Name="dEaWARNING"
        end
    end
end)
local c=game["Run Service"].Heartbeat:Connect(function()
    if toggle==true then
			local bestdist=math.huge
			for _,i in ipairs(game.Players:GetPlayers()) do
				local r=getRoot(i.Name)
				if r and i.Name~=player.Name then
					if r.Parent.Humanoid.Health<bestdist then
                        local bad=false
                        for _,j in ipairs(game.Players:GetPlayers()) do
                            local r2=getRoot(j.Name)
                            if r2 then
                                if r2.Parent:FindFirstChild("dEaWARNING") and (r2.Position-r.Position).Magnitude<=128 then
                                    bad=true
                                    break
                                end
                            end
                        end
                        if not bad then
                            bestdist=r.Parent.Humanoid.Health
                            model=r
                        end
					end
				end
			end
            bestdist=math.huge
            for _,i in ipairs(game.Players:GetPlayers()) do
				local r=getRoot(i.Name)
				if r and i.Name~=player.Name and i.Name~=model.Parent.Name and not r.Parent:FindFirstChild("dEaWARNING") then
					if (r.Position-model.Position).Magnitude<bestdist then
						bestdist=(r.Position-model.Position).Magnitude
						model2=r
					end
				end
			end
    end
end)
-- 'Trash Can' will be parented to the player
-- Check workspace.Map.Trash.Trashcan.Trashcan's transparency/cancollide to see
while humanoid.Health>0 do
	task.wait()
	if toggle==true then
		if toggled==true then
			toggled=false
			position=root.CFrame
		end
		while not character:FindFirstChild("Trash Can") and not toggled do
			for _,t in ipairs(workspace.Map.Trash:GetChildren()) do
				if t then
					if t.Trashcan.Transparency==0 or t.Trashcan.CanCollide==true then
						root.CFrame=t.Trashcan.CFrame-t.Trashcan.CFrame.LookVector*3
						break
					end
				end
			end
			task.wait()
		end
		while character:FindFirstChild("Trash Can") and not toggled do
			root.CFrame=CFrame.new((model.Position+model.AssemblyLinearVelocity/8-model2.Position+model2.AssemblyLinearVelocity/8).Unit*8+model.Position+model.AssemblyLinearVelocity/8,model.Position+model.AssemblyLinearVelocity/8)
			task.wait()
		end
	elseif toggled==true then
		root.CFrame=position
		toggled=false
	end
end
c:Disconnect()
c2:Disconnect()
