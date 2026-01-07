local KEYBIND=Enum.KeyCode.C

local player=game.Players.LocalPlayer
local character=player.Character or player.CharacterAdded:Wait()
local root=character:WaitForChild("HumanoidRootPart")
local humanoid=character:WaitForChild("Humanoid")
local camera=workspace.CurrentCamera
local finish=false
local toggle=false
local toggled=false
local speed=3
local ui=Instance.new("ScreenGui")
ui.Parent=player.PlayerGui
local box=Instance.new("TextBox")
box.Parent=ui
box.Position=UDim2.fromScale(0,0.45)
box.Size=UDim2.fromScale(0.05,0.1)
box.TextScaled=true
box.Font=Enum.Font.FredokaOne
box.BorderSizePixel=0
box.BackgroundColor3=Color3.fromRGB(200,200,200)
box.TextColor3=Color3.new(0,0,0)
box.BackgroundTransparency=0.5
box.PlaceholderText="Speed"
box.Text=speed
box.FocusLost:Connect(function()
	speed=box.Text
end)
local part=Instance.new("Part")
part.Parent=workspace
part.CanCollide=false
part.Anchored=true
part.CFrame=root.CFrame
part.Transparency=1

player.CharacterRemoving:Connect(function()
	finish=true
    part:Destroy()
end)


local input={}
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
		if not input[inp.KeyCode] then
			input[inp.KeyCode]=true
		end
	end
end)
game:GetService("UserInputService").InputEnded:Connect(function(inp) 
	if inp.UserInputType==Enum.UserInputType.Keyboard then
		if input[inp.KeyCode]==true then
			input[inp.KeyCode]=false
		end
	end
end)
while not finish do
	task.wait()
	if toggle==true then
        if toggled==true then
		    toggled=false
            part.CFrame=root.CFrame
        end
        root.AssemblyLinearVelocity=Vector3.new(0,0,0)
		root.CFrame=CFrame.new(part.Position)*camera.CFrame.Rotation
		humanoid.PlatformStand=true
		if input[Enum.KeyCode.W] then
			part.CFrame=CFrame.new(part.Position)*camera.CFrame.Rotation+camera.CFrame.LookVector*speed
		end
		if input[Enum.KeyCode.S] then
			part.CFrame=CFrame.new(part.Position)*camera.CFrame.Rotation-camera.CFrame.LookVector*speed
		end
		if input[Enum.KeyCode.D] then
			part.CFrame=CFrame.new(part.Position)*camera.CFrame.Rotation+camera.CFrame.RightVector*speed
		end
		if input[Enum.KeyCode.A] then
			part.CFrame=CFrame.new(part.Position)*camera.CFrame.Rotation-camera.CFrame.RightVector*speed
		end
		if input[Enum.KeyCode.R] then
			part.CFrame=CFrame.new(part.Position)*camera.CFrame.Rotation+camera.CFrame.UpVector*speed
		end
		if input[Enum.KeyCode.F] then
			part.CFrame=CFrame.new(part.Position)*camera.CFrame.Rotation-camera.CFrame.UpVector*speed
		end
	elseif toggled==true then
		toggled=false
		humanoid.PlatformStand=false
		root.Anchored=false
	end
end
