loadstring(game:HttpGet(('https://raw.githubusercontent.com/XeneonPlays/Reanimate/main/Reanimate'),true))()

local Player=game.Players.LocalPlayer local Character=workspace["Xen's Reanimate"] local hum = Character.Humanoid local LeftArm=Character["Left Arm"] local LeftLeg=Character["Left Leg"] local RightArm=Character["Right Arm"] local RightLeg=Character["Right Leg"] local Root=Character["HumanoidRootPart"] local Head=Character["Head"] local Torso=Character["Torso"] local Neck=Torso["Neck"] local mouse = Player:GetMouse() local position = nil local sine = 0 local t = 0 local change = 1

local HEADLERP = Instance.new("ManualWeld")
HEADLERP.Parent = Head
HEADLERP.Part0 = Head
HEADLERP.Part1 = Head
HEADLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
HEADLERP.C1 = CFrame.new(0, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
 
local TORSOLERP = Instance.new("ManualWeld")
TORSOLERP.Parent = Root
TORSOLERP.Part0 = Torso
TORSOLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
 
local ROOTLERP = Instance.new("ManualWeld")
ROOTLERP.Parent = Root
ROOTLERP.Part0 = Root
ROOTLERP.Part1 = Torso
ROOTLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
 
local RIGHTARMLERP = Instance.new("ManualWeld")
RIGHTARMLERP.Parent = RightArm
RIGHTARMLERP.Part0 = RightArm
RIGHTARMLERP.Part1 = Torso
RIGHTARMLERP.C0 = CFrame.new(0, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
RIGHTARMLERP.C1 = CFrame.new(1, 0.5, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

local LEFTARMLERP  = Instance.new("ManualWeld")
LEFTARMLERP.Parent = LeftArm
LEFTARMLERP.Part0 = LeftArm
LEFTARMLERP.Part1 = Torso
LEFTARMLERP.C0 = CFrame.new(0, 0, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
LEFTARMLERP.C1 = CFrame.new(-1, 0.5, -0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
 
local RIGHTLEGLERP = Instance.new("ManualWeld")
RIGHTLEGLERP.Parent = RightLeg
RIGHTLEGLERP.Part0 = RightLeg
RIGHTLEGLERP.Part1 = Torso
RIGHTLEGLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
RIGHTLEGLERP.C1 = CFrame.new(0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
 
local LEFTLEGLERP = Instance.new("ManualWeld")
LEFTLEGLERP.Parent = LeftLeg
LEFTLEGLERP.Part0 = LeftLeg
LEFTLEGLERP.Part1 = Torso
LEFTLEGLERP.C0 = CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))
LEFTLEGLERP.C1 = CFrame.new(-0.5, -1, 0) * CFrame.Angles(math.rad(0), math.rad(0), math.rad(0))

function swait(num)
	if num == 0 or num == nil then
		game:service("RunService").Stepped:wait(0)
	else
		for i = 0, num do
			game:service("RunService").Stepped:wait(0)
		end
	end
end

coroutine.wrap(function() -------Checks
while true do
if Root.Velocity.y > 1 then
position = "jump"
elseif Root.Velocity.y < -1 then
position = "fall"
elseif Root.Velocity.Magnitude < 2 then
position = "idle"
elseif Root.Velocity.Magnitude < 20 then
position = "walk"
elseif Root.Velocity.Magnitude > 20 then
position = "run"
end
wait()
end
end)()

coroutine.wrap(function()
while true do
sine = sine + change
if position == "idle" then
    change = 1
    ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.4 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 21 * math.sin(sine/12)), math.rad(0 + 12 * math.sin(sine/12)), math.rad(0 + 3 * math.sin(sine/12))),0.1)
    LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 21 * math.sin(sine/12)), math.rad(0 + -12 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.2 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(-2 + 0 * math.sin(sine/12))),0.1)
    LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.2 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(2 + 0 * math.sin(sine/12))),0.1)
elseif position == "walk" then
    change = 1
    ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.4 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 21 * math.sin(sine/12)), math.rad(0 + 12 * math.sin(sine/12)), math.rad(0 + 3 * math.sin(sine/12))),0.1)
    LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 21 * math.sin(sine/12)), math.rad(0 + -12 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.2 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 55 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(-2 + 0 * math.sin(sine/12))),0.1)
    LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.2 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + -57 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(2 + 0 * math.sin(sine/12))),0.1)
elseif position == "run" then
    change = 1
    ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.4 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(-3 + 18 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + -66 * math.sin(sine/12)), math.rad(0 + 17 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 76 * math.sin(sine/12)), math.rad(0 + -12 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.2 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 55 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(-2 + 0 * math.sin(sine/12))),0.1)
    LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0.2 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + -57 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(2 + 0 * math.sin(sine/12))),0.1)
elseif position == "jump" then
    change = 1
    ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + -11 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(173 + 30 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(180 + -24 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 35 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(2 + -60 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
elseif position == "fall" then
    change = 1
    ROOTLERP.C0 = ROOTLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + -11 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTARMLERP.C0 = RIGHTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(173 + 30 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    LEFTARMLERP.C0 = LEFTARMLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(180 + -24 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    RIGHTLEGLERP.C0 = RIGHTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(0 + 35 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
    LEFTLEGLERP.C0 = LEFTLEGLERP.C0:lerp(CFrame.new(0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12), 0 + 0 * math.sin(sine/12)) * CFrame.Angles(math.rad(2 + -60 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12)), math.rad(0 + 0 * math.sin(sine/12))),0.1)
end
swait()
end
end)()
--Converted using Xen Imator
