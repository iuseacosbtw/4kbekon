local KEYBIND=Enum.KeyCode.C
local ESP=true

/* PLEASE READ BEFORE USING
	This script quickly charges up your ultimate and gets you kills by repeatedly throwing trash cans at players.
	You can toggle between teleporting and not teleporting using the keybind above.
	You can also change the keybind if you want.
	
	When you press the key, you will teleport to a trash can.
	As soon as you pick it up, you will teleport to the player with the lowest health.
	As soon as you throw the trash can, you will teleport back to another.
	Pressing the key again will put you back to where you started.
	To disable ESP (seeing what moves players have equipped), set ESP above to false. This does not disable the red highlight.
	That's pretty much it, the rest is just extra info and suggestions.

	I recommend using an autoclicker so that you can leave it running and have the script get you kills.
	This script automatically avoids teleporting to people with one-shot counters (they are highlighted in red).
	When you teleport, this script compensates for lag and movement, and also attempts to attack two players at once.
	This script is designed only to work in The Strongest Battlegrounds. It hasn't been tested in any other games.

	This script was made by "axes (@BHY94)"
*/

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
if ESP then
	local c2=workspace.DescendantAdded:Connect(function(a)
		if a:IsA("Tool") then
			if a.Parent.Name~=character.Name and getRoot(a.Parent.Name) then
				local e=a.Parent:FindFirstChild("espgui")
				if not e then
					e=Instance.new("BillboardGui")
					e.Parent=a.Parent
					e.Adornee=a.Parent.Head
	                e.Name="espgui"
					local br=Instance.new("TextLabel")
					br.Parent=e
					br.Name="esptext"
	
					e.StudsOffset=Vector3.new(0,2,0)
					e.Size=UDim2.fromScale(8,2)
					br.Size=UDim2.fromScale(1,1)
					br.TextScaled=true
					br.BackgroundTransparency=1
	                br.TextColor3=Color3.new(1,1,1)
				end
				e.esptext.Text=a.Name
			end
		end
	end)
end
local c3=game.Players.DescendantAdded:Connect(function(a)
	if a:IsA("Tool") then
		if a.Name=="Death Counter" then
			if a.Parent.Parent.Name~=player.Name and getRoot(a.Parent.Parent.Name) and not getRoot(a.Parent.Parent.Name).Parent:FindFirstChild("dEaWARNING") then
				local n=Instance.new("Highlight")
				n.Parent=getRoot(a.Parent.Parent.Name).Parent
				n.Name="dEaWARNING"
                local name=a.Parent.Parent.Name
                a.Activated:Connect(function()
                    task.wait(15)
                    if getRoot(name) and getRoot(name).Parent:FindFirstChild("dEaWARNING") then getRoot(name).Parent.dEaWARNING:Destroy() end
                end)
			end
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
c3:Disconnect()
for _,i in ipairs(game.Players:GetPlayers()) do
    local r=getRoot(i.Name)
    if r then
        for _,j in ipairs(r.Parent:GetChildren()) do
            if j.Name=="espgui" then j:Destroy() end
        end
    end
end
