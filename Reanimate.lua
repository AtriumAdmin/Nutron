function Attach(P0,P1,Position,Rotation)
local A1,A2,AO,AP = Instance.new("Attachment", P0), Instance.new("Attachment", P1),
Instance.new("AlignOrientation", P0), Instance.new("AlignPosition", P0)
AO.Attachment0 = A1
AP.Attachment0 = A1
AO.Attachment1 = A2
AP.Attachment1 = A2
AO.MaxTorque = 5e9
AP.MaxForce = 5e9
AO.Responsiveness = 5e9
AP.Responsiveness = 5e9
A1.Position = Position or Vector3.new(0,0,0)
A1.Orientation = Rotation or Vector3.new(0,0,0)
end
local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character; Character.Archivable = true
local ReanimateCharacter = Character:Clone()
ReanimateCharacter.Name = "GelatekReanim"
ReanimateCharacter.Parent = Character
-- Noclip
game:GetService("RunService").Stepped:connect(function()
	Character.Humanoid.Died:Connect(function()
		return
	end)
	for _,v in pairs(Character:GetDescendants()) do 
		if v:IsA("BasePart") then 
            pcall(function()  v.CanCollide = false end)
        end 
    end   
        ReanimateCharacter.Humanoid:Move(Character.Humanoid.MoveDirection)
end)

for _,v in pairs(ReanimateCharacter:GetDescendants()) do
	if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 1 end
end
--Character.Humanoid.Animator:Destroy()

-- Netless
game:GetService("RunService").Heartbeat:connect(function()
	Character.Humanoid.Died:Connect(function()
		return
	end)
	for _,v in pairs(Character:GetChildren()) do 
		if v:IsA("BasePart") and v.Name ~= "Torso" then 
            pcall(function() v.Velocity = Vector3.new(32.495,0,0) end)
		elseif v:IsA("Accessory") then 
			pcall(function() v.Handle.Velocity = Vector3.new(32.495,0,0) end)
        end 
    end   
	local Torso1 = Character:FindFirstChild("Torso")
	local Torso2 = Character:FindFirstChild("GelatekReanim"):FindFirstChild("Torso")
	pcall(function() Torso1.CFrame = Torso2.CFrame; if _G.Fling == true then Torso1.Velocity = Vector3.new(5000,9000,5000) end end)
end)
-- Attaching
ReanimateCharacter.HumanoidRootPart.CFrame = Character.Torso.CFrame
Character.HumanoidRootPart:Destroy()
Character.Torso["Left Hip"]:Destroy()
Character.Torso["Right Hip"]:Destroy()
Character.Torso["Left Shoulder"]:Destroy()
Character.Torso["Right Shoulder"]:Destroy()

Attach(Character.Torso,ReanimateCharacter.Torso)
Attach(Character["Right Arm"],ReanimateCharacter["Right Arm"])
Attach(Character["Right Leg"],ReanimateCharacter["Right Leg"])
Attach(Character["Left Arm"],ReanimateCharacter["Left Arm"])
Attach(Character["Left Leg"],ReanimateCharacter["Left Leg"])
game:GetService("UserInputService").JumpRequest:Connect(function()
	Character.Humanoid.Died:Connect(function()
		return
	end)
	ReanimateCharacter.Humanoid.Sit = false 
	ReanimateCharacter.Humanoid.Jump = true
end)
if workspace:FindFirstChildWhichIsA("Camera") then 
	workspace:FindFirstChildWhichIsA("Camera").CameraSubject = ReanimateCharacter.Humanoid
end
	
