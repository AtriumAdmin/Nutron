
loadstring(game:HttpGet("https://pastebin.com/raw/uxN7jP7X"))()
--game:GetService("Workspace").GelatekReanimation["Ulta_Caliber"].Handle
--// Initializing \\--
local S = setmetatable({},{__index = function(s,i) return game:service(i) end})
local Plrs = S.Players
local Plr = Plrs.LocalPlayer
local Char = Plr.Character.Dummy
local Hum = Plr.Character:FindFirstChildOfClass'Humanoid'
local RArm = Char["Right Arm"]
local LArm = Char["Left Arm"]
local RLeg = Char["Right Leg"]
local LLeg = Char["Left Leg"]	
local Root = Char:FindFirstChild'HumanoidRootPart'
local Torso = Char.Torso
local Head = Char.Head
local NeutralAnims = true
local Attack = false
local BloodPuddles = {}
local Effects = {}
local Debounces = {Debounces={}}
local Mouse = Plr:GetMouse()
local Hit = {}
local Sine = 0
local Change = 1
local BanishedEvents = {}


--// Effect Thread System \\--


--// Debounce System \\--

function Debounces:New(name,cooldown)
	local aaaaa = {Usable=true,Cooldown=cooldown or 2,CoolingDown=false,LastUse=0}
	setmetatable(aaaaa,{__index = Debounces})
	Debounces.Debounces[name] = aaaaa
	return aaaaa
end

function Debounces:Use(overrideUsable)
	assert(self.Usable ~= nil and self.LastUse ~= nil and self.CoolingDown ~= nil,"Expected ':' not '.' calling member function Use")
	if(self.Usable or overrideUsable)then
		self.Usable = false
		self.CoolingDown = true
		local LastUse = time()
		self.LastUse = LastUse
		delay(self.Cooldown or 2,function()
			if(self.LastUse == LastUse)then
				self.CoolingDown = false
				self.Usable = true
			end
		end)
	end
end

function Debounces:Get(name)
	assert(typeof(name) == 'string',("bad argument #1 to 'get' (string expected, got %s)"):format(typeof(name) == nil and "no value" or typeof(name)))
	for i,v in next, Debounces.Debounces do
		if(i == name)then
			return v;
		end
	end
end

function Debounces:GetProgressPercentage()
	assert(self.Usable ~= nil and self.LastUse ~= nil and self.CoolingDown ~= nil,"Expected ':' not '.' calling member function Use")
	if(self.CoolingDown and not self.Usable)then
		return math.max(
			math.floor(
				(
					(time()-self.LastUse)/self.Cooldown or 2
				)*100
			)
		)
	else
		return 100
	end
end

--// Shortcut Variables \\--
local CF = {N=CFrame.new,A=CFrame.Angles,fEA=CFrame.fromEulerAnglesXYZ}
local C3 = {N=Color3.new,RGB=Color3.fromRGB,HSV=Color3.fromHSV,tHSV=Color3.toHSV}
local V3 = {N=Vector3.new,FNI=Vector3.FromNormalId,A=Vector3.FromAxis}
local M = {C=math.cos,R=math.rad,S=math.sin,P=math.pi,RNG=math.random,MRS=math.randomseed,H=math.huge,RRNG = function(min,max,div) return math.rad(math.random(min,max)/(div or 1)) end}
local R3 = {N=Region3.new}
local De = S.Debris
local WS = workspace
local Lght = S.Lighting
local RepS = S.ReplicatedStorage
local IN = Instance.new
--// Instance Creation Functions \\--

function Sound(parent,id,pitch,volume,looped,effect,autoPlay)
	local Sound = IN("Sound")
	Sound.SoundId = "rbxassetid://".. tostring(id or 0)
	Sound.Pitch = pitch or 1
	Sound.Volume = volume or 1
	Sound.Looped = looped or false
	if(autoPlay)then
		coroutine.wrap(function()
			repeat wait() until Sound.IsLoaded
			Sound.Playing = autoPlay or false
		end)()
	end
	if(not looped and effect)then
		Sound.Stopped:connect(function()
			Sound.Volume = 0
			Sound:destroy()
		end)
	elseif(effect)then
		warn("Sound can't be looped and a sound effect!")
	end
	Sound.Parent =parent or Torso
	return Sound
end
function Part(parent,color,material,size,cframe,anchored,cancollide)
	local part = IN("Part")
	part[typeof(color) == 'BrickColor' and 'BrickColor' or 'Color'] = color or C3.N(0,0,0)
	part.Material = material or Enum.Material.SmoothPlastic
	part.TopSurface,part.BottomSurface=10,10
	part.Size = size or V3.N(1,1,1)
	part.CFrame = cframe or CF.N(0,0,0)
	part.Anchored = anchored or true
	part.CanCollide = cancollide or false
	part.Parent = parent or Char
	return part
end
function Mesh(parent,meshtype,meshid,textid,scale,offset)
	local part = IN("SpecialMesh")
	part.MeshId = meshid or ""
	part.TextureId = textid or ""
	part.Scale = scale or V3.N(1,1,1)
	part.Offset = offset or V3.N(0,0,0)
	part.MeshType = meshtype or Enum.MeshType.Sphere
	part.Parent = parent
	return part
end

NewInstance = function(instance,parent,properties)
	local inst = Instance.new(instance,parent)
	if(properties)then
		for i,v in next, properties do
			pcall(function() inst[i] = v end)
		end
	end
	return inst;
end



--// Extended ROBLOX tables \\--
local Instance = setmetatable({ClearChildrenOfClass = function(where,class,recursive) local children = (recursive and where:GetDescendants() or where:GetChildren()) for _,v in next, children do if(v:IsA(class))then v:destroy();end;end;end},{__index = Instance})
--// Customization \\--

local Frame_Speed = 60 -- The frame speed for swait. 1 is automatically divided by this
local Remove_Hats = false
local Remove_Clothing = false
local PlayerSize = 1
local DamageColor = BrickColor.new'Really red'
local MusicID = 1119237438
local ChatSounds = {["You will know pain."] = 907333294,["Submit now."] = 907330103,["I will show you true power."] = 907329532, ["Your death is assured."] = 907332670, ["My attacks will tear you apart!"] = 907329893, ["Most worrying indeed."] = 1395854043}
local TauntDialogues = {"I'll cut you!", "I'll blast your head off!","Submit now.","Your death is assured.", "I will show you true power.", "You will know pain.","My attacks will tear you apart!"}

--// Weapon and GUI creation, and Character Customization \\--

if(Remove_Hats)then Instance.ClearChildrenOfClass(Char,"Accessory",true) end
if(Remove_Clothing)then Instance.ClearChildrenOfClass(Char,"Clothing",true) Instance.ClearChildrenOfClass(Char,"ShirtGraphic",true) end
local Effects = IN("Folder",Char)
Effects.Name = "Effects"

for _,v in pairs(Effects:GetChildren()) do
	if v:IsA("BasePart") then
		v.Transparency = 1
	end
end

pcall(function() Char.ReaperShadowHead.Eye1.BrickColor = BrickColor.new'Really red' Char.ReaperShadowHead.Eye1.Material = 'Glass' end)
pcall(function() Char.ReaperShadowHead.Eye2.BrickColor = BrickColor.new'Really red' Char.ReaperShadowHead.Eye2.Material = 'Glass' end)
pcall(function() Char.LeftWing.BrickColor = BrickColor.new'Really red' Char.LeftWing.Transparency = 0.5 end)

New = function(Object, Parent, Name, Data)
	local Object = Instance.new(Object)
	for Index, Value in pairs(Data or {}) do
		Object[Index] = Value
	end
	Object.Parent = Parent
	Object.Name = Name
	return Object
end
	
Ulta_Caliber = New("Model",Char,"Ulta_Caliber",{})
Handle = New("Part",Ulta_Caliber,"Handle",{Material = Enum.Material.Metal,Size = Vector3.new(1.13946342, 0.351685941, 0.328840196),CFrame = CFrame.new(-52.3439636, 4.31768751, -59.3824234, 0.5, -0.866025269, -1.57914513e-07, 0.866025269, 0.5, 3.60109915e-08, 4.7770822e-08, -1.5476347e-07, 1),CanCollide = false,})
WMesh =New("BlockMesh",Handle,"Mesh",{Scale = Vector3.new(1, 1, 0.855579317),})
Part2 = New("Part",Ulta_Caliber,"Part2",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(1.87730086, 0.396701694, 0.328840196),CFrame = CFrame.new(-50.9256058, 4.80724812, -59.3824234, 0.99999994, -2.24410021e-21, -1.57914513e-07, 0, 0.99999994, 3.60109773e-08, 1.57914499e-07, -3.60109809e-08, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",Part2,"Mesh",{Scale = Vector3.new(1, 1, 1.11225295),})
mot = New("Motor",Part2,"mot",{Part0 = Part2,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1, -6.12576133e-15, 1.57914513e-07, 1.18124174e-14, 1, -3.60109809e-08, -1.57914513e-07, 3.60109809e-08, 1),C1 = CFrame.new(1.13315201, -0.98355484, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Blade = New("Part",Ulta_Caliber,"Blade",{BrickColor = BrickColor.new("Quill grey"),Material = Enum.Material.Ice,Size = Vector3.new(0.328840256, 0.328840226, 0.572665811),CFrame = CFrame.new(-50.9072571, 4.11668205, -59.3754196, -2.32669322e-07, -0.00661635399, 0.999977946, -1.28771217e-06, 0.999977946, 0.00661635399, -1, -1.28614465e-06, -2.41184125e-07),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.87451, 0.87451, 0.870588),})
WMesh =New("SpecialMesh",Blade,"Mesh",{Scale = Vector3.new(0.0978527591, 0.790156424, 1),MeshType = Enum.MeshType.Wedge,})
mot = New("Motor",Blade,"mot",{Part0 = Blade,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -2.32669336e-07, -1.28771228e-06, -1, -0.00661629438, 0.999978125, -1.28614465e-06, 0.999978125, 0.00661629438, -2.41184125e-07),C1 = CFrame.new(0.544277191, -1.34472656, 0.00700378418, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.1684952, 4.40930319, -59.3824196, 0.70710665, -0.70710665, -1.57914471e-07, 0.70710665, 0.70710665, 3.60109986e-08, 8.61987672e-08, -1.37126023e-07, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.385011137, 0.748631597, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.707106829, 0.707106829, 8.61987814e-08, -0.707106829, 0.707106829, -1.37126037e-07, -1.57914471e-07, 3.60110022e-08, 1),C1 = CFrame.new(1.16707611, -1.83820343, 3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-52.6288223, 3.82322454, -59.3824234, 5.96046377e-08, -0.999999881, -2.24250414e-08, 0.999999881, 5.96046519e-08, -5.41976775e-09, 5.41976064e-09, -2.2425013e-08, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.543293059, 0.924025238, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 5.96046519e-08, 1, 5.41976819e-09, -1, 5.96046519e-08, -2.24250307e-08, -2.24250307e-08, -5.41976686e-09, 1),C1 = CFrame.new(-0.570646286, -0.000537872314, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,FormFactor = Enum.FormFactor.Symmetric,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-52.8299942, 3.82262015, -59.3813744, 1.57915409e-07, 5.96046306e-08, 0.999999881, 4.68513015e-08, 0.999999881, -5.96046448e-08, -1, 4.68513228e-08, 1.57915395e-07),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,})
WMesh =New("SpecialMesh",WPart,"Mesh",{Scale = Vector3.new(0.861996353, 0.541153729, 0.299452811),MeshType = Enum.MeshType.Wedge,})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1.57915409e-07, 4.68513122e-08, -1, 5.96046519e-08, 1, 4.68513264e-08, 1, -5.9604659e-08, 1.57915409e-07),C1 = CFrame.new(-0.671756744, 0.173381805, 0.00104904175, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(0.344652593, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.1012497, 4.28257656, -59.3753929, 0.70710665, 0.70710665, -1.20777344e-07, -0.70710665, 0.70710665, 1.25668052e-07, 1.74263192e-07, -3.45828965e-09, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 0.98605454, 0.727242351),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.707106829, -0.707106829, 1.74263207e-07, 0.707106829, 0.707106829, -3.45827589e-09, -1.20777329e-07, 1.25668066e-07, 1),C1 = CFrame.new(0.590950012, -1.0937767, 0.00703048706, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.7306976, 4.31373549, -59.3824272, 0.432455212, -0.901655316, 1.27368111e-07, 0.901655316, 0.432455212, -3.95984443e-07, 3.01960569e-07, 2.86087754e-07, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.541154027, 0.370038033, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.432455301, 0.901655436, 3.01960569e-07, -0.901655436, 0.432455301, 2.86087754e-07, 1.27368125e-07, -3.959845e-07, 1),C1 = CFrame.new(0.303211212, -0.533081055, -3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.7885818, 4.20838785, -59.3824234, 0.587423027, -0.809279799, -2.19202548e-07, 0.809279799, 0.587423027, -1.98992353e-07, 2.89805143e-07, -6.05034742e-08, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.275924385, 0.370038033, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.587423146, 0.809279919, 2.89805172e-07, -0.809279919, 0.587423146, -6.05035027e-08, -2.19202548e-07, -1.98992367e-07, 1),C1 = CFrame.new(0.183034897, -0.535625458, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.8400269, 4.15359306, -59.3824234, 0.760836244, -0.648943782, -2.6871362e-07, 0.648943782, 0.760836244, -1.52704587e-07, 3.035438e-07, -5.81968678e-08, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.275924385, 0.370038033, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.760836303, 0.648943841, 3.035438e-07, -0.648943841, 0.760836303, -5.8196882e-08, -2.68713649e-07, -1.52704587e-07, 1),C1 = CFrame.new(0.109859467, -0.518470764, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.9011612, 4.11773586, -59.3824234, 0.91851747, -0.395380199, -1.96948804e-08, 0.395380199, 0.91851747, -6.96443863e-07, 2.93450228e-07, 6.31909018e-07, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.275924385, 0.370038033, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.91851759, 0.395380259, 2.93450228e-07, -0.395380259, 0.91851759, 6.31909018e-07, -1.96948431e-08, -6.96443919e-07, 1),C1 = CFrame.new(0.0482387543, -0.483455658, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.356609762, 0.328840226, 0.328840196),CFrame = CFrame.new(-52.0863571, 4.12933016, -59.3824234, 0.991345346, 0.131278723, -5.39203029e-08, -0.131278723, 0.991345346, -9.33255933e-07, -6.90630628e-08, 9.32257819e-07, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 0.370038033, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.991345525, -0.131278753, -6.90630415e-08, 0.131278753, 0.991345525, 9.32257819e-07, -5.392031e-08, -9.33256047e-07, 1),C1 = CFrame.new(-0.034318924, -0.317272186, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-52.1749916, 4.05356789, -59.3820763, 0.991345346, 0.131278723, -5.39203029e-08, -0.131278723, 0.991345346, -9.33255933e-07, -6.90630628e-08, 9.32257819e-07, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.994611204, 0.301591754, 0.699436307),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.991345525, -0.131278753, -6.90630415e-08, 0.131278753, 0.991345525, 9.32257819e-07, -5.392031e-08, -9.33256047e-07, 1),C1 = CFrame.new(-0.144248962, -0.278392792, 0.000347137451, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-52.0123367, 4.06675053, -59.3824272, 0.793815136, -0.608158827, -7.65793686e-08, 0.608158827, 0.793815136, -8.4843424e-07, 5.7677272e-07, 6.26927658e-07, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.346509725, 0.370038033, 0.684463739),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.793815255, 0.608158886, 5.7677272e-07, -0.608158886, 0.793815255, 6.26927715e-07, -7.65793615e-08, -8.48434354e-07, 1),C1 = CFrame.new(-0.0515041351, -0.412666321, -3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.827166021, 0.351685941, 0.328840196),CFrame = CFrame.new(-52.1878128, 4.82334518, -59.3845367, 0.999954939, 0.00948500633, -7.15095894e-09, -0.00948500633, 0.999954939, 7.46392743e-08, 7.85854581e-09, -7.45681135e-08, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 1, 0.573238373),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.999955058, -0.00948503613, 7.85857424e-09, 0.00948503613, 0.999955058, -7.45681064e-08, -7.1509394e-09, 7.46392885e-08, 1),C1 = CFrame.new(0.515987396, 0.117599487, -0.00211334229, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.364346951, 0.350982577, 0.328840196),CFrame = CFrame.new(-52.3578377, 4.71502256, -59.3845367, -0.870376885, -0.492385834, 1.83688564e-06, 0.492385834, -0.870376885, 4.2302986e-07, 1.3904895e-06, 1.2726523e-06, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 1, 0.573238373),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.870377064, 0.492385924, 1.3904895e-06, -0.492385924, -0.870377064, 1.2726523e-06, 1.83688599e-06, 4.2302986e-07, 1),C1 = CFrame.new(0.337165833, 0.210681915, -0.00211334229, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.2399673, 4.18922997, -59.3753929, 0.470120013, 0.882602334, -6.54556175e-07, -0.882602334, 0.470120013, -3.05826063e-07, 3.77971503e-08, 7.21487936e-07, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(0.789272487, 0.271646053, 0.727242351),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.470120043, -0.882602453, 3.77971396e-08, 0.882602453, 0.470120043, 7.21487936e-07, -6.54556288e-07, -3.0582612e-07, 1),C1 = CFrame.new(0.440750122, -1.02031708, 0.00703048706, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(1.22879124, 0.618263781, 0.328840196),CFrame = CFrame.new(-50.7363968, 4.58814573, -59.3824234, 0.999999881, -2.98023224e-08, -1.57914513e-07, 2.98023224e-08, 0.999999881, 3.60109738e-08, 1.57914499e-07, -3.60109844e-08, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 1, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1, -6.12576133e-15, 1.57914513e-07, 1.18124174e-14, 1, -3.60109809e-08, -1.57914513e-07, 3.60109809e-08, 1),C1 = CFrame.new(1.03800774, -1.25696564, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.859521151, 0.531045794, 0.328840196),CFrame = CFrame.new(-51.7777481, 4.63175058, -59.3824234, 0.999999881, -2.98023224e-08, -1.57914513e-07, 2.98023224e-08, 0.999999881, 3.60109738e-08, 1.57914499e-07, -3.60109844e-08, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 1, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1, -6.12576133e-15, 1.57914513e-07, 1.18124174e-14, 1, -3.60109809e-08, -1.57914513e-07, 3.60109809e-08, 1),C1 = CFrame.new(0.555093765, -0.333324432, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.414286286, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.4174423, 4.47936392, -59.3824234, 0.5, 0.866025209, 2.92257027e-08, -0.866025209, 0.5, 1.03682424e-07, 7.51787468e-08, -7.7151455e-08, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 0.265229613, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.50000006, -0.866025329, 7.51787468e-08, 0.866025329, 0.50000006, -7.7151455e-08, 2.92257365e-08, 1.03682439e-07, 1),C1 = CFrame.new(0.603277206, -0.721553802, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{Material = Enum.Material.Metal,Size = Vector3.new(0.527529478, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.0795135, 4.63236904, -59.3824196, -2.98023366e-08, -0.999999881, 3.74803335e-08, 0.999999881, -2.98023153e-08, -4.49242386e-08, 4.49242386e-08, 3.74803761e-08, 1),CanCollide = false,})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 0.263090521, 0.855579317),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1.38707111e-16, 1, 4.49242421e-08, -1, -1.54506983e-15, 3.74803619e-08, 3.74803619e-08, -4.49242421e-08, 1),C1 = CFrame.new(1.40474701, -1.80373001, 3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
WPart = New("Part",Ulta_Caliber,"Part",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(1.17252171, 0.576061606, 0.328840196),CFrame = CFrame.new(-50.7363968, 4.55438519, -59.3753891, 0.999999881, -2.98023224e-08, -1.57914513e-07, 2.98023224e-08, 0.999999881, 3.60109738e-08, 1.57914499e-07, -3.60109844e-08, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",WPart,"Mesh",{Scale = Vector3.new(1, 1, 0.727242351),})
mot = New("Motor",WPart,"mot",{Part0 = WPart,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1, -6.12576133e-15, 1.57914513e-07, 1.18124174e-14, 1, -3.60109809e-08, -1.57914513e-07, 3.60109809e-08, 1),C1 = CFrame.new(1.00876999, -1.27384567, 0.00703430176, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Blade = New("Part",Ulta_Caliber,"Blade",{BrickColor = BrickColor.new("Quill grey"),Material = Enum.Material.Ice,Size = Vector3.new(0.328840256, 0.328840226, 0.605763316),CFrame = CFrame.new(-49.3369522, 4.12218142, -59.3754158, 1.84564726e-07, 0.00661724806, -0.999978065, 5.00432975e-07, -0.999978065, -0.00661724806, -1, -4.99200723e-07, -1.87872132e-07),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.87451, 0.87451, 0.870588),})
WMesh =New("SpecialMesh",Blade,"Mesh",{Scale = Vector3.new(0.0978527591, 0.779461861, 1),MeshType = Enum.MeshType.Wedge,})
mot = New("Motor",Blade,"mot",{Part0 = Blade,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1.84564712e-07, 5.00432975e-07, -1, 0.00661721826, -0.999978185, -4.9920078e-07, -0.999978185, -0.00661721826, -1.8787216e-07),C1 = CFrame.new(1.33419228, -2.70190048, 0.00700759888, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Blade = New("Part",Ulta_Caliber,"Blade",{BrickColor = BrickColor.new("Quill grey"),Material = Enum.Material.Ice,Size = Vector3.new(0.328840256, 0.328840226, 0.835727096),CFrame = CFrame.new(-50.0582809, 4.11805487, -59.3754158, -2.32669322e-07, -0.00661635399, 0.999977946, -1.28771217e-06, 0.999977946, 0.00661635399, -1, -1.28614465e-06, -2.41184125e-07),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.87451, 0.87451, 0.870588),})
WMesh =New("SpecialMesh",Blade,"Mesh",{Scale = Vector3.new(0.0978527591, 0.790156424, 1),MeshType = Enum.MeshType.Wedge,})
mot = New("Motor",Blade,"mot",{Part0 = Blade,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -2.32669336e-07, -1.28771228e-06, -1, -0.00661629438, 0.999978125, -1.28614465e-06, 0.999978125, 0.00661629438, -2.41184125e-07),C1 = CFrame.new(0.969955444, -2.07927704, 0.00700759888, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Blade = New("Part",Ulta_Caliber,"Blade",{BrickColor = BrickColor.new("Quill grey"),Material = Enum.Material.Ice,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-49.5309296, 4.30089998, -59.3754158, -5.15544457e-07, -0.00661677122, -0.999978065, 1.41483298e-07, 0.999978065, -0.00661677122, 1, -1.44891516e-07, -5.14597104e-07),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.87451, 0.87451, 0.870588),})
WMesh =New("SpecialMesh",Blade,"Mesh",{Scale = Vector3.new(0.0978527591, 0.31531024, 0.65928185),MeshType = Enum.MeshType.Wedge,})
mot = New("Motor",Blade,"mot",{Part0 = Blade,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -5.15544514e-07, 1.41483355e-07, 1, -0.00661674142, 0.999978185, -1.44891501e-07, -0.999978185, -0.00661674142, -5.14597104e-07),C1 = CFrame.new(1.39197922, -2.44455338, 0.00700759888, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Blade2 = New("Part",Ulta_Caliber,"Blade2",{BrickColor = BrickColor.new("Black"),Material = Enum.Material.SmoothPlastic,FormFactor = Enum.FormFactor.Plate,Size = Vector3.new(0.328840256, 0.328840226, 1.44360781),CFrame = CFrame.new(-50.3589401, 4.14609241, -59.3749352, -1.8456474e-07, -0.00555405021, 0.999984503, 9.5615583e-08, -0.999984503, -0.00555405021, 1, 9.45890548e-08, 1.85092958e-07),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.105882, 0.164706, 0.207843),})
WMesh =New("BlockMesh",Blade2,"Mesh",{Scale = Vector3.new(0.0458685458, 0.541722536, 1),})
mot = New("Motor",Blade2,"mot",{Part0 = Blade2,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -1.8456474e-07, 9.56156043e-08, 1, -0.00555405021, -0.999984622, 9.45890548e-08, 0.999984622, -0.00555405021, 1.85092958e-07),C1 = CFrame.new(0.843906403, -1.80487823, 0.00748825073, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Blade = New("Part",Ulta_Caliber,"Blade",{BrickColor = BrickColor.new("Quill grey"),Material = Enum.Material.Ice,Size = Vector3.new(0.328840256, 0.328840226, 0.705641866),CFrame = CFrame.new(-50.2675247, 4.12026787, -59.3754196, 1.84564726e-07, 0.00661724806, -0.999978065, 5.00432975e-07, -0.999978065, -0.00661724806, -1, -4.99200723e-07, -1.87872132e-07),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.87451, 0.87451, 0.870588),})
WMesh =New("SpecialMesh",Blade,"Mesh",{Scale = Vector3.new(0.0978527591, 0.779461861, 1),MeshType = Enum.MeshType.Wedge,})
mot = New("Motor",Blade,"mot",{Part0 = Blade,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1.84564712e-07, 5.00432975e-07, -1, 0.00661721826, -0.999978185, -4.9920078e-07, -0.999978185, -0.00661721826, -1.8787216e-07),C1 = CFrame.new(0.867248535, -1.8969574, 0.00700378418, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part3 = New("Part",Ulta_Caliber,"Part3",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.2174072, 4.39788437, -59.3824196, -1.49011626e-07, -0.999999881, -1.98068761e-07, 0.999999881, -1.49011612e-07, -3.30714123e-08, 3.30713661e-08, -1.98068761e-07, 1),CanCollide = false,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("BlockMesh",Part3,"Mesh",{Scale = Vector3.new(0.0855581015, 0.188227236, 1.12080872),})
mot = New("Motor",Part3,"mot",{Part0 = Part3,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -1.49011612e-07, 1, 3.30713732e-08, -1, -1.49011612e-07, -1.98068776e-07, -1.98068776e-07, -3.30714016e-08, 1),C1 = CFrame.new(1.13273048, -1.80155182, 3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part2 = New("Part",Ulta_Caliber,"Part2",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(0.520495594, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.9148941, 4.73376513, -59.3824234, 0.499999881, -0.866025329, -1.02213342e-07, 0.866025329, 0.499999881, 2.49974264e-09, 4.89418106e-08, -8.97692303e-08, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",Part2,"Mesh",{Scale = Vector3.new(1, 0.575376868, 1.11225307),})
mot = New("Motor",Part2,"mot",{Part0 = Part2,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.5, 0.866025507, 4.89418248e-08, -0.866025507, 0.5, -8.97692303e-08, -1.02213335e-07, 2.49974352e-09, 1),C1 = CFrame.new(0.574869156, -0.163547516, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part2 = New("Part",Ulta_Caliber,"Part2",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(0.730803668, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.3537521, 4.49474096, -59.3824234, 0.999999881, -1.49011655e-07, -3.99031308e-07, 1.49011626e-07, 0.999999881, -1.96114058e-07, 3.99031364e-07, 1.9611403e-07, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",Part2,"Mesh",{Scale = Vector3.new(1, 0.701574802, 1.11225307),})
mot = New("Motor",Part2,"mot",{Part0 = Part2,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1, 1.49011598e-07, 3.99031393e-07, -1.49011683e-07, 1, 1.9611403e-07, -3.99031364e-07, -1.96114087e-07, 1),C1 = CFrame.new(1.14843941, -1.63504791, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Neon = New("Part",Ulta_Caliber,"Neon",{BrickColor = BrickColor.new("Really red"),Material = Enum.Material.Neon,Size = Vector3.new(0.368567139, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.4424782, 4.61851454, -59.3824234, -0.258819222, -0.965925694, -2.34842005e-07, 0.965925694, -0.258819222, -3.79127165e-08, -2.41607623e-08, -2.36652511e-07, 1),CanCollide = false,Color = Color3.new(1, 0, 0),})
WMesh =New("BlockMesh",Neon,"Mesh",{Scale = Vector3.new(1, 0.109086163, 1.12936485),})
mot = New("Motor",Neon,"mot",{Part0 = Neon,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.258819252, 0.965925813, -2.41607623e-08, -0.965925813, -0.258819252, -2.36652511e-07, -2.3484202e-07, -3.79127165e-08, 1),C1 = CFrame.new(1.21126747, -1.49632263, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part2 = New("Part",Ulta_Caliber,"Part2",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,FormFactor = Enum.FormFactor.Symmetric,Size = Vector3.new(0.365753591, 0.62600112, 0.328840196),CFrame = CFrame.new(-49.9626884, 4.69178581, -59.3826065, 7.68042241e-07, -0.00064355135, -0.999999762, -9.31381408e-08, -0.999999762, 0.00064355135, -1, 9.26439014e-08, -7.68102325e-07),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("SpecialMesh",Part2,"Mesh",{Scale = Vector3.new(1, 1, 0.168976992),MeshType = Enum.MeshType.Wedge,})
mot = New("Motor",Part2,"mot",{Part0 = Part2,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 7.68042412e-07, -9.31381976e-08, -1, -0.00064358121, -0.999999881, 9.26438943e-08, -0.999999881, 0.000643581152, -7.68102325e-07),C1 = CFrame.new(1.51461601, -1.87519455, -0.000183105469, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part3 = New("Part",Ulta_Caliber,"Part3",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Size = Vector3.new(0.419210047, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.2704659, 4.60726166, -59.3824196, -0.258819252, -0.965925813, -2.34842005e-07, 0.965925813, -0.258819252, -3.7912713e-08, -2.41607623e-08, -2.36652539e-07, 1),CanCollide = false,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("BlockMesh",Part3,"Mesh",{Scale = Vector3.new(1, 0.188227236, 1.12080872),})
mot = New("Motor",Part3,"mot",{Part0 = Part3,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.258819252, 0.965925813, -2.41607623e-08, -0.965925813, -0.258819252, -2.36652511e-07, -2.3484202e-07, -3.79127165e-08, 1),C1 = CFrame.new(1.28752899, -1.65091705, 3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part2 = New("Part",Ulta_Caliber,"Part2",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.3136215, 4.95879316, -59.379261, 0.787994385, -0.615682065, 2.82908672e-07, 0.615682065, 0.787994385, -6.01714532e-07, 1.47534422e-07, 6.4832966e-07, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",Part2,"Mesh",{Scale = Vector3.new(0.840607285, 0.938997805, 0.442120701),})
mot = New("Motor",Part2,"mot",{Part0 = Part2,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.787994564, 0.615682125, 1.47534436e-07, -0.615682125, 0.787994564, 6.4832966e-07, 2.82908701e-07, -6.01714646e-07, 1),C1 = CFrame.new(1.57038498, -1.43777466, 0.00316238403, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
CylinderWMesh =New("Part",Ulta_Caliber,"CylinderMesh",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Elasticity = 0,FormFactor = Enum.FormFactor.Symmetric,Size = Vector3.new(0.378414333, 0.377710849, 0.328840196),CFrame = CFrame.new(-50.0357437, 4.80339193, -59.39114, 2.98023224e-08, -0.999999881, 1.57914499e-07, -0.999999881, -2.98023224e-08, -3.60109773e-08, 3.60109915e-08, -1.57914499e-07, -1),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("CylinderMesh",CylinderWMesh,"Mesh",{Scale = Vector3.new(1, 1, 0.876968741),})
mot = New("Motor",CylinderWMesh,"mot",{Part0 = CylinderWMesh,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1.05101373e-15, -1, 3.6010988e-08, -1, -6.73767064e-15, -1.57914513e-07, 1.57914513e-07, -3.6010988e-08, -1),C1 = CFrame.new(1.57474327, -1.7561264, -0.00871658325, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Barrel = New("Part",Ulta_Caliber,"Barrel",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Elasticity = 0,FormFactor = Enum.FormFactor.Symmetric,Size = Vector3.new(0.378414333, 0.377710849, 0.328840196),CFrame = CFrame.new(-50.0357437, 4.80443621, -59.3890343, 2.98023224e-08, -0.999999881, 1.57914499e-07, -0.999999881, -2.98023224e-08, -3.60109773e-08, 3.60109915e-08, -1.57914499e-07, -1),CanCollide = false,BottomSurface = Enum.SurfaceType.Smooth,TopSurface = Enum.SurfaceType.Smooth,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("CylinderMesh",Barrel,"Mesh",{Scale = Vector3.new(1, 1.00999999, 0.79932487),})
mot = New("Motor",Barrel,"mot",{Part0 = Barrel,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 1.05101373e-15, -1, 3.6010988e-08, -1, -6.73767064e-15, -1.57914513e-07, 1.57914513e-07, -3.6010988e-08, -1),C1 = CFrame.new(1.57564735, -1.75560379, -0.00661087036, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part3 = New("Part",Ulta_Caliber,"Part3",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.5515137, 4.3936615, -59.3824234, -1.49011626e-07, -0.999999881, -1.98068761e-07, 0.999999881, -1.49011612e-07, -3.30714123e-08, 3.30713661e-08, -1.98068761e-07, 1),CanCollide = false,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("BlockMesh",Part3,"Mesh",{Scale = Vector3.new(0.0855581015, 0.188227236, 1.12080872),})
mot = New("Motor",Part3,"mot",{Part0 = Part3,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -1.49011612e-07, 1, 3.30713732e-08, -1, -1.49011612e-07, -1.98068776e-07, -1.98068776e-07, -3.30714016e-08, 1),C1 = CFrame.new(0.962020874, -1.51432037, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part3 = New("Part",Ulta_Caliber,"Part3",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Size = Vector3.new(0.419210047, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.1192398, 4.60677624, -59.3824196, -0.258819222, -0.965925694, -2.34842005e-07, 0.965925694, -0.258819222, -3.79127165e-08, -2.41607623e-08, -2.36652511e-07, 1),CanCollide = false,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("BlockMesh",Part3,"Mesh",{Scale = Vector3.new(1, 0.188227236, 1.12080872),})
mot = New("Motor",Part3,"mot",{Part0 = Part3,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.258819252, 0.965925813, -2.41607623e-08, -0.965925813, -0.258819252, -2.36652511e-07, -2.3484202e-07, -3.79127165e-08, 1),C1 = CFrame.new(1.36272049, -1.78212357, 3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part2 = New("Part",Ulta_Caliber,"Part2",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(0.497987658, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.6954193, 4.64329672, -59.3824234, 0.258819222, 0.965925694, -2.51750805e-07, -0.965925694, 0.258819222, -1.35819789e-07, -6.60338912e-08, 2.78325388e-07, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",Part2,"Mesh",{Scale = Vector3.new(1, 0.562543094, 1.11225307),})
mot = New("Motor",Part2,"mot",{Part0 = Part2,Part1 = Handle,C0 = CFrame.new(0, 0, 0, 0.258819252, -0.965925813, -6.60338841e-08, 0.965925813, 0.258819252, 2.78325388e-07, -2.51750834e-07, -1.35819803e-07, 1),C1 = CFrame.new(1.10625839, -1.26487732, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Neon = New("Part",Ulta_Caliber,"Neon",{BrickColor = BrickColor.new("Really red"),Material = Enum.Material.Neon,Size = Vector3.new(0.368567139, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.2807121, 4.61570024, -59.3824196, -0.258819252, -0.965925813, -2.34842005e-07, 0.965925813, -0.258819252, -3.7912713e-08, -2.41607623e-08, -2.36652539e-07, 1),CanCollide = false,Color = Color3.new(1, 0, 0),})
WMesh =New("BlockMesh",Neon,"Mesh",{Scale = Vector3.new(1, 0.109086163, 1.12936485),})
mot = New("Motor",Neon,"mot",{Part0 = Neon,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.258819252, 0.965925813, -2.41607623e-08, -0.965925813, -0.258819252, -2.36652511e-07, -2.3484202e-07, -3.79127165e-08, 1),C1 = CFrame.new(1.28971481, -1.63782501, 3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part3 = New("Part",Ulta_Caliber,"Part3",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Size = Vector3.new(0.419210047, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.6045723, 4.60303879, -59.3824234, -0.258819282, -0.965925932, -2.34842005e-07, 0.965925932, -0.258819282, -3.79127094e-08, -2.41607623e-08, -2.36652568e-07, 1),CanCollide = false,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("BlockMesh",Part3,"Mesh",{Scale = Vector3.new(1, 0.188227236, 1.12080872),})
mot = New("Motor",Part3,"mot",{Part0 = Part3,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.258819252, 0.965925813, -2.41607623e-08, -0.965925813, -0.258819252, -2.36652511e-07, -2.3484202e-07, -3.79127165e-08, 1),C1 = CFrame.new(1.11681747, -1.36368942, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part3 = New("Part",Ulta_Caliber,"Part3",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.066185, 4.39740467, -59.3824196, -1.49011626e-07, -0.999999881, -1.98068761e-07, 0.999999881, -1.49011612e-07, -3.30714123e-08, 3.30713661e-08, -1.98068761e-07, 1),CanCollide = false,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("BlockMesh",Part3,"Mesh",{Scale = Vector3.new(0.0855581015, 0.188227236, 1.12080872),})
mot = New("Motor",Part3,"mot",{Part0 = Part3,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -1.49011612e-07, 1, 3.30713732e-08, -1, -1.49011612e-07, -1.98068776e-07, -1.98068776e-07, -3.30714016e-08, 1),C1 = CFrame.new(1.2079258, -1.93275452, 3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part3 = New("Part",Ulta_Caliber,"Part3",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Size = Vector3.new(0.419210047, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.4315338, 4.60514545, -59.3824234, -0.258819222, -0.965925694, -2.34842005e-07, 0.965925694, -0.258819222, -3.79127165e-08, -2.41607623e-08, -2.36652511e-07, 1),CanCollide = false,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("BlockMesh",Part3,"Mesh",{Scale = Vector3.new(1, 0.188227236, 1.12080872),})
mot = New("Motor",Part3,"mot",{Part0 = Part3,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.258819252, 0.965925813, -2.41607623e-08, -0.965925813, -0.258819252, -2.36652511e-07, -2.3484202e-07, -3.79127165e-08, 1),C1 = CFrame.new(1.20516205, -1.5124855, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part2 = New("Part",Ulta_Caliber,"Part2",{BrickColor = BrickColor.new("Dark stone grey"),Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-51.9104652, 4.60788345, -59.3824272, -0.588878095, -0.808221817, 1.09032158e-06, 0.808221817, -0.588878095, 8.42210341e-07, -3.86262684e-08, 1.37718132e-06, 1),CanCollide = false,Color = Color3.new(0.388235, 0.372549, 0.384314),})
WMesh =New("BlockMesh",Part2,"Mesh",{Scale = Vector3.new(0.534737229, 0.787132502, 1.11225307),})
mot = New("Motor",Part2,"mot",{Part0 = Part2,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.588878155, 0.808221936, -3.8626272e-08, -0.808221936, -0.588878155, 1.37718132e-06, 1.0903218e-06, 8.42210511e-07, 1),C1 = CFrame.new(0.468067169, -0.230323792, -3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Part3 = New("Part",Ulta_Caliber,"Part3",{BrickColor = BrickColor.new("Really black"),Material = Enum.Material.Metal,Size = Vector3.new(0.328840256, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.3784828, 4.39577246, -59.3824234, -1.49011626e-07, -0.999999881, -1.98068761e-07, 0.999999881, -1.49011612e-07, -3.30714123e-08, 3.30713661e-08, -1.98068761e-07, 1),CanCollide = false,Color = Color3.new(0.0666667, 0.0666667, 0.0666667),})
WMesh =New("BlockMesh",Part3,"Mesh",{Scale = Vector3.new(0.0855581015, 0.188227236, 1.12080872),})
mot = New("Motor",Part3,"mot",{Part0 = Part3,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -1.49011612e-07, 1, 3.30713732e-08, -1, -1.49011612e-07, -1.98068776e-07, -1.98068776e-07, -3.30714016e-08, 1),C1 = CFrame.new(1.05036354, -1.66311264, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Neon = New("Part",Ulta_Caliber,"Neon",{BrickColor = BrickColor.new("Really red"),Material = Enum.Material.Neon,Size = Vector3.new(0.368567139, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.1280746, 4.61569977, -59.3824196, -0.258819222, -0.965925694, -2.34842005e-07, 0.965925694, -0.258819222, -3.79127165e-08, -2.41607623e-08, -2.36652511e-07, 1),CanCollide = false,Color = Color3.new(1, 0, 0),})
WMesh =New("BlockMesh",Neon,"Mesh",{Scale = Vector3.new(1, 0.109086163, 1.12936485),})
mot = New("Motor",Neon,"mot",{Part0 = Neon,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.258819252, 0.965925813, -2.41607623e-08, -0.965925813, -0.258819252, -2.36652511e-07, -2.3484202e-07, -3.79127165e-08, 1),C1 = CFrame.new(1.36603165, -1.7700119, 3.81469727e-06, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})
Neon = New("Part",Ulta_Caliber,"Neon",{BrickColor = BrickColor.new("Really red"),Material = Enum.Material.Neon,Size = Vector3.new(0.368567139, 0.328840226, 0.328840196),CFrame = CFrame.new(-50.6162033, 4.61738539, -59.3824234, -0.258819222, -0.965925694, -2.34842005e-07, 0.965925694, -0.258819222, -3.79127165e-08, -2.41607623e-08, -2.36652511e-07, 1),CanCollide = false,Color = Color3.new(1, 0, 0),})
WMesh =New("BlockMesh",Neon,"Mesh",{Scale = Vector3.new(1, 0.109086163, 1.12936485),})
mot = New("Motor",Neon,"mot",{Part0 = Neon,Part1 = Handle,C0 = CFrame.new(0, 0, 0, -0.258819252, 0.965925813, -2.41607623e-08, -0.965925813, -0.258819252, -2.36652511e-07, -2.3484202e-07, -3.79127165e-08, 1),C1 = CFrame.new(1.12342644, -1.34643555, 0, 0.50000006, 0.866025329, 4.77708291e-08, -0.866025329, 0.50000006, -1.5476347e-07, -1.57914513e-07, 3.60109951e-08, 1),})

for _,v in pairs(Ulta_Caliber:GetChildren()) do
	if v:IsA("BasePart") then
		v.Transparency = 1
	end
end
local real = Plr.Character["Starslayer Railgun"].Handle

real.AccessoryWeld:Destroy() 
function Attachments(P0,P1)
	local AlignPosition = Instance.new("AlignPosition", P0)
	local AlignOrientation = Instance.new("AlignOrientation", P0)
	local Attachment1 = Instance.new("Attachment", P0)
	local Attachment2 = Instance.new("Attachment", P1)
	AlignPosition.MaxForce = 9e9
	AlignOrientation.MaxTorque = 9e9
	AlignPosition.Responsiveness = 9e9
	AlignOrientation.Responsiveness = 9e9
	
	AlignPosition.Attachment0 = Attachment1
	AlignOrientation.Attachment0 = Attachment1
	AlignPosition.Attachment1 = Attachment2
	AlignOrientation.Attachment1 = Attachment2
	
	Attachment1.Position = Vector3.new(0,0.2,0)
	Attachment1.Orientation = Vector3.new(0, 0, 0)
end

Attachments(real,Char["Ulta_Caliber"].Handle)

if _G.BotReanim == true then
--FLING
local HatName = "Torso" -- hat name
local Char = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:wait()
HatName = Char:FindFirstChild(HatName)

--workspace.Camera.CameraSubject = HatName.Handle
--HatName.Parent = workspace
wait(0.2)
--coroutine.wrap(function()
    local bp = Instance.new("BodyPosition",HatName)
    bp.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    bp.P = 10000

    bp.D = 125

--bp.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    bp.Position = game.Players.LocalPlayer:GetMouse().Hit.p     
    local bt = Instance.new("BodyThrust",HatName)
    bt.Force = Vector3.new(3000,3000,3000)
    bt.Location = Vector3.new(10,5,-10)
    local hatpos = game.Players.LocalPlayer:GetMouse().Hit.p
    --HatName.Handle.CFrame = CFrame.new(hatpos)
    while true do
        for _=1,2 do
            game:GetService("RunService").RenderStepped:wait()
        end
        if not HatName or HatName.Parent ~= workspace then print("Sad"); break end
        HatName.CanCollide = false
       -- bp.Position = game.Players.LocalPlayer:GetMouse().Hit.p
    end
--end)()

local mouse = game.Players.LocalPlayer:GetMouse()


game:GetService("RunService").Heartbeat:Connect(function()
	pcall(function()
    if Attack == true then
    bp.Position = game.Players.LocalPlayer:GetMouse().Hit.p
    else
    bp.Position = reanim["Torso"].Position + Vector3.new(0,-50,0)
    end
end)
end)

HatName.Transparency = 0
local Outline = Instance.new("SelectionBox", HatName)

Outline.LineThickness = 0.08
game:GetService("RunService").Heartbeat:Connect(function()
local t = 5
local hue = tick() % t / t
Outline.Color3 = Color3.fromHSV(hue, 1, 1)
end)

Outline.Adornee = HatName
    Char["Right Arm"]:BreakJoints()
    Char["Right Leg"]:BreakJoints()
    Char["Left Arm"]:BreakJoints()
    Char["Left Leg"]:BreakJoints()	
end


if(PlayerSize ~= 1)then
	for _,v in next, Char:GetDescendats() do
		if(v:IsA'BasePart')then
			v.Size = v.Size * PlayerSize
		end
	end
end

for _,v in next, Ulta_Caliber:GetDescendants() do
	if(v:IsA'BasePart')then
		v.CustomPhysicalProperties = PhysicalProperties.new(0,0,0,0,0)
	end
end
local Music = Sound(Char,MusicID,1,3,true,false,true)
Music.Name = 'Music'

--// Stop animations \\--
for _,v in next, Hum:GetPlayingAnimationTracks() do
	v:Stop();
end

pcall(game.Destroy,Char:FindFirstChild'Animate')
pcall(game.Destroy,Hum:FindFirstChild'Animator')

--// Joints \\--

local LS = NewInstance('Motor',Char,{Part0=Torso,Part1=LArm,C0 = CF.N(-1.5 * PlayerSize,0.5 * PlayerSize,0),C1 = CF.N(0,.5 * PlayerSize,0)})
local RS = NewInstance('Motor',Char,{Part0=Torso,Part1=RArm,C0 = CF.N(1.5 * PlayerSize,0.5 * PlayerSize,0),C1 = CF.N(0,.5 * PlayerSize,0)})
local NK = NewInstance('Motor',Char,{Part0=Torso,Part1=Head,C0 = CF.N(0,1.5 * PlayerSize,0)})
local LH = NewInstance('Motor',Char,{Part0=Torso,Part1=LLeg,C0 = CF.N(-.5 * PlayerSize,-1 * PlayerSize,0),C1 = CF.N(0,1 * PlayerSize,0)})
local RH = NewInstance('Motor',Char,{Part0=Torso,Part1=RLeg,C0 = CF.N(.5 * PlayerSize,-1 * PlayerSize,0),C1 = CF.N(0,1 * PlayerSize,0)})
local RJ = NewInstance('Motor',Char,{Part0=Root,Part1=Torso})
local HW = NewInstance('Weld',Char,{Part0=RArm,Part1=Handle,C0 = CF.N(0,-.5,-.4)* CF.A(M.R(0),M.R(90),M.R(-30))})
local LSC0 = LS.C0
local RSC0 = RS.C0
local NKC0 = NK.C0
local LHC0 = LH.C0
local RHC0 = RH.C0
local RJC0 = RJ.C0

--// Artificial HB \\--

local ArtificialHB = IN("BindableEvent", script)
ArtificialHB.Name = "Heartbeat"

script:WaitForChild("Heartbeat")

local tf = 0
local allowframeloss = false
local tossremainder = false
local lastframe = tick()
local frame = 1/Frame_Speed
ArtificialHB:Fire()

game:GetService("RunService").Heartbeat:connect(function(s, p)
	tf = tf + s
	if tf >= frame then
		if allowframeloss then
			script.Heartbeat:Fire()
			lastframe = tick()
		else
			for i = 1, math.floor(tf / frame) do
				ArtificialHB:Fire()
			end
			lastframe = tick()
		end
		if tossremainder then
			tf = 0
		else
			tf = tf - frame * math.floor(tf / frame)
		end
	end
end)

function swait(num)
	if num == 0 or num == nil then
		ArtificialHB.Event:wait()
	else
		for i = 0, num do
			ArtificialHB.Event:wait()
		end
	end
end



--// Effect Function(s) \\--

function Tween(obj,props,time,easing,direction,repeats,backwards)
	local info = TweenInfo.new(time or .5, easing or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out, repeats or 0, backwards or false)
	local tween = S.TweenService:Create(obj, info, props)
	
	tween:Play()
end

function OnceWas(who,dontRemove)
end

function Bezier(startpos, pos2, pos3, endpos, t)
	local A = startpos:lerp(pos2, t)
	local B  = pos2:lerp(pos3, t)
	local C = pos3:lerp(endpos, t)
	local lerp1 = A:lerp(B, t)
	local lerp2 = B:lerp(C, t)
	local cubic = lerp1:lerp(lerp2, t)
	return cubic
end

function Effect(data)
	local FX = data.Effect or 'ResizeAndFade'
	local Parent = data.Parent or Effects
	local Color = data.Color or C3.N(0,0,0)
	local Size = data.Size or V3.N(1,1,1)
	local MoveDir = data.MoveDirection or nil
	local MeshData = data.Mesh or nil
	local SndData = data.Sound or nil
	local Frames = data.Frames or 45
	local Manual = data.Manual or nil
	local Material = data.Material or nil
	local CFra = data.CFrame or Torso.CFrame
	local Settings = data.FXSettings or {}
	local Snd,Prt,Msh;
	local Shape = data.Shape or Enum.PartType.Block
	coroutine.resume(coroutine.create(function()
		if(Manual and typeof(Manual) == 'Instance' and Manual:IsA'BasePart')then
			Prt = Manual
		else
			Prt = Part(Parent,Color,Material,Size,CFra,true,false)
			Prt.Shape = Shape
		end
		if(typeof(MeshData) == 'table')then
			Msh = Mesh(Prt,MeshData.MeshType,MeshData.MeshId,MeshData.TextureId,MeshData.Scale,MeshData.Offset)
		elseif(typeof(MeshData) == 'Instance')then
			Msh = MeshData:Clone()
			Msh.Parent = Prt
		elseif(Shape == Enum.PartType.Block)then
			Msh = Mesh(Prt,Enum.MeshType.Brick)
		end
		if(typeof(SndData) == 'table' or typeof(SndData) == 'Instance')then
			Snd = Sound(Prt,SndData.SoundId,SndData.Pitch,SndData.Volume,false,false,true)
		end
		if(Snd)then
			repeat wait() until Snd.Playing and Snd.IsLoaded and Snd.TimeLength > 0
			Frames = Snd.TimeLength * Frame_Speed/Snd.Pitch
		end
		local MoveSpeed = nil;
		if(MoveDir)then
			MoveSpeed = (CFra.p - MoveDir).magnitude/Frames
		end
		local Inc = M.RNG()-M.RNG()
		local Thingie = 0
		local Thingie2 = M.RNG(50,100)/100
		if(FX ~= 'Arc')then
			for i = 1, Frames do
				if(swait and typeof(swait) == 'function')then
					swait()
				else
					wait()
				end
				if(FX == 'ResizeAndFade')then
					if(not Settings.EndSize)then
						Settings.EndSize = V3.N(0,0,0)
					end
					local grow = (typeof(Settings.EndSize) == 'Vector3' and Settings.EndSize+Size or typeof(Settings.EndSize) == 'number' and V3.N(Settings.EndSize))
					if(Settings.EndIsIncrement)then
						Prt.Size = Prt.Size + Settings.EndSize					
					else
						Prt.Size = Prt.Size - grow/Frames
					end 
					Prt.Transparency = (i/Frames)
				elseif(FX == 'Fade')then
					Prt.Transparency = (i/Frames)
				end
				
				if(Settings.RandomizeCFrame)then
					Prt.CFrame = Prt.CFrame * CF.A(M.RRNG(-360,360),M.RRNG(-360,360),M.RRNG(-360,360))
				end
				if(MoveDir and MoveSpeed)then
					local Orientation = Prt.Orientation
					Prt.CFrame = CF.N(Prt.Position,MoveDir)*CF.N(0,0,-MoveSpeed)
					Prt.Orientation = Orientation
				end
			end
		else
			local start,third,fourth,endP = Settings.Start,Settings.Third,Settings.Fourth,Settings.End
			if(not Settings.End and Settings.Home)then endP = Settings.Home.CFrame end
			local quarter = third or start:lerp(endP, 0.25) * CF.N(M.RNG(-25,25),M.RNG(0,25),M.RNG(-25,25))
			local threequarter = fourth or start:lerp(endP, 0.75) * CF.N(M.RNG(-25,25),M.RNG(0,25),M.RNG(-25,25))
			assert(start ~= nil,"You need to specify a start point!")
			assert(endP ~= nil,"You need to specify an end point!")
			for i = 0, 1, Settings.Speed or 0.01 do
				if(swait and typeof(swait) == 'function')then
					swait()
				else
					wait()
				end
				if(Settings.Home)then
					endP = Settings.Home.CFrame
				end
				Prt.CFrame = Bezier(start, quarter, threequarter, endP, i)
			end
			if(Settings.RemoveOnGoal)then
				Prt:destroy()
			end
		end
	end))
	return Prt,Msh,Snd
end	


function SoulSteal(whom)
	local torso = (whom:FindFirstChild'Head' or whom:FindFirstChild'Torso' or whom:FindFirstChild'UpperTorso' or whom:FindFirstChild'LowerTorso' or whom:FindFirstChild'HumanoidRootPart')
	print(torso)
	if(torso and torso:IsA'BasePart')then
		local Model = Instance.new("Model",Effects)
		Model.Name = whom.Name.."'s Soul"
		whom:BreakJoints()
		local Soul = Part(Model,BrickColor.new'Really red','Glass',V3.N(.5,.5,.5),torso.CFrame,true,false)
		Soul.Name = 'Head'
		NewInstance("Humanoid",Model,{Health=0,MaxHealth=0})
		Effect{
			Effect="Arc",
			Manual = Soul,
			FXSettings={
				Start=torso.CFrame,
				Home = Torso,
				RemoveOnGoal = true,
			}
		}
		local lastPoint = Soul.CFrame.p
	
		for i = 0, 1, 0.01 do 
				local point = CFrame.new(lastPoint, Soul.Position) * CFrame.Angles(-math.pi/2, 0, 0)
				local mag = (lastPoint - Soul.Position).magnitude
				Effect{
					Effect = "Fade",
					CFrame = point * CF.N(0, mag/2, 0),
					Size = V3.N(.5,mag+.5,.5),
					Color = Soul.BrickColor
				}
				lastPoint = Soul.CFrame.p
			swait()
		end
		for i = 1, 15 do
			Effect{
				Effect="Fade",
				Color = BrickColor.new'Really red',
				MoveDirection = (Torso.CFrame*CFrame.new(M.RNG(-40,40),M.RNG(-40,40),M.RNG(-40,40))).p
			}	
		end
	end
end

--// Other Functions \\ --

function Turn(position)
	Root.CFrame=CFrame.new(Root.CFrame.p,V3.N(position.X,Root.Position.Y,position.Z))
end

function Shoot(startP,endP)
	local part,pos,norm,dist = CastRay(startP,endP,1500)
	if(part and part.Parent and part.Parent ~= workspace)then
		local part = part
		local who = part.Parent;
		OnceWas(who)
		local plr = S.Players:GetPlayerFromCharacter(who)
		if(plr)then
		end
		if(who:FindFirstChild'Head' and Hum.Health > 0)then
			ShowDamage((who.Head.CFrame * CF.N(0, 0, (who.Head.Size.Z / 2)).p+V3.N(M.RNG(-3,3),1.5,M.RNG(-3,3))), "BANISHED", 1.5, C3.N(1,0,0))
		end
	end
	Effect{
		Effect='ResizeAndFade',
		Frames=45,
		Size=V3.N(.1,.1,.1),
		CFrame=Barrel.CFrame,
		Mesh ={MeshType=Enum.MeshType.Sphere},
		Color=BrickColor.new'Really red',
		FXSettings={
			EndSize=V3.N(.05,.05,.05),
			EndIsIncrement=true,
		}
	}
	Effect{
		Effect='ResizeAndFade',
		Frames=45,
		Size=V3.N(.1,.1,.1),
		CFrame=Barrel.CFrame,
		Mesh ={MeshType=Enum.MeshType.Sphere},
		Color=BrickColor.new'Really red',
		FXSettings={
			EndSize=V3.N(.1,.1,.1),
			EndIsIncrement=true,
		}
	}
	Effect{
		Effect='Fade',
		Frames=15,
		Size=V3.N(.15,.15,dist),
		CFrame=CF.N(Barrel.CFrame.p,pos)*CF.N(0,0,-dist/2),
		Color=BrickColor.new'Really red',
	}
	Effect{
		Effect='ResizeAndFade',
		Frames=45,
		Size=V3.N(.5,.5,.5),
		CFrame=CF.N(pos),
		Mesh ={MeshType=Enum.MeshType.Sphere},
		Color=BrickColor.new'Really red',
		FXSettings={
			EndSize=V3.N(.05,.05,.05),
			EndIsIncrement=true,
		}
	}
	for i = 1, 5 do
		Effect{
			Effect='ResizeAndFade',
			Frames=65,
			Size=V3.N(.2,.2,1),
			CFrame=CF.N(CF.N(pos)*CF.A(M.RRNG(-180,180),M.RRNG(-180,180),M.RRNG(-180,180))*CF.N(0,0,-2).p,pos),
			Mesh = {MeshType=Enum.MeshType.Sphere},
			Material=Enum.Material.Neon,
			Color=BrickColor.new'Really red',
			FXSettings={
				EndSize=V3.N(.005,.005,.05),
				EndIsIncrement=true,
			}
		}	
	end
end

function Chat(text)

end

function Chat2(text)

end

function getRegion(point,range,ignore)
    return workspace:FindPartsInRegion3WithIgnoreList(R3.N(point-V3.N(1,1,1)*range/2,point+V3.N(1,1,1)*range/2),ignore,100)
end

function clerp(startCF,endCF,alpha)
	return startCF:lerp(endCF, alpha)
end

function GetTorso(char)
	return char:FindFirstChild'Torso' or char:FindFirstChild'UpperTorso' or char:FindFirstChild'LowerTorso' or char:FindFirstChild'HumanoidRootPart'
end



function ShowDamage(Pos, Text, Time, Color)

end


function DealDamage(who,minDam,maxDam,Knock,Type,critChance,critMult)

end

function ClosestPart(pos,range)
	local mag,closest = math.huge;
	for _,v in next, getRegion(pos,range or 10,{Char}) do
		if((v.CFrame.p-pos).magnitude < mag)then
			mag = (v.CFrame.p-pos).magnitude
			closest = v
		end
	end
	return closest
end

function AOEBanish(pos,range)
	local mag,closest = math.huge;
	for _,v in next, getRegion(pos,range or 10,{Char}) do
		local who = v.Parent
		if((v.CFrame.p-pos).magnitude < mag and who and who ~= workspace and not Char:IsAncestorOf(v))then
			local plr = S.Players:GetPlayerFromCharacter(who)
			if(plr)then
				BanishedEvents[plr] = plr.CharacterAdded:connect(function(c)
					c:destroy()
				end)
			end
			warn("Banished "..who.Name)
			if(who:FindFirstChild'Head' and Hum.Health > 0)then
				ShowDamage((who.Head.CFrame * CF.N(0, 0, (who.Head.Size.Z / 2)).p+V3.N(M.RNG(-3,3),1.5,M.RNG(-3,3))), "BANISHED", 1.5, C3.N(1,0,0))
			end
			OnceWas(who)
		end
	end
end

function AOEDamage(where,range,minDam,maxDam,Knock,Type,critChance,critMult)
	for _,v in next, getRegion(where,range,{Char}) do
		if(v.Parent and v.Parent:FindFirstChildOfClass'Humanoid')then
			DealDamage(v.Parent,minDam,maxDam,Knock,Type,critChance,critMult)
		end
	end
end

function AOEHeal(where,range,amount)
	local healed = {}
	for _,v in next, getRegion(where,range,{Char}) do
		local hum = (v.Parent and v.Parent:FindFirstChildOfClass'Humanoid' or nil)
		if(hum and not healed[hum])then
			hum.Health = hum.Health + amount
			if(v.Parent:FindFirstChild'Head' and hum.Health > 0)then
				ShowDamage((v.Parent.Head.CFrame * CF.N(0, 0, (v.Parent.Head.Size.Z / 2)).p+V3.N(0,1.5,0)), "+"..amount, 1.5, BrickColor.new'Lime green'.Color)
			end
		end
	end
end

function CastRay(startPos,endPos,range,ignoreList)
	local ray = Ray.new(startPos,(endPos-startPos).unit*range)
	local part,pos,norm = workspace:FindPartOnRayWithIgnoreList(ray,ignoreList or {Char},false,true)
	return part,pos,norm,(pos and (startPos-pos).magnitude)
end

--// Attack Functions \\--


function Show_Mercy()
	Chat "I will show you mercy."
	ShowDamage((Head.CFrame * CF.N(0, 0, (Head.Size.Z / 2)).p+V3.N(M.RNG(-3,3),1.5,M.RNG(-3,3))), "DEBANISHED", 1.5, C3.N(.7,0,0))

	for p,v in next, BanishedEvents do
		warn("Unbanished "..p.Name)
		v:disconnect()
		BanishedEvents[p] = nil
	end
end

function Banishing_Storm()
	Attack = true
	NeutralAnims = false
	Hum.AutoRotate = false
	for i = 0, 2.3, .1 do
		swait()
		Turn(Mouse.Hit.p)
		local Alpha = .15
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.149688482, 0.00629410101, -0.0288102441, 0.908953488, -0.00262140064, -0.416884065, -7.05317973e-08, 0.99998033, -0.00628811028, 0.41689238, 0.00571563188, 0.908935547),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.404874682, -0.991180301, -0.0352490693, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.71690762, -0.991053104, 0.00471016858, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.26718163, 0.394917995, 0.30748421, 0.758522511, -0.65150404, 0.013650775, 0.563350797, 0.666130126, 0.488780826, -0.327535838, -0.363061011, 0.87229985),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.46891451, 0.639140844, 0.117049158, 0.947687626, 0.107383646, 0.300595015, 0.195006967, -0.940317333, -0.278883517, 0.252707064, 0.322912514, -0.912067294),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(-0.232400328, 1.4423281, 0.0608692467, 0.612107515, -0.5404585, -0.577260137, 0.0609407648, 0.760062039, -0.646986902, 0.788422942, 0.360846847, 0.498175651),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110755987, -0.74960357, -0.415038228, -5.42402267e-06, -2.98023224e-07, 1.00000024, -0.500007331, 0.866021454, -2.48476863e-06, -0.866021395, -0.500007272, -4.7981739e-06),Alpha)
	end
	local numberFall = 0;
	repeat
		for i = 0, .8, 0.1 do
			swait()
			Turn(Mouse.Hit.p)
			local Alpha = .3
			RJ.C0 = clerp(RJ.C0,CFrame.new(-0.149688482, 0.00629410101, -0.0288102441, 0.908953488, -0.00262140064, -0.416884065, -7.05317973e-08, 0.99998033, -0.00628811028, 0.41689238, 0.00571563188, 0.908935547),Alpha)
			LH.C0 = clerp(LH.C0,CFrame.new(-0.404874682, -0.991180301, -0.0352490693, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
			RH.C0 = clerp(RH.C0,CFrame.new(0.71690762, -0.991053104, 0.00471016858, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
			LS.C0 = clerp(LS.C0,CFrame.new(-1.26718163, 0.394917995, 0.30748421, 0.758522511, -0.65150404, 0.013650775, 0.563350797, 0.666130126, 0.488780826, -0.327535838, -0.363061011, 0.87229985),Alpha)
			RS.C0 = clerp(RS.C0,CFrame.new(1.47921813, 0.661770463, 0.060773734, 0.947700858, 0.195051998, 0.252622485, 0.194988579, -0.980473101, 0.0255415048, 0.252671421, 0.0250527933, -0.967227817),Alpha)
			NK.C0 = clerp(NK.C0,CFrame.new(-0.232400328, 1.4423281, 0.0608692467, 0.612107515, -0.5404585, -0.577260137, 0.0609407648, 0.760062039, -0.646986902, 0.788422942, 0.360846847, 0.498175651),Alpha)
			HW.C0 = clerp(HW.C0,CFrame.new(-0.110747263, -0.749596298, -0.415039092, -1.66893005e-06, -5.14090061e-06, 1.00000012, -0.500009954, 0.866019845, 3.60608101e-06, -0.866019726, -0.500009894, -3.9935112e-06),Alpha)
		end
		Sound(Barrel,238353911,M.RNG(7,13)/10,10,false,true,true)
		local part,pos,dist = Shoot(Barrel.CFrame.p,Barrel.CFrame*CF.N(0,-1500,0).p)
		if(not part)then
			numberFall = numberFall + 1
		end
		Effect{
			Effect='ResizeAndFade',
			Frames=45,
			Size=V3.N(.1,.1,.1),
			CFrame=Barrel.CFrame,
			Mesh ={MeshType=Enum.MeshType.Sphere},
			Color=BrickColor.new'Really red',
			FXSettings={
				EndSize=V3.N(.05,.05,.05),
				EndIsIncrement=true,
			}
		}
		Effect{
			Effect='ResizeAndFade',
			Frames=45,
			Size=V3.N(.1,.1,.1),
			CFrame=Barrel.CFrame,
			Mesh ={MeshType=Enum.MeshType.Sphere},
			Color=BrickColor.new'Really red',
			FXSettings={
				EndSize=V3.N(.1,.1,.1),
				EndIsIncrement=true,
			}
		}
		for i = 0, .7, 0.1 do
			swait()
			Turn(Mouse.Hit.p)
			local Alpha = .3
			RJ.C0 = clerp(RJ.C0,CFrame.new(-0.149688482, 0.00629410101, -0.0288102441, 0.908953488, -0.00262140064, -0.416884065, -7.05317973e-08, 0.99998033, -0.00628811028, 0.41689238, 0.00571563188, 0.908935547),Alpha)
			LH.C0 = clerp(LH.C0,CFrame.new(-0.404874682, -0.991180301, -0.0352490693, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
			RH.C0 = clerp(RH.C0,CFrame.new(0.71690762, -0.991053104, 0.00471016858, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
			LS.C0 = clerp(LS.C0,CFrame.new(-1.26718163, 0.394917995, 0.30748421, 0.758522511, -0.65150404, 0.013650775, 0.563350797, 0.666130126, 0.488780826, -0.327535838, -0.363061011, 0.87229985),Alpha)
			RS.C0 = clerp(RS.C0,CFrame.new(1.47678053, 0.526562393, 0.174270749, 0.947701395, 0.126782924, 0.292896599, 0.194988653, -0.956529498, -0.216866404, 0.252669275, 0.262636065, -0.931225359),Alpha)
			NK.C0 = clerp(NK.C0,CFrame.new(-0.232400328, 1.4423281, 0.0608692467, 0.612107515, -0.5404585, -0.577260137, 0.0609407648, 0.760062039, -0.646986902, 0.788422942, 0.360846847, 0.498175651),Alpha)
			HW.C0 = clerp(HW.C0,CFrame.new(-0.110761039, -0.749590993, -0.415038049, 5.96046448e-07, -4.7236681e-06, 1.00000012, -0.500009775, 0.866019845, 4.39817086e-06, -0.866019845, -0.500009775, -1.90734863e-06),Alpha)
		end
	until not S.UserInputService:IsKeyDown(Enum.KeyCode.Z)
	delay(2, function()
		for i = 1, numberFall*2 do
			local part,pos,dist = ClosestPart(Mouse.Hit.p,2),Mouse.Hit.p+V3.N(M.RNG(-100,100)/100,0,M.RNG(-100,100)/100),1500
			Effect{
				Effect='Fade',
				Frames=15,
				Size=V3.N(.15,dist,.15),
				CFrame=CF.N(pos)*CF.N(0,dist/2,0),
				Color=BrickColor.new'Really red',
			}
			Effect{
				Effect='ResizeAndFade',
				Frames=45,
				Size=V3.N(.5,.5,.5),
				CFrame=CF.N(pos),
				Mesh ={MeshType=Enum.MeshType.Sphere},
				Color=BrickColor.new'Really red',
				FXSettings={
					EndSize=V3.N(.05,.05,.05),
					EndIsIncrement=true,
				}
			}
			for i = 1, 5 do
				Effect{
					Effect='ResizeAndFade',
					Frames=65,
					Size=V3.N(.2,.2,1),
					CFrame=CF.N(CF.N(pos)*CF.A(M.RRNG(-180,180),M.RRNG(-180,180),M.RRNG(-180,180))*CF.N(0,0,-2).p,pos),
					Mesh = {MeshType=Enum.MeshType.Sphere},
					Material=Enum.Material.Neon,
					Color=BrickColor.new'Really red',
					FXSettings={
						EndSize=V3.N(.005,.005,.05),
						EndIsIncrement=true,
					}
				}	
			end
			if(part and part.Parent and part.Parent ~= workspace)then
				local part = part
				local who = part.Parent
				OnceWas(who)
				local plr = S.Players:GetPlayerFromCharacter(who)
				if(plr)then
					BanishedEvents[plr] = plr.CharacterAdded:connect(function(c)
						c:destroy()
					end)
				end
				if(who:FindFirstChild'Head' and Hum.Health > 0)then
					ShowDamage((who.Head.CFrame * CF.N(0, 0, (who.Head.Size.Z / 2)).p+V3.N(M.RNG(-3,3),1.5,M.RNG(-3,3))), "BANISHED", 1.5, C3.N(1,0,0))
				end
			end
			swait(5)
		end	
	end)
	Hum.AutoRotate = true
	Attack = false
	NeutralAnims = true
end

function Spectral_Banish()
	Attack = true
	Chat "If you desire to be a ghost.."
	swait(120)
	Chat "Then move on to the afterlife!"
	NeutralAnims = false
	Hum.AutoRotate = false	
	for i = 0, 6, .1 do
		swait()
		Turn(Mouse.Hit.p)
		local Alpha = .15
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.149688482, 0.00629410101, -0.0288102441, 0.908953488, -0.00262140064, -0.416884065, -7.05317973e-08, 0.99998033, -0.00628811028, 0.41689238, 0.00571563188, 0.908935547),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.404874682, -0.991180301, -0.0352490693, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.71690762, -0.991053104, 0.00471016858, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.26718163, 0.394917995, 0.30748421, 0.758522511, -0.65150404, 0.013650775, 0.563350797, 0.666130126, 0.488780826, -0.327535838, -0.363061011, 0.87229985),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.46891451, 0.639140844, 0.117049158, 0.947687626, 0.107383646, 0.300595015, 0.195006967, -0.940317333, -0.278883517, 0.252707064, 0.322912514, -0.912067294),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(-0.232400328, 1.4423281, 0.0608692467, 0.612107515, -0.5404585, -0.577260137, 0.0609407648, 0.760062039, -0.646986902, 0.788422942, 0.360846847, 0.498175651),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110755987, -0.74960357, -0.415038228, -5.42402267e-06, -2.98023224e-07, 1.00000024, -0.500007331, 0.866021454, -2.48476863e-06, -0.866021395, -0.500007272, -4.7981739e-06),Alpha)
	end
	for i = 0, .8, 0.1 do
		swait()
		Turn(Mouse.Hit.p)
		local Alpha = .3
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.149688482, 0.00629410101, -0.0288102441, 0.908953488, -0.00262140064, -0.416884065, -7.05317973e-08, 0.99998033, -0.00628811028, 0.41689238, 0.00571563188, 0.908935547),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.404874682, -0.991180301, -0.0352490693, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.71690762, -0.991053104, 0.00471016858, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.26718163, 0.394917995, 0.30748421, 0.758522511, -0.65150404, 0.013650775, 0.563350797, 0.666130126, 0.488780826, -0.327535838, -0.363061011, 0.87229985),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.47921813, 0.661770463, 0.060773734, 0.947700858, 0.195051998, 0.252622485, 0.194988579, -0.980473101, 0.0255415048, 0.252671421, 0.0250527933, -0.967227817),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(-0.232400328, 1.4423281, 0.0608692467, 0.612107515, -0.5404585, -0.577260137, 0.0609407648, 0.760062039, -0.646986902, 0.788422942, 0.360846847, 0.498175651),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110747263, -0.749596298, -0.415039092, -1.66893005e-06, -5.14090061e-06, 1.00000012, -0.500009954, 0.866019845, 3.60608101e-06, -0.866019726, -0.500009894, -3.9935112e-06),Alpha)
	end
	Sound(Barrel,238353911,M.RNG(7,13)/10,10,false,true,true)
	Effect{
		Effect='ResizeAndFade',
		Frames=45,
		Size=V3.N(.1,.1,.1),
		CFrame=Barrel.CFrame,
		Mesh ={MeshType=Enum.MeshType.Sphere},
		Color=BrickColor.new'Really red',
		FXSettings={
			EndSize=V3.N(.05,.05,.05),
			EndIsIncrement=true,
		}
	}
	Effect{
		Effect='ResizeAndFade',
		Frames=45,
		Size=V3.N(.1,.1,.1),
		CFrame=Barrel.CFrame,
		Mesh ={MeshType=Enum.MeshType.Sphere},
		Color=BrickColor.new'Really red',
		FXSettings={
			EndSize=V3.N(.1,.1,.1),
			EndIsIncrement=true,
		}
	}
	for i = 1, 5 do
		local angles = CF.A(M.RRNG(-180,180),M.RRNG(-180,180),M.RRNG(-180,180))
		local cf = Barrel.CFrame
		Effect{
			Effect='ResizeAndFade',
			Frames=65,
			Size=V3.N(.2,.2,1),
			CFrame=CF.N(CF.N(cf.p)*angles*CF.N(0,0,-2).p,cf.p),
			Mesh = {MeshType=Enum.MeshType.Sphere},
			Material=Enum.Material.Neon,
			Color=BrickColor.new'Really red',
			MoveDirection=CF.N(CF.N(cf.p)*angles*CF.N(0,0,-25).p,cf.p).p,
			FXSettings={
				EndSize=V3.N(.005,.005,.05),
				EndIsIncrement=true,
			}
		}	
	end
	Effect{
		Effect='Fade',
		Frames=35,
		Size=V3.N(.15,2048,.15),
		CFrame=CF.N(Barrel.CFrame.p)*CF.N(0,2048/2,0),
		Color=BrickColor.new'Really red',
	}
	for i = 0, .8, .1 do
		swait()
		Turn(Mouse.Hit.p)
		local Alpha = .15
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.149688482, 0.00629410101, -0.0288102441, 0.908953488, -0.00262140064, -0.416884065, -7.05317973e-08, 0.99998033, -0.00628811028, 0.41689238, 0.00571563188, 0.908935547),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.404874682, -0.991180301, -0.0352490693, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.71690762, -0.991053104, 0.00471016858, 0.902334571, -7.05317973e-08, 0.4310323, -0.00271031447, 0.99998033, 0.00567401201, -0.431023717, -0.00628811028, 0.902316749),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.26718163, 0.394917995, 0.30748421, 0.758522511, -0.65150404, 0.013650775, 0.563350797, 0.666130126, 0.488780826, -0.327535838, -0.363061011, 0.87229985),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.46891451, 0.639140844, 0.117049158, 0.947687626, 0.107383646, 0.300595015, 0.195006967, -0.940317333, -0.278883517, 0.252707064, 0.322912514, -0.912067294),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(-0.232400328, 1.4423281, 0.0608692467, 0.612107515, -0.5404585, -0.577260137, 0.0609407648, 0.760062039, -0.646986902, 0.788422942, 0.360846847, 0.498175651),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110755987, -0.74960357, -0.415038228, -5.42402267e-06, -2.98023224e-07, 1.00000024, -0.500007331, 0.866021454, -2.48476863e-06, -0.866021395, -0.500007272, -4.7981739e-06),Alpha)
	end
	for _,v in next, S.Players:players() do
		if(v.Character and v.Character:FindFirstChild'Head' and not v.Character.Parent)then
			pcall(function()
				v.Character.Parent = workspace
				local tor = v.Character:FindFirstChild'Head'
				Effect{
					Effect='Fade',
					Frames=15,
					Size=V3.N(.15,2048,.15),
					CFrame=CF.N(tor.CFrame.p)*CF.N(0,2048/2,0),
					Color=BrickColor.new'Really red',
				}
				Effect{
					Effect='ResizeAndFade',
					Frames=45,
					Size=V3.N(.5,.5,.5),
					CFrame=CF.N(tor.CFrame.p),
					Mesh ={MeshType=Enum.MeshType.Sphere},
					Color=BrickColor.new'Really red',
					FXSettings={
						EndSize=V3.N(.05,.05,.05),
						EndIsIncrement=true,
					}
				}
				for i = 1, 5 do
					Effect{
						Effect='ResizeAndFade',
						Frames=65,
						Size=V3.N(.2,.2,1),
						CFrame=CF.N(CF.N(tor.CFrame.p)*CF.A(M.RRNG(-180,180),M.RRNG(-180,180),M.RRNG(-180,180))*CF.N(0,0,-2).p,tor.CFrame.p),
						Mesh = {MeshType=Enum.MeshType.Sphere},
						Material=Enum.Material.Neon,
						Color=BrickColor.new'Really red',
						FXSettings={
							EndSize=V3.N(.005,.005,.05),
							EndIsIncrement=true,
						}
					}	
				end
				local asd = v.Character;
				OnceWas(asd)
				v.Character:destroy()
				BanishedEvents[v] = v.CharacterAdded:connect(function(c)
					c:destroy()
				end)
			end)
		end
	end
	Hum.AutoRotate = true
	Attack = false
	NeutralAnims = true
end

function Teleport()
	Attack = true
	NeutralAnims = false
	Hum.AutoRotate = false
	repeat
		Turn(Mouse.Hit.p)
		swait()
		local Alpha = .1
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.027945349, 0.0062955129, 0.00791542884, -4.65661287e-09, 0.00628571073, 0.99997133, -1.62185909e-08, 0.99998033, -0.00628576661, -0.999991417, -3.25962901e-09, -9.31322575e-10),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.513343155, -0.990872025, 0.0134561155, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.504049361, -0.991316199, -0.037166521, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.48807681, 0.583711386, -0.00375273079, 0.980986238, 0.193449557, 0.0156120034, -0.193565607, 0.981067359, 0.00628500059, -0.0141005944, -0.00918744504, 0.999858379),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.56039762, 0.53398639, -0.0236691795, 0.0156120034, -0.99157083, 0.128623411, 0.00628500059, -0.128539219, -0.991684735, 0.999858379, 0.0162905809, 0.00422526803),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(0.0128910094, 1.4991622, 0.0185256526, -1.87195837e-07, 0.0574935488, -0.998337269, 0.0062853531, 0.998326361, 0.0574929118, 0.99997133, -0.00627500238, -0.00036155805),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110757828, -0.749616861, -0.415070713, 0, 0, 1, -0.500001788, 0.866024435, 0, -0.866024435, -0.500001788, 0),Alpha)
	until not S.UserInputService:IsKeyDown(Enum.KeyCode.C)
	Sound(Barrel,238353911,M.RNG(7,13)/10,10,false,true,true)
	local pos,dist = Mouse.Hit.p,(Barrel.CFrame.p-Mouse.Hit.p).magnitude
	Effect{
		Effect='ResizeAndFade',
		Frames=45,
		Size=V3.N(.1,.1,.1),
		CFrame=Barrel.CFrame,
		Mesh ={MeshType=Enum.MeshType.Sphere},
		Color=BrickColor.new'Really red',
		FXSettings={
			EndSize=V3.N(.05,.05,.05),
			EndIsIncrement=true,
		}
	}
	Effect{
		Effect='ResizeAndFade',
		Frames=45,
		Size=V3.N(.1,.1,.1),
		CFrame=Barrel.CFrame,
		Mesh ={MeshType=Enum.MeshType.Sphere},
		Color=BrickColor.new'Really red',
		FXSettings={
			EndSize=V3.N(.1,.1,.1),
			EndIsIncrement=true,
		}
	}

	Effect{
		Effect='Fade',
		Frames=15,
		Size=V3.N(.15,.15,dist),
		CFrame=CF.N(Barrel.CFrame.p,pos)*CF.N(0,0,-dist/2),
		Color=BrickColor.new'Really red',
	}
	for i = 0, .3, .05 do
		swait()
		local Alpha = .3
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.027945349, 0.0062955129, 0.00791542884, -4.65661287e-09, 0.00628571073, 0.99997133, -1.62185909e-08, 0.99998033, -0.00628576661, -0.999991417, -3.25962901e-09, -9.31322575e-10),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.513343155, -0.990872025, 0.0134561155, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.504049361, -0.991316199, -0.037166521, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.48807681, 0.583711386, -0.00375273079, 0.980986238, 0.193449557, 0.0156120034, -0.193565607, 0.981067359, 0.00628500059, -0.0141005944, -0.00918744504, 0.999858379),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.43598688, 0.64456445, -0.0224216785, 0.0156120034, -0.933606386, 0.357960403, 0.00628500059, -0.357905358, -0.933736861, 0.999858379, 0.0168272816, 0.000280098058),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(0.0128910094, 1.4991622, 0.0185256526, -1.87195837e-07, 0.0574935488, -0.998337269, 0.0062853531, 0.998326361, 0.0574929118, 0.99997133, -0.00627500238, -0.00036155805),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110757828, -0.749611259, -0.415075362, 0, 0, 1, -0.500002265, 0.866024256, 0, -0.866024256, -0.500002265, 0),Alpha)
	end
	OnceWas(Char,true)
	Torso.CFrame = CF.N(pos)*CF.N(0,3,0)
	for i = 1, 15 do
		local angles = CF.A(M.RRNG(-180,180),M.RRNG(-180,180),M.RRNG(-180,180))
		local cf = Torso.CFrame
		Effect{
			Effect='ResizeAndFade',
			Frames=65,
			Size=V3.N(2,2,10),
			CFrame=CF.N(CF.N(cf.p)*angles*CF.N(0,0,-2).p,cf.p),
			Mesh = {MeshType=Enum.MeshType.Sphere},
			Material=Enum.Material.Neon,
			Color=BrickColor.new'Really red',
			MoveDirection=CF.N(CF.N(cf.p)*angles*CF.N(0,0,-25).p,cf.p).p,
			FXSettings={
				EndSize=V3.N(.005,.005,.05),
				EndIsIncrement=true,
			}
		}	
	end
	OnceWas(Char,true)
	for i = 0, .4, .05 do
		swait()
		local Alpha = .3
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.027945349, 0.0062955129, 0.00791542884, -4.65661287e-09, 0.00628571073, 0.99997133, -1.62185909e-08, 0.99998033, -0.00628576661, -0.999991417, -3.25962901e-09, -9.31322575e-10),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.513343155, -0.990872025, 0.0134561155, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.504049361, -0.991316199, -0.037166521, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.48807681, 0.583711386, -0.00375273079, 0.980986238, 0.193449557, 0.0156120034, -0.193565607, 0.981067359, 0.00628500059, -0.0141005944, -0.00918744504, 0.999858379),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.56039762, 0.53398639, -0.0236691795, 0.0156120034, -0.99157083, 0.128623411, 0.00628500059, -0.128539219, -0.991684735, 0.999858379, 0.0162905809, 0.00422526803),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(0.0128910094, 1.4991622, 0.0185256526, -1.87195837e-07, 0.0574935488, -0.998337269, 0.0062853531, 0.998326361, 0.0574929118, 0.99997133, -0.00627500238, -0.00036155805),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110757828, -0.749616861, -0.415070713, 0, 0, 1, -0.500001788, 0.866024435, 0, -0.866024435, -0.500001788, 0),Alpha)
	end
	Attack = false
	NeutralAnims = true
	Hum.AutoRotate = true
end

function BGone()
	Attack = true
	NeutralAnims = false
	Hum.AutoRotate = false
	Chat "Be gone.."
	--repeat 
	for i = 0, 9, .1 do
		Turn(Mouse.Hit.p)
		swait()
		Hum.WalkSpeed = 0
		local Alpha = .1
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.0296121463, -0.249109969, -0.153551444, -0.000328990631, -0.0094739655, -0.999952853, 0.204196915, 0.978885293, -0.0093415454, 0.978927732, -0.204190359, 0.0016125096),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.475788742, -0.651965797, 0.0191618577, 0.978805363, 0.204197079, 0.0156120053, -0.204313993, 0.978885233, 0.00628500246, -0.0139989806, -0.0093415454, 0.999858379),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.498535633, -0.912865818, 0.0149653442, 0.999878168, 5.14090061e-06, 0.0156120053, -0.000103279948, 0.999980271, 0.00628500246, -0.0156116625, -0.00628584996, 0.999858379),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.29815638, 0.566930115, -0.00661327224, -0.237626657, 0.971231222, 0.0156120053, -0.971307039, -0.237746239, 0.00628500246, 0.00981588662, -0.0136705656, 0.999858379),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.24513125, 0.449408412, -0.155189604, 0.502771139, -0.519900203, -0.690597773, 0.303394169, 0.854222655, -0.422203362, 0.809427798, 0.00274830475, 0.587213099),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(-0.0153051838, 1.498806, -0.0364812165, 1.34855509e-06, 0.0477146953, 0.998861074, -0.00628432725, 0.998841345, -0.0477137454, -0.999980271, -0.00627710624, 0.000301202759),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110760681, -0.749610901, -0.415069938, -1.63912773e-06, 9.19401646e-06, 1.00000024, -0.500005245, 0.866022348, -8.86109865e-06, -0.866022408, -0.500005245, 3.1888485e-06),Alpha)
	end
	--until not S.UserInputService:IsKeyDown(Enum.KeyCode.V)
	
	for i = 0, .7, 0.1 do
		swait()
		Hum.WalkSpeed = 0
		local Alpha = .3
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.00766070001, -0.269241363, -0.0518192649, 0.00021806825, 0.00368537591, 0.99999094, -0.166544884, 0.9860273, -0.00359759619, -0.986031651, -0.166542619, 0.000828802586),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.497863114, -0.984335184, 0.0215952508, 0.987798393, 0.154953942, 0.0156120034, -0.155066714, 0.987884164, 0.00628500665, -0.0144489631, -0.00862922147, 0.999858379),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.462316692, -0.882526457, 0.015341443, 0.985910237, -0.166545048, 0.0156120034, 0.166465312, 0.9860273, 0.00628500665, -0.0164405983, -0.00359759573, 0.999858379),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.34305215, 0.64557004, 0.206238627, 0.819938838, 0.417069167, 0.392114401, -0.412350535, 0.905431569, -0.100800663, -0.397073597, -0.0790382028, 0.914377153),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.3656987, 0.557721138, -0.0314715505, 0.0156120034, -0.985910237, 0.166545048, 0.00628500665, -0.166465312, -0.9860273, 0.999858379, 0.0164405983, 0.00359759573),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(0.0260951146, 1.49902618, -0.00289419782, -1.0067597e-06, 0.0574942529, -0.998345912, 0.00628517801, 0.998326182, 0.0574931316, 0.999980211, -0.00627472438, -0.000362364575),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.11075601, -0.749610424, -0.415073156, 0, 0, 1, -0.500000238, 0.866025388, 0, -0.866025388, -0.500000238, 0),Alpha)
	end

	Sound(Barrel,238353911,M.RNG(7,13)/10,10,false,true,true)
	Sound(Barrel,415700134,1.6,10,false,true,true)
	Sound(Barrel,138677306,1.2,7,false,true,true)
	coroutine.wrap(function()
		local cf = Root.CFrame * CF.N(0,0,-2)
		for i = 1, 100 do
			Effect{
				Effect='ResizeAndFade',
				CFrame = cf*CF.A(M.R(90),0,M.R(90)),
				Size=V3.N(2,5,5),
				Material=Enum.Material.Neon,
				Color=BrickColor.new'Crimson',
				Shape='Cylinder',
				FXSettings={
					EndSize=V3.N(0,.3,.3),
					EndIsIncrement=true
				}
			}
			for i = 1, 3 do
				local angles = CF.A(M.RRNG(-180,180),M.RRNG(-180,180),M.RRNG(-180,180))
				Effect{
					Effect='ResizeAndFade',
					Frames=65,
					Size=V3.N(1,1,1),
					CFrame=CF.N(CF.N(cf.p)*angles*CF.N(0,0,-10).p,cf.p),
					Mesh = {MeshType=Enum.MeshType.Sphere},
					Material=Enum.Material.Neon,
					Color=BrickColor.new'Really red',
					MoveDirection=CF.N(CF.N(cf.p)*angles*CF.N(0,0,-50).p,cf.p).p,
					FXSettings={
						EndSize=V3.N(0,0,.3),
						EndIsIncrement=true,
					}
				}	
			end
			AOEBanish(cf.p,8)
			cf = cf*CF.N(0,0,-2)
			swait()
		end
	end)()
	swait(30)
	Hum.WalkSpeed = 16
	Attack = false
	NeutralAnims = true
	Hum.AutoRotate = true
end
function Banisher_Bullet()
	Attack = true
	NeutralAnims = false
	Hum.AutoRotate = false
	for i = 0, .4, .1/3 do
		Turn(Mouse.Hit.p)
		swait()
		local Alpha = .1
		RJ.C0 = clerp(RJ.C0,CFrame.new(-0.027945349, 0.0062955129, 0.00791542884, -4.65661287e-09, 0.00628571073, 0.99997133, -1.62185909e-08, 0.99998033, -0.00628576661, -0.999991417, -3.25962901e-09, -9.31322575e-10),Alpha)
		LH.C0 = clerp(LH.C0,CFrame.new(-0.513343155, -0.990872025, 0.0134561155, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
		RH.C0 = clerp(RH.C0,CFrame.new(0.504049361, -0.991316199, -0.037166521, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
		LS.C0 = clerp(LS.C0,CFrame.new(-1.48807681, 0.583711386, -0.00375273079, 0.980986238, 0.193449557, 0.0156120034, -0.193565607, 0.981067359, 0.00628500059, -0.0141005944, -0.00918744504, 0.999858379),Alpha)
		RS.C0 = clerp(RS.C0,CFrame.new(1.56039762, 0.53398639, -0.0236691795, 0.0156120034, -0.99157083, 0.128623411, 0.00628500059, -0.128539219, -0.991684735, 0.999858379, 0.0162905809, 0.00422526803),Alpha)
		NK.C0 = clerp(NK.C0,CFrame.new(0.0128910094, 1.4991622, 0.0185256526, -1.87195837e-07, 0.0574935488, -0.998337269, 0.0062853531, 0.998326361, 0.0574929118, 0.99997133, -0.00627500238, -0.00036155805),Alpha)
		HW.C0 = clerp(HW.C0,CFrame.new(-0.110757828, -0.749616861, -0.415070713, 0, 0, 1, -0.500001788, 0.866024435, 0, -0.866024435, -0.500001788, 0),Alpha)
	end
	repeat
		for i = 0, .2, .1/3 do
			Turn(Mouse.Hit.p)
			swait()
			local Alpha = .1
			RJ.C0 = clerp(RJ.C0,CFrame.new(-0.027945349, 0.0062955129, 0.00791542884, -4.65661287e-09, 0.00628571073, 0.99997133, -1.62185909e-08, 0.99998033, -0.00628576661, -0.999991417, -3.25962901e-09, -9.31322575e-10),Alpha)
			LH.C0 = clerp(LH.C0,CFrame.new(-0.513343155, -0.990872025, 0.0134561155, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
			RH.C0 = clerp(RH.C0,CFrame.new(0.504049361, -0.991316199, -0.037166521, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
			LS.C0 = clerp(LS.C0,CFrame.new(-1.48807681, 0.583711386, -0.00375273079, 0.980986238, 0.193449557, 0.0156120034, -0.193565607, 0.981067359, 0.00628500059, -0.0141005944, -0.00918744504, 0.999858379),Alpha)
			RS.C0 = clerp(RS.C0,CFrame.new(1.43598688, 0.64456445, -0.0224216785, 0.0156120034, -0.933606386, 0.357960403, 0.00628500059, -0.357905358, -0.933736861, 0.999858379, 0.0168272816, 0.000280098058),Alpha)
			NK.C0 = clerp(NK.C0,CFrame.new(0.0128910094, 1.4991622, 0.0185256526, -1.87195837e-07, 0.0574935488, -0.998337269, 0.0062853531, 0.998326361, 0.0574929118, 0.99997133, -0.00627500238, -0.00036155805),Alpha)
			HW.C0 = clerp(HW.C0,CFrame.new(-0.110757828, -0.749611259, -0.415075362, 0, 0, 1, -0.500002265, 0.866024256, 0, -0.866024256, -0.500002265, 0),Alpha)
		end
		Sound(Barrel,238353911,M.RNG(7,13)/10,10,false,true,true)
		Shoot(Barrel.CFrame.p,Mouse.Hit.p)
		for i = 0, .3, .1/3 do
			swait()
			local Alpha = .1
			RJ.C0 = clerp(RJ.C0,CFrame.new(-0.027945349, 0.0062955129, 0.00791542884, -4.65661287e-09, 0.00628571073, 0.99997133, -1.62185909e-08, 0.99998033, -0.00628576661, -0.999991417, -3.25962901e-09, -9.31322575e-10),Alpha)
			LH.C0 = clerp(LH.C0,CFrame.new(-0.513343155, -0.990872025, 0.0134561155, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
			RH.C0 = clerp(RH.C0,CFrame.new(0.504049361, -0.991316199, -0.037166521, 0.999878228, 0, 0.0156120034, -9.81333942e-05, 0.99998033, 0.00628500059, -0.0156116933, -0.00628576661, 0.999858379),Alpha)
			LS.C0 = clerp(LS.C0,CFrame.new(-1.48807681, 0.583711386, -0.00375273079, 0.980986238, 0.193449557, 0.0156120034, -0.193565607, 0.981067359, 0.00628500059, -0.0141005944, -0.00918744504, 0.999858379),Alpha)
			RS.C0 = clerp(RS.C0,CFrame.new(1.46904922, 0.532365739, -0.0222326554, 0.0156120034, -0.987360775, 0.157718793, 0.00628500059, -0.157637998, -0.987477064, 0.999858379, 0.0164077543, 0.00374451769),Alpha)
			NK.C0 = clerp(NK.C0,CFrame.new(0.0128910094, 1.4991622, 0.0185256526, -1.87195837e-07, 0.0574935488, -0.998337269, 0.0062853531, 0.998326361, 0.0574929118, 0.99997133, -0.00627500238, -0.00036155805),Alpha)
			HW.C0 = clerp(HW.C0,CFrame.new(-0.110757828, -0.749605894, -0.415075004, 0, 0, 1, -0.50000155, 0.866024613, 0, -0.866024613, -0.50000149, 0),Alpha)
		end
	until not S.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
	Hum.AutoRotate = true
	Attack = false
	NeutralAnims = true
end

function Taunt()
	Attack = true
	NeutralAnims = false
	local taunt = 1 --M.RNG(1,3)
	if(taunt == 1)then		
		
		local rad = 0
		for i = 0, 6, 0.1 do
			swait()
			rad = rad + 35
			local Alpha = .3
			RJ.C0 = clerp(RJ.C0,CFrame.new(5.9524434e-13, 0.00629317388, 1.41309647e-06, 0.99999553, 9.4587449e-11, 0, -5.58664226e-12, 0.999980271, -0.00628617778, 9.31322575e-10, 0.00628615683, 0.99997592),Alpha)
			LH.C0 = clerp(LH.C0,CFrame.new(-0.500225782, -0.996483386, 0.0217089336, 0.994214952, 0.10624785, 0.0156119671, -0.106356524, 0.994308293, 0.00628523249, -0.014855314, -0.00790933147, 0.999856234),Alpha)
			RH.C0 = clerp(RH.C0,CFrame.new(0.512264967, -0.996646643, 0.0152785685, 0.994214535, -0.106250875, 0.0156119233, 0.106164388, 0.994328737, 0.00628523249, -0.0161911994, -0.0045914636, 0.999856234),Alpha)
			LS.C0 = clerp(LS.C0,CFrame.new(-1.44726694, 0.503729105, -0.00388534926, 0.993391156, 0.113691822, 0.0156119671, -0.113801189, 0.993483663, 0.00628523249, -0.0147956526, -0.00802037865, 0.999856234),Alpha)
			RS.C0 = clerp(RS.C0,CFrame.new(1.41887283, 0.461011291, -0.0306870341, 0.0158389043, -0.994383454, -0.104623824, 0.00844715256, 0.104766518, -0.994461119, 0.999836862, 0.0148673952, 0.0100591201),Alpha)
			NK.C0 = clerp(NK.C0,CFrame.new(8.88854265e-06, 1.49895382, -0.0144050419, 0.566473544, 0.0473791771, -0.82271415, 0.00518015958, 0.99812144, 0.0610474497, 0.824061036, -0.0388435796, 0.56516397),Alpha)
			HW.C0 = clerp(HW.C0,CFrame.new(-0.11075747, -0.749606431, -0.415068656, -5.63569483e-06, -1.58343755e-06, 1.00000012, -0.500001132, 0.866024792, -1.44650403e-06, -0.866024852, -0.500001192, -5.67225288e-06)*CF.A(0,0,M.R(rad)),Alpha)
		end
		Chat (TauntDialogues[M.RNG(1,#TauntDialogues)])
		for i = 0, 6, 0.1 do
			swait()
			local Alpha = .3
			RJ.C0 = clerp(RJ.C0,CFrame.new(5.9524434e-13, 0.00629317388, 1.41309647e-06, 0.99999553, 9.4587449e-11, 0, -5.58664226e-12, 0.999980271, -0.00628617778, 9.31322575e-10, 0.00628615683, 0.99997592),Alpha)
			LH.C0 = clerp(LH.C0,CFrame.new(-0.500225782, -0.996483386, 0.0217089336, 0.994214952, 0.10624785, 0.0156119671, -0.106356524, 0.994308293, 0.00628523249, -0.014855314, -0.00790933147, 0.999856234),Alpha)
			RH.C0 = clerp(RH.C0,CFrame.new(0.512264967, -0.996646643, 0.0152785685, 0.994214535, -0.106250875, 0.0156119233, 0.106164388, 0.994328737, 0.00628523249, -0.0161911994, -0.0045914636, 0.999856234),Alpha)
			LS.C0 = clerp(LS.C0,CFrame.new(-1.44726694, 0.503729105, -0.00388534926, 0.993391156, 0.113691822, 0.0156119671, -0.113801189, 0.993483663, 0.00628523249, -0.0147956526, -0.00802037865, 0.999856234),Alpha)
			RS.C0 = clerp(RS.C0,CFrame.new(1.30098641, 0.458334863, -0.45630464, 0.97372508, 0.226236522, 0.0259280894, 0.00073058781, 0.110756524, -0.99384743, -0.227716282, 0.967752993, 0.10768114),Alpha)
			NK.C0 = clerp(NK.C0,CFrame.new(8.21147114e-06, 1.49895406, -0.0144038275, 0.99988234, -0.000873879122, 0.0151748769, -9.55477299e-05, 0.997964978, 0.0637657493, -0.015199719, -0.0637597144, 0.997847497),Alpha)
			HW.C0 = clerp(HW.C0,CFrame.new(-0.110763341, -0.749599576, -0.415068239, -6.5267086e-06, -2.71201134e-06, 1.00000012, -0.500001013, 0.866024971, -9.23871994e-07, -0.866024971, -0.500001013, -7.01099634e-06),Alpha)
		end
	end
	Attack = false
	NeutralAnims = true	
end

Mouse.KeyDown:connect(function(k)
	if(Attack)then return end
	if(k == 'x')then Show_Mercy() end
	if(k == 'z')then Banishing_Storm() end
	if(k == 'b')then Spectral_Banish() end
	if(k == 'c')then Teleport() end
	if(k == 'v')then BGone() end
	if(k == 't')then Taunt() end
	
end)
Mouse.Button1Down:connect(function()
	if(Attack)then return end
	Banisher_Bullet()
end)
--// Wrap it all up \\--

Plr.Chatted:connect(function(m)
	local succ,text = pcall(function() return game:service'Chat':FilterStringForBroadcast(m,Plr) end)
	if(not succ)then
		text = string.rep("_",#text)
	end
	Chat(text)
end)
while true do
	swait()
	Sine = Sine + Change
	--[[if(not Music or not Music.Parent)then
		local a = Music.TimePosition
		Music = Sound(Char,MusicID,1,1,true,false,true)
		Music.Name = 'Music'
		Music.TimePosition = a
	end
	Music.Volume = 1
	Music.Pitch = 1
	Music.Playing = true]]
	Sine = Sine + Change
	local hitfloor,posfloor = workspace:FindPartOnRay(Ray.new(Root.CFrame.p,((CFrame.new(Root.Position,Root.Position - Vector3.new(0,1,0))).lookVector).unit * 4), Char)
	local Walking = (math.abs(Root.Velocity.x) > 1 or math.abs(Root.Velocity.z) > 1)
	local State = (Hum.PlatformStand and 'Paralyzed' or Hum.Sit and 'Sit' or not hitfloor and Root.Velocity.y < -1 and "Fall" or not hitfloor and Root.Velocity.y > 1 and "Jump" or hitfloor and Walking and "Walk" or hitfloor and "Idle")
	if(State == 'Walk')then
		local wsVal = 32 / (Hum.WalkSpeed/14)
		local Alpha = math.min(.1 * (Hum.WalkSpeed/16),1)
		Change = 2
		RH.C1 = RH.C1:lerp(CF.N(0,1,0)*CF.N(0,0-.2*M.C(Sine/wsVal),0+.4*M.C(Sine/wsVal))*CF.A(M.R(25+45*M.C(Sine/wsVal))+-M.S(Sine/wsVal),0,0),Alpha)
		LH.C1 = LH.C1:lerp(CF.N(0,1,0)*CF.N(0,0+.2*M.C(Sine/wsVal),0-.4*M.C(Sine/wsVal))*CF.A(M.R(25-45*M.C(Sine/wsVal))+M.S(Sine/wsVal),0,0),Alpha)
	else
		RH.C1 = RH.C1:lerp(CF.N(0,1,0),.1)
		LH.C1 = LH.C1:lerp(CF.N(0,1,0),.1)
	end	
	if(NeutralAnims)then	
		if(State == 'Idle')then
			Change = .5
			local Alpha = .1
			RJ.C0 = clerp(RJ.C0,CFrame.new(5.95311994e-13, 0.00629388914+.2*M.C(Sine/20), 1.41759301e-06, 0.99999553, 9.4587449e-11, 0, -5.58664226e-12, 0.999980271, -0.00628617778, 9.31322575e-10, 0.00628615683, 0.99997592),Alpha)
			LH.C0 = clerp(LH.C0,CFrame.new(-0.560905516, -0.984790266-.2*M.C(Sine/20), 0.0225828942, 0.997905374, 0.0627432317, 0.0156119671, -0.062847726, 0.998003423, 0.00628523249, -0.0151864393, -0.00725326827, 0.999856234),Alpha)
			RH.C0 = clerp(RH.C0,CFrame.new(0.507978499, -0.98526901-.2*M.C(Sine/20), 0.0152739538, 0.995106399, -0.0975458771, 0.0156119671, 0.0974583924, 0.995219886, 0.00628523249, -0.016150441, -0.00473298226, 0.999856234),Alpha)
			LS.C0 = clerp(LS.C0,CFrame.new(-0.997352481, 0.328557909+.1*M.C(Sine/20), 0.373372614, 0.726782799, -0.595508456, 0.342274755, 0.369578063, 0.759076476, 0.535924494, -0.578960299, -0.263003558, 0.771770597),Alpha)
			RS.C0 = clerp(RS.C0,CFrame.new(1.35597444, 0.402479589+.1*M.C(Sine/20), 0.0100756176, 0.788939416, -0.614269078, 0.0156119671, 0.614255786, 0.78908211, 0.00628523249, -0.0161799639, 0.00463105366, 0.999856234),Alpha)
			NK.C0 = clerp(NK.C0,CFrame.new(4.35163702e-06, 1.4989562, -0.0144046843, 0.99999553, 3.67523171e-07, -1.62050128e-07, -3.56434612e-07, 0.997964919, 0.0637686774, 1.8440187e-07, -0.0637684539, 0.997960329)*CF.A(M.R(-6*-M.C(Sine/20)),0,0),Alpha)
			HW.C0 = clerp(HW.C0,CFrame.new(-0.110785089, -0.749598742, -0.415072441, 2.87592411e-06, 1.69873238e-06, 1.00000012, -0.500000358, 0.866025329, 0, -0.866025269, -0.500000358, 3.33799494e-06),Alpha)
		elseif(State == 'Walk')then
			local wsVal = 32 / (Hum.WalkSpeed/14)
			local Alpha = math.min(.1 * (Hum.WalkSpeed/16),1)
			RJ.C0 = RJ.C0:lerp(RJC0*CF.N(0,0-.15*M.C(Sine/(wsVal/2)),0)*CF.A(0,M.R(0-15*M.S(Sine/wsVal)/2),0),Alpha)
			NK.C0 = NK.C0:lerp(NKC0,Alpha)
			LH.C0 = LH.C0:lerp(LHC0,Alpha)
			RH.C0 = RH.C0:lerp(RHC0,Alpha)
			LS.C0 = LS.C0:lerp(LSC0*CF.N(0,0,0-.3*M.S(Sine/wsVal))*CF.A(M.R(0+45*M.S(Sine/wsVal)),0,M.R(-5)),Alpha)
			RS.C0 = clerp(RS.C0,CFrame.new(1.35597444, 0.402479589, 0.0100756176, 0.788939416, -0.614269078, 0.0156119671, 0.614255786, 0.78908211, 0.00628523249, -0.0161799639, 0.00463105366, 0.999856234),Alpha)
		elseif(State == 'Jump' or State == 'Fall')then
			if(Walking)then
				local Alpha = .1
				RJ.C0 = clerp(RJ.C0,RJC0*CF.A(math.min(math.max(Root.Velocity.Y/100,-M.R(65)),M.R(65)),0,0),Alpha)
				LH.C0 = clerp(LH.C0,CFrame.new(-0.497912645, -1.0987643, -0.0683324337, 0.999878228, 0.00860835519, 0.0130246133, -0.00010142161, 0.837816596, -0.545952022, -0.015611981, 0.545884132, 0.837715328),Alpha)
				RH.C0 = clerp(RH.C0,CFrame.new(0.499978393, -1.16382337, 0.109293163, 0.999878228, -0.0120433727, 0.00993486121, -0.00010142161, 0.631323814, 0.775519371, -0.015611981, -0.775425911, 0.631245613),Alpha)
				LS.C0 = clerp(LS.C0,CFrame.new(-1.55211556, 0.576563478, -0.00269976072, 0.976067662, 0.216906726, 0.0156116467, -0.217024669, 0.976145923, 0.00628317893, -0.0138763804, -0.00952091813, 0.999858499),Alpha)
				RS.C0 = clerp(RS.C0,CFrame.new(1.50182188, 0.636661649, 0.00632623257, 0.977592707, -0.209926367, 0.0156121543, 0.209851891, 0.977713108, 0.00628198683, -0.016582964, -0.00286500831, 0.999858439),Alpha)
				NK.C0 = clerp(NK.C0,CFrame.new(1.14440072e-05, 1.49924362, -0.0143961608, 1.00000024, -5.82076609e-11, 0, 1.23691279e-10, 0.997964919, 0.0637660474, 0, -0.0637660623, 0.997965038),Alpha)
			else
				local Alpha = .1
				RJ.C0 = clerp(RJ.C0,RJC0*CF.A(math.min(math.max(Root.Velocity.Y/100,-M.R(65)),M.R(65)),0,0),Alpha)
				LH.C0 = clerp(LH.C0,CFrame.new(-0.504374504, -0.291219354, -0.487436086, 0.999878228, -0.00438931212, 0.0149825988, -0.00010142161, 0.957819223, 0.287371844, -0.015611981, -0.287338346, 0.957701981),Alpha)
				RH.C0 = clerp(RH.C0,CFrame.new(0.453094482, -0.871358454, 0.0898642987, 0.985589385, -0.168456957, 0.0153662469, 0.162863791, 0.969548643, 0.182895929, -0.0457084104, -0.177757636, 0.983012319),Alpha)
				LS.C0 = clerp(LS.C0,CFrame.new(-1.55211556, 0.576563478, -0.00269976072, 0.976067662, 0.216906726, 0.0156116467, -0.217024669, 0.976145923, 0.00628317893, -0.0138763804, -0.00952091813, 0.999858499),Alpha)
				RS.C0 = clerp(RS.C0,CFrame.new(1.50182188, 0.636661649, 0.00632623257, 0.977592707, -0.209926367, 0.0156121543, 0.209851891, 0.977713108, 0.00628198683, -0.016582964, -0.00286500831, 0.999858439),Alpha)
				NK.C0 = clerp(NK.C0,CFrame.new(1.14440072e-05, 1.49924362, -0.0143961608, 1.00000024, -5.82076609e-11, 0, 1.23691279e-10, 0.997964919, 0.0637660474, 0, -0.0637660623, 0.997965038),Alpha)
			end
		elseif(State == 'Paralyzed')then
			-- paralyzed
		elseif(State == 'Sit')then
			-- sit
		end
	end
endeak;end while 1540==(a)/((0x8c8d4/190))do a=(2435760)while(0x115+-123)<C do a-= a local n;local r;local a;a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[s]];e=e+l;_=o[e];d[_[x]][_[i]]=_[f];e=e+l;_=o[e];d[_[w]][_[O]]=d[_[u]];e=e+l;_=o[e];a=_[w]d[a](d[a+v])e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[D];r=d[a]n=d[a+2];if(n>0)then if(r>d[a+1])then e=_[U];else d[a+3]=r;end elseif(r<d[a+1])then e=_[b];else d[a+3]=r;end break end while 816==(a)/((0x1792-3049))do local a;d[_[n]][_[k]]=d[_[u]];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[r]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[h]][_[O]]=_[u];e=e+l;_=o[e];d[_[w]][_[i]]=d[_[S]];e=e+l;_=o[e];a=_[D]d[a](d[a+v])break end;break;end break;end while(a)/((4978-0x9f8))==1284 do a=(928774)while(241+-0x55)>=C do a-= a local a;d[_[w]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];a=_[D]d[a]=d[a](d[a+v])break;end while(a)/((0x147+-68))==3586 do a=(580355)while(0x18a-237)<C do a-= a local a;d[_[w]]=_[U];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];break end while(a)/((0x356+-109))==779 do local C;local j,L;local a;d[_[x]]={};e=e+l;_=o[e];d[_[h]][_[k]]=_[S];e=e+l;_=o[e];d[_[D]][_[c]]=_[B];e=e+l;_=o[e];d[_[h]]=P[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=P[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[x]]=P[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[D]]=d[_[U]];e=e+l;_=o[e];a=_[x]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[r]]=P[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[r]]=P[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]]=P[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]]=P[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];a=_[D]j,L=m(d[a](N(d,a+1,_[c])))g=L+a-1 C=0;for _=a,g do C=C+l;d[_]=j[C];end;e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,g))e=e+l;_=o[e];d[_[h]]=d[_[b]]*d[_[B]];e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[x]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[r]]=d[_[O]]*d[_[S]];e=e+l;_=o[e];d[_[w]]=d[_[c]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[i]]=d[_[f]];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[D]][_[c]]=d[_[f]];e=e+l;_=o[e];d[_[w]][_[O]]=d[_[s]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[D]][_[b]]=d[_[s]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[n]]=P[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]][_[O]]=d[_[S]];e=e+l;_=o[e];d[_[D]][_[i]]=_[t];e=e+l;_=o[e];d[_[n]][_[O]]=d[_[t]];e=e+l;_=o[e];a=_[D]d[a](d[a+v])break end;break;end break;end break;end while(a)/((0x8a3+-113))==367 do a=(7303872)while C<=(341-0xb4)do a-= a a=(4065334)while C<=((0x1004f-32861)/0xce)do a-= a local a;d[_[n]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[s]];e=e+l;_=o[e];a=_[w]d[a]=d[a](d[a+v])e=e+l;_=o[e];e=_[k];break;end while(a)/(((-101+0x1b655)/0x58))==3191 do a=(5641944)while C>(0x18b-235)do a-= a local o=_[h]local a={d[o](N(d,o+1,g))};local e=0;for _=o,_[B]do e=e+l;d[_]=a[e];end break end while(a)/((0x2f908/98))==2838 do local a;d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[w]][_[k]]=d[_[S]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[k]]=d[_[x]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];a=_[x]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[x]][_[i]]=d[_[f]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[w]][_[c]]=d[_[s]];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[x]]=(_[O]~=0);e=e+l;_=o[e];d[_[r]][_[U]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[h]][_[c]]=d[_[f]];break end;break;end break;end while(a)/(((0x1b95+-65)-3508))==2094 do a=(6219282)while C<=(407-0xf5)do a-= a local a;d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[r]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=P[_[b]];e=e+l;_=o[e];d[_[D]]=P[_[U]];e=e+l;_=o[e];d[_[x]]=(_[O]~=0);e=e+l;_=o[e];d[_[D]]=(_[b]~=0);e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];P[_[i]]=d[_[x]];e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[x]]=P[_[O]];e=e+l;_=o[e];d[_[n]][_[i]]=d[_[s]];break;end while(a)/((2752+-0x37))==2306 do a=(5325361)while C>(-0x4f+242)do a-= a P[_[c]]=d[_[h]];break end while(a)/(((0xad9-1422)+-0x34))==4087 do local a;d[_[h]][_[U]]=d[_[t]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[i]]=d[_[x]];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[h]][_[c]]=d[_[f]];break end;break;end break;end break;end break;end break;end while(a)/((0x1c71-3681))==793 do a=(755904)while(37136/(-0x3d+272))>=C do a-= a a=(5775753)while C<=(0x1b8-270)do a-= a a=(5496477)while(408-0xf1)>=C do a-= a a=(165186)while((-21+0xd3)+-0x19)>=C do a-= a local a;d[_[w]]=_[i];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[k];break;end while 966==(a)/((-48+0xdb))do a=(497874)while C>(0x173-205)do a-= a local e=_[D]local a={d[e](N(d,e+1,g))};local o=0;for _=e,_[S]do o=o+l;d[_]=a[o];end break end while 982==(a)/(((2289-0x490)-0x266))do local a;d[_[n]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[h]]=d[_[i]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[D]]=P[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[D]]=d[_[U]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[b]]=_[S];break end;break;end break;end while(a)/((-0x17+1906))==2919 do a=(5261096)while(33936/0xca)>=C do a-= a local a;d[_[D]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[n]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[B]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[u]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=(_[b]~=0);e=e+l;_=o[e];d[_[n]][_[O]]=d[_[t]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[U]]=d[_[D]];e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[u]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];M[_[b]]=d[_[h]];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[n]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[w]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];break;end while(a)/((0x1168-2238))==2372 do a=(2119788)while(1690/0xa)<C do a-= a local _=_[D]d[_]=d[_]()break end while(a)/((188163/0xcf))==2332 do local a;d[_[D]]=d[_[k]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[h]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[w]]=d[_[b]];e=e+l;_=o[e];a=_[x]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]]=P[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[t]];break end;break;end break;end break;end while 2033==(a)/((5776-0xb77))do a=(6439776)while((922-0x1ff)-238)>=C do a-= a a=(414778)while(0x1560/32)>=C do a-= a local _=_[x]d[_]=d[_](d[_+v])break;end while 3913==(a)/((-0x61+203))do a=(2321487)while(0x19e-242)<C do a-= a local a;d[_[w]]=_[c];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=(_[c]~=0);e=e+l;_=o[e];d[_[D]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[w]][_[U]]=d[_[S]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[c]]=d[_[w]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[w]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[B]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[k]]=d[_[h]];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[h]][_[k]]=d[_[B]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[w]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[b]]=d[_[B]];break end while(a)/((0xbb7-1508))==1557 do local _={_,d};_[j][_[v][h]]=_[j][_[l][O]]+_[v][S];break end;break;end break;end while(a)/((-70+0xaf8))==2352 do a=(7771160)while C<=(-106+0x118)do a-= a local U;local a;d[_[w]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=d[_[O]];e=e+l;_=o[e];a=_[h]d[a](d[a+v])e=e+l;_=o[e];d[_[w]]=P[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[S]];e=e+l;_=o[e];a=_[w];U=d[_[k]];d[a+1]=U;d[a]=U[_[u]];e=e+l;_=o[e];d[_[r]]=d[_[O]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];if not d[_[n]]then e=e+v;else e=_[b];end;break;end while 3460==(a)/((0x11f2-2348))do a=(4491200)while C>(260+-0x55)do a-= a d[_[n]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[r]]=P[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[c]]-d[_[S]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[s]];e=e+l;_=o[e];d[_[x]]=P[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[O]]/d[_[t]];break end while(a)/((0xcee-1710))==2807 do local a;d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[x]]=P[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[w]]=d[_[k]]/_[f];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[n]]=(_[O]~=0);e=e+l;_=o[e];d[_[D]]=(_[k]~=0);e=e+l;_=o[e];d[_[r]]=(_[U]~=0);e=e+l;_=o[e];a=_[n]d[a](N(d,a+v,_[k]))e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[r]]=(_[i]~=0);e=e+l;_=o[e];d[_[n]]=(_[O]~=0);e=e+l;_=o[e];d[_[n]]=(_[c]~=0);e=e+l;_=o[e];a=_[w]d[a](N(d,a+v,_[i]))e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[n]]=(_[k]~=0);e=e+l;_=o[e];d[_[h]]=(_[i]~=0);e=e+l;_=o[e];d[_[w]]=(_[i]~=0);e=e+l;_=o[e];a=_[x]d[a](N(d,a+v,_[O]))e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[B]];break end;break;end break;end break;end break;end while 3937==(a)/((3840/0x14))do a=(45594)while(0x5bb6/129)>=C do a-= a a=(2554845)while(0x181-206)>=C do a-= a a=(7241442)while(0x123+(-0x56d6/195))>=C do a-= a local a;d[_[h]][_[O]]=d[_[f]];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[x]][_[O]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=(_[k]~=0);e=e+l;_=o[e];d[_[r]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[n]][_[c]]=d[_[f]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[t]];e=e+l;_=o[e];d[_[n]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[x]][_[O]]=d[_[u]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[c]]=d[_[r]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[i]]=d[_[f]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[S]];e=e+l;_=o[e];d[_[w]][_[k]]=d[_[S]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[U]]=d[_[h]];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[w]][_[U]]=d[_[u]];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[r]][_[b]]=d[_[S]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[c];break;end while(a)/((0x230ee/42))==2118 do a=(911543)while(0x181-207)<C do a-= a local e=_[h];local l=d[e];for _=e+1,_[k]do p(l,d[_])end;break end while(a)/((505697/0x9d))==283 do local r;local a;d[_[x]]=d[_[k]][_[t]];e=e+l;_=o[e];a=_[D];r=d[_[U]];d[a+1]=r;d[a]=r[_[f]];e=e+l;_=o[e];a=_[n]d[a](d[a+v])e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];a=_[n]d[a]=d[a]()e=e+l;_=o[e];P[_[c]]=d[_[h]];e=e+l;_=o[e];e=_[i];break end;break;end break;end while(a)/((-0x76+763))==3961 do a=(7138124)while C<=(0x4f74/(0x119-168))do a-= a local _=_[h];do return N(d,_,g)end;break;end while(a)/((3751-0x773))==3871 do a=(4407682)while(0x184-207)<C do a-= a local a;d[_[w]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[r]]=d[_[k]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[c]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]]=d[_[k]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[x]]=P[_[i]];e=e+l;_=o[e];d[_[w]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=P[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[w]]=d[_[O]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[n]][_[k]]=d[_[B]];e=e+l;_=o[e];d[_[n]]=P[_[b]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[h]]=P[_[k]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]]=d[_[U]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[u]];break end while(a)/((3985+-0x27))==1117 do local r;local D,C;local i;local a;a=_[n];i=d[_[U]];d[a+1]=i;d[a]=i[_[f]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];a=_[n]D,C=m(d[a](N(d,a+1,_[k])))g=C+a-1 r=0;for _=a,g do r=r+l;d[_]=D[r];end;e=e+l;_=o[e];a=_[n]d[a](N(d,a+v,g))e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=d[_[O]];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[h]][_[U]]=d[_[B]];e=e+l;_=o[e];d[_[h]][_[k]]=d[_[S]];break end;break;end break;end break;end while 149==(a)/((33966/0x6f))do a=(7333745)while C<=(406-0xdd)do a-= a a=(4359040)while(392-0xd1)>=C do a-= a local a;d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))break;end while 1390==(a)/(((0x3191-6385)-0xc60))do a=(460630)while C>(1656/(-122+0x83))do a-= a local a;d[_[h]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[n]]=M[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];a=_[x]d[a]=d[a]()e=e+l;_=o[e];d[_[n]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[n]]=d[_[i]]-d[_[f]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[n]]=d[_[c]]/d[_[u]];e=e+l;_=o[e];if not d[_[n]]then e=e+v;else e=_[c];end;break end while(a)/((21535/0x3b))==1262 do d[_[D]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[t]];e=e+l;_=o[e];d[_[D]]=P[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[B]];break end;break;end break;end while 2267==(a)/((0xd1c+-121))do a=(2617472)while C<=(0x18e-212)do a-= a local r;local b,x;local a;a=_[n]b,x=m(d[a](d[a+v]))g=x+a-l r=0;for _=a,g do r=r+l;d[_]=b[r];end;e=e+l;_=o[e];a=_[h]d[a](N(d,a+v,g))e=e+l;_=o[e];d[_[D]]=d[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[c]];e=e+l;_=o[e];a=_[n];do return N(d,a,a+_[i])end;e=e+l;_=o[e];do return end;break;end while 1936==(a)/((1408+(-102+0x2e)))do a=(36576)while C>(42823/0xe5)do a-= a local a;a=_[D]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[c]]=d[_[n]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[x]][_[c]]=d[_[f]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[n]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[D]][_[i]]=d[_[f]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]][_[U]]=d[_[u]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[k]]=d[_[r]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[r]][_[O]]=d[_[f]];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[n]]=M[_[c]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[D]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[r]][_[O]]=_[S];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[O]]=d[_[n]];break end while(a)/((0x14e-190))==254 do d[_[n]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[D]]=P[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[k]]*d[_[S]];e=e+l;_=o[e];d[_[x]]=P[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[h]]=d[_[b]]/d[_[f]];e=e+l;_=o[e];P[_[b]]=d[_[r]];break end;break;end break;end break;end break;end break;end break;end break;end break;end while(a)/((7238-0xe5f))==2307 do a=(623011)while C<=((0x10ca0/112)-0x14c)do a-= a a=(8856250)while(546-0x137)>=C do a-= a a=(4657975)while(49796/(0x211-293))>=C do a-= a a=(425868)while C<=((0x465-604)-322)do a-= a a=(1923290)while C<=(0x28b6/(122+-0x44))do a-= a a=(4110456)while(209+-0x13)>=C do a-= a a=(3846855)while(0x71b2/154)<C do a-= a local a;a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[b]]=d[_[h]];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[f]];break end while 1011==(a)/((0xdc299/237))do local l=_[i];local e=d[l]for _=l+1,_[t]do e=e..d[_];end;d[_[D]]=e;break end;break;end while(a)/((80798/0x47))==3612 do a=(2493826)while(420-0xe5)>=C do a-= a local a;d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[n]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[n]]=d[_[U]]/_[t];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[D]]=(_[b]~=0);e=e+l;_=o[e];d[_[w]]=(_[i]~=0);e=e+l;_=o[e];d[_[x]]=(_[U]~=0);e=e+l;_=o[e];a=_[D]d[a](N(d,a+v,_[U]))e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[h]][_[c]]=_[f];e=e+l;_=o[e];d[_[w]][_[O]]=_[u];e=e+l;_=o[e];d[_[x]]=P[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[D]][_[c]]=d[_[t]];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[r]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[h]][_[O]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=M[_[c]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];a=_[w]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[w]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[w]]=P[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[r]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[r]][_[b]]=_[B];e=e+l;_=o[e];d[_[x]][_[U]]=d[_[f]];e=e+l;_=o[e];a=_[D]d[a](d[a+v])e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[r]][_[O]]=_[S];e=e+l;_=o[e];d[_[n]][_[b]]=_[t];e=e+l;_=o[e];d[_[r]]=P[_[k]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[r]][_[b]]=d[_[f]];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[n]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[x]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];a=_[n]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[h]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[h]]=P[_[k]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];break;end while(a)/((1472+-0x55))==1798 do a=(6627180)while((17753/0x29)-0xf1)<C do a-= a local a;d[_[r]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))break end while 3054==(a)/((496930/0xe5))do d[_[x]]=-d[_[i]];break end;break;end break;end break;end while 890==(a)/((-0x55+2246))do a=(5829372)while C<=(0x31c4/65)do a-= a a=(4123592)while C<=(0x42b0/88)do a-= a P[_[k]]=d[_[D]];e=e+l;_=o[e];d[_[n]]=(_[b]~=0);e=e+l;_=o[e];P[_[k]]=d[_[n]];e=e+l;_=o[e];d[_[h]]=P[_[U]];e=e+l;_=o[e];d[_[h]][_[U]]=_[u];e=e+l;_=o[e];do return end;break;end while 1994==(a)/((436348/0xd3))do a=(1593256)while(0x124+-97)<C do a-= a P[_[O]]=d[_[D]];break end while 1288==(a)/((2563-0x52e))do local a;d[_[h]]=_[k];e=e+l;_=o[e];d[_[h]]=-d[_[i]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]]=d[_[U]]*d[_[s]];e=e+l;_=o[e];d[_[x]][_[U]]=d[_[f]];e=e+l;_=o[e];d[_[D]]=P[_[c]];e=e+l;_=o[e];d[_[x]][_[U]]=d[_[S]];break end;break;end break;end while(a)/((326556/0xbc))==3356 do a=(8483880)while C<=((0x13671/177)-252)do a-= a local i;local a;a=_[n]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[h]]=d[_[b]]*d[_[B]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];i={d,_};i[v][i[j][r]]=i[l][i[j][s]]+i[v][i[j][b]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[x]]=d[_[k]]*d[_[S]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[B]];break;end while(a)/(((0x2460bf0/136)/0x79))==3660 do a=(2758632)while C>(-86+0x11c)do a-= a d[_[n]]=(_[c]~=0);e=e+l;_=o[e];P[_[k]]=d[_[n]];e=e+l;_=o[e];d[_[h]]=(_[i]~=0);e=e+l;_=o[e];P[_[U]]=d[_[r]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];if(d[_[x]]==_[B])then e=e+v;else e=_[k];end;break end while(a)/((6606-0xcf6))==839 do if(d[_[r]]<=d[_[u]])then e=_[k];else e=e+v;end;break end;break;end break;end break;end break;end while(a)/((59892/0xd9))==1543 do a=(16018600)while C<=((995-0x1fd)-0x119)do a-= a a=(9061402)while(-0x27+(0x23c-331))>=C do a-= a a=(6521941)while C<=(510-0x136)do a-= a local a;d[_[w]]=_[U];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[r]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[b]]=d[_[t]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[b]]=d[_[x]];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[t]];e=e+l;_=o[e];d[_[x]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[r]][_[O]]=d[_[s]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[r]][_[c]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=(_[k]~=0);e=e+l;_=o[e];d[_[n]][_[c]]=d[_[f]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[U]]=d[_[n]];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[c]]=d[_[f]];break;end while 2633==(a)/((0x955eb/247))do a=(1137708)while(-19+0xdc)<C do a-= a local a;d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[f]];e=e+l;_=o[e];a=_[n]d[a](d[a+v])e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[n]]();e=e+l;_=o[e];d[_[w]]=P[_[O]];e=e+l;_=o[e];d[_[x]][_[c]]=_[f];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=P[_[c]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[w]]=d[_[b]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]][_[b]]=d[_[S]];e=e+l;_=o[e];d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=P[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]]=d[_[O]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[w]][_[c]]=d[_[t]];e=e+l;_=o[e];d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]]=d[_[U]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[w]][_[O]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[n]]=M[_[i]];break end while(a)/((506+-0x26))==2431 do local a;d[_[r]]=_[i];e=e+l;_=o[e];a=_[D]d[a](N(d,a+v,_[i]))e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=P[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[t]];e=e+l;_=o[e];if d[_[n]]then e=e+l;else e=_[b];end;break end;break;end break;end while(a)/((0x1ba36/46))==3682 do a=(1887880)while(23548/0x74)>=C do a-= a local a;d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[w]]=(_[b]~=0);e=e+l;_=o[e];d[_[w]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[x]][_[k]]=d[_[B]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[i]]=d[_[n]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[n]][_[O]]=d[_[t]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];M[_[b]]=d[_[w]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[h]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[h]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[D]][_[c]]=d[_[u]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[c]]=d[_[x]];e=e+l;_=o[e];d[_[w]]=M[_[i]];break;end while(a)/((0x1178-2292))==866 do a=(7164255)while(3876/0x13)<C do a-= a local a;d[_[r]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))break end while(a)/((0xcdc+-37))==2201 do d[_[h]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[r]]=(_[k]~=0);e=e+l;_=o[e];d[_[x]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[x]][_[O]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[f]];break end;break;end break;end break;end while(a)/((-94+0xfdb))==4040 do a=(9681075)while(505-0x129)>=C do a-= a a=(3629600)while C<=(0x9a80/192)do a-= a local e=_[r];do return N(d,e,e+_[i])end;break;end while(a)/((-39+0x59b))==2600 do a=(13628375)while(-0x6e+317)<C do a-= a d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[U];break end while(a)/(((8072-0xffe)+-103))==3517 do local a;d[_[D]]=P[_[b]];e=e+l;_=o[e];a={d,_};a[v][a[j][r]]=a[l][a[j][f]]+a[v][a[j][O]];e=e+l;_=o[e];P[_[i]]=d[_[h]];e=e+l;_=o[e];d[_[x]]=P[_[O]];e=e+l;_=o[e];d[_[r]]=P[_[k]];e=e+l;_=o[e];if(d[_[x]]<=d[_[s]])then e=_[b];else e=e+v;end;break end;break;end break;end while(a)/((0x141b-(0x53aa8/131)))==3825 do a=(4334022)while(-0x19+234)>=C do a-= a local e=_[x];do return N(d,e,e+_[O])end;break;end while 1947==(a)/((0x11a3-2289))do a=(4581482)while C>(0x747c/142)do a-= a local l=_[n];local a=d[l+2];local o=d[l]+a;d[l]=o;if(a>0)then if(o<=d[l+1])then e=_[U];d[l+3]=o;end elseif(o>=d[l+1])then e=_[b];d[l+3]=o;end break end while(a)/((0x925-1212))==4058 do d[_[w]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[n]]=_[U];break end;break;end break;end break;end break;end break;end while(a)/((0x63c+-91))==3095 do a=(3465936)while C<=((671-0x17e)+-0x42)do a-= a a=(13541388)while(0x22c1/41)>=C do a-= a a=(9373490)while C<=(-101+0x13b)do a-= a a=(10256792)while C<=(264+-0x34)do a-= a local a;d[_[n]]=P[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[b]]=d[_[f]];e=e+l;_=o[e];d[_[n]][_[i]]=_[B];e=e+l;_=o[e];d[_[n]][_[b]]=d[_[u]];e=e+l;_=o[e];a=_[D]d[a](d[a+v])break;end while(a)/(((-0x6d+16)+0xa2a))==4088 do a=(8557074)while C>(0x1cd-248)do a-= a local l=d[_[B]];if l then e=e+v;else d[_[D]]=l;e=_[b];end;break end while 2586==(a)/((6635-0xcfe))do local a;d[_[h]]=P[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[S]];e=e+l;_=o[e];a=_[w]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[h]]=d[_[i]]*d[_[u]];e=e+l;_=o[e];d[_[D]]=P[_[k]];break end;break;end break;end while(a)/((0x148b-2648))==3590 do a=(5346489)while C<=(0xfb+-36)do a-= a e=_[k];break;end while 3327==(a)/((-110+0x6b5))do a=(4038784)while C>(22464/0x68)do a-= a d[_[w]]=P[_[U]];break end while(a)/((0x770+-88))==2224 do local a;d[_[n]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[c]]=d[_[u]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=d[_[k]];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[n]][_[O]]=d[_[B]];e=e+l;_=o[e];d[_[x]][_[U]]=d[_[s]];break end;break;end break;end break;end while(a)/((0xdb5+-86))==3956 do a=(648960)while(-0x4d+297)>=C do a-= a a=(10522200)while(303+-0x55)>=C do a-= a local n;local w;local b;local a;d[_[r]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[f]];e=e+l;_=o[e];a=_[h];b=d[_[U]];d[a+1]=b;d[a]=b[_[s]];e=e+l;_=o[e];a=_[r]w={d[a](d[a+1])};n=0;for _=a,_[f]do n=n+l;d[_]=w[n];end e=e+l;_=o[e];e=_[O];break;end while(a)/((0xab2+-40))==3900 do a=(9634995)while C>(0xb9a3/(0xb3b4/212))do a-= a local a;a=_[r]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[w]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[D]]=P[_[k]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[n]]=P[_[c]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[n]]=_[k];break end while(a)/((-0x53+2738))==3629 do M[_[k]]=d[_[r]];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];M[_[i]]=d[_[w]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];if(d[_[x]]==_[u])then e=e+v;else e=_[c];end;break end;break;end break;end while(a)/((0x248-324))==2496 do a=(11804880)while C<=(304+-0x53)do a-= a local a;d[_[r]]();e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=P[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[S]];e=e+l;_=o[e];a=_[D]d[a](d[a+v])e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]=P[_[U]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=P[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[t]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]]=d[_[c]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[r]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[h]]=P[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]]=d[_[O]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[n]][_[U]]=d[_[u]];e=e+l;_=o[e];d[_[n]]=P[_[k]];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[x]]=d[_[O]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[n]][_[b]]=d[_[f]];e=e+l;_=o[e];d[_[D]]=P[_[c]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=P[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[D]]=_[c];break;end while(a)/((0x1eb6-3966))==3030 do a=(1503600)while(0xc4da/227)<C do a-= a d[_[n]]=_[b];break end while(a)/((7614-0xf0f))==400 do if(d[_[w]]<d[_[B]])then e=e+v;else e=_[c];end;break end;break;end break;end break;end break;end while 904==(a)/((0xf4d+-83))do a=(6423600)while(-0x5b+(-24+0x158))>=C do a-= a a=(607372)while(-0x1a+(0x250-340))>=C do a-= a a=(6103326)while(480-0x100)>=C do a-= a local o=_[h]local a={d[o](d[o+1])};local e=0;for _=o,_[s]do e=e+l;d[_]=a[e];end break;end while(a)/((0x1153-2273))==2823 do a=(2910372)while(0xdbba/250)<C do a-= a local e=_[D];local l=d[_[c]];d[e+1]=l;d[e]=l[_[s]];break end while 3396==(a)/((0x33adf/247))do d[_[h]]();break end;break;end break;end while(a)/((0x2a4-359))==1916 do a=(8343608)while(528-0x12d)>=C do a-= a local a;d[_[r]]=_[O];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[k]))break;end while(a)/(((607486-0x4a2be)/80))==2198 do a=(4634058)while(55860/0xf5)<C do a-= a d[_[x]][_[O]]=d[_[B]];e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[x]][_[O]]=d[_[s]];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[t]];break end while(a)/((0xc5a-1589))==2946 do local a;a=_[D]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];M[_[k]]=d[_[n]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[B]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[x]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[h]][_[c]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[D]][_[b]]=d[_[S]];e=e+l;_=o[e];d[_[n]]=(_[b]~=0);e=e+l;_=o[e];d[_[h]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[r]][_[c]]=d[_[s]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[i]]=d[_[h]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]][_[b]]=d[_[f]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[k]]=d[_[x]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[h]][_[U]]=d[_[u]];e=e+l;_=o[e];d[_[D]]=M[_[c]];e=e+l;_=o[e];d[_[n]][_[i]]=d[_[f]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[s]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[i];break end;break;end break;end break;end while 2120==(a)/((6126-0xc18))do a=(4496814)while(54984/0xed)>=C do a-= a a=(1729485)while C<=(-0x48+302)do a-= a local a;d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[D]][_[b]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[n]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[x]][_[k]]=d[_[B]];e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[D]][_[O]]=d[_[S]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];M[_[k]]=d[_[D]];e=e+l;_=o[e];d[_[w]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[S]];e=e+l;_=o[e];d[_[r]][_[O]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[D]][_[U]]=d[_[B]];e=e+l;_=o[e];d[_[r]]=(_[U]~=0);e=e+l;_=o[e];d[_[n]][_[U]]=d[_[u]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[U]]=d[_[D]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[n]]=M[_[c]];break;end while(a)/((0x2b3e6/106))==1035 do a=(1068600)while C>(0x9798/168)do a-= a d[_[w]]=d[_[k]]%_[B];break end while(a)/((168510/0x52))==520 do if(_[w]<d[_[B]])then e=e+v;else e=_[U];end;break end;break;end break;end while 1869==(a)/((55338/(0x7d-102)))do a=(11631400)while C<=(0x29de/46)do a-= a local a;d[_[n]]=_[i];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[b]]=d[_[S]];break;end while 3740==(a)/((-40+0xc4e))do a=(487168)while(507-0x111)<C do a-= a local x;local b;local N;local a;a={d,_};a[v][a[j][w]]=a[l][a[j][u]]+a[v][a[j][k]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[w]]=d[_[i]];e=e+l;_=o[e];N=_[U];b=d[N]for _=N+1,_[S]do b=b..d[_];end;d[_[w]]=b;e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[t]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];x=_[D]d[x]=d[x](d[x+v])e=e+l;_=o[e];d[_[n]]=d[_[O]][_[f]];break end while(a)/((0x1e2b-3917))==128 do local e=_[x];do return d[e](N(d,e+1,_[U]))end;break end;break;end break;end break;end break;end break;end break;end while(a)/((-92+0xc91))==2834 do a=(838890)while(17544/0x44)>=C do a-= a a=(404060)while(57810/(-0x1b+262))>=C do a-= a a=(5129400)while C<=(31200/(174+-0x2c))do a-= a a=(5489913)while C<=(338+-0x65)do a-= a a=(4804965)while C>(5664/0x18)do a-= a local a;d[_[n]]=P[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[u]];e=e+l;_=o[e];a=_[n]d[a](d[a+v])e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[r]]();e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=P[_[b]];e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=P[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]]=d[_[k]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=P[_[U]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=P[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[w]]=d[_[b]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=P[_[k]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]]=d[_[O]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[x]]=P[_[c]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=P[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[n]]=_[i];break end while 1683==(a)/((0x1694-2925))do d[_[D]][d[_[k]]]=_[S];break end;break;end while 2101==(a)/((0x557be/134))do a=(10116160)while C<=(0x215-295)do a-= a local a;d[_[n]]=P[_[k]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[x]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[D]][_[O]]=d[_[u]];e=e+l;_=o[e];d[_[n]]=P[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[t]];e=e+l;_=o[e];d[_[w]][_[c]]=_[S];e=e+l;_=o[e];do return end;break;end while 2504==(a)/((0x8a160/140))do a=(7679760)while(45410/0xbe)<C do a-= a d[_[w]]=d[_[b]]/_[u];break end while 2640==(a)/((5922-0xbc5))do d[_[r]]=d[_[k]]%_[t];break end;break;end break;end break;end while(a)/((3182-0x665))==3320 do a=(68628)while C<=(512-(0x22f-290))do a-= a a=(4131054)while(0x256-357)>=C do a-= a local a;d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=d[_[i]][d[_[B]]];e=e+l;_=o[e];d[_[n]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[r]][_[b]]=d[_[f]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[r]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=(_[O]~=0);e=e+l;_=o[e];d[_[n]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[k]]=d[_[B]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[c]]=d[_[x]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[f]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[U]]=d[_[h]];e=e+l;_=o[e];d[_[n]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[h]][_[U]]=d[_[u]];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[h]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[U];break;end while 2034==(a)/((0x60b0d/195))do a=(6236100)while(-104+0x15a)<C do a-= a local h;local a;local w;local i;d[_[x]]=(_[O]~=0);e=e+l;_=o[e];i=_[r]w={d[i](N(d,i+1,_[k]))};a=0;for _=i,_[t]do a=a+l;d[_]=w[a];end e=e+l;_=o[e];d[_[r]]=d[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[b]];e=e+l;_=o[e];h=d[_[B]];if h then e=e+v;else d[_[D]]=h;e=_[O];end;break end while(a)/((-84+0x856))==3042 do local a;d[_[r]]=_[b];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[r]]=d[_[O]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[w]]=P[_[k]];e=e+l;_=o[e];d[_[w]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[x]]=d[_[c]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[n]][_[O]]=d[_[S]];e=e+l;_=o[e];d[_[w]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=P[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[B]];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[w]]=d[_[O]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[r]]=P[_[c]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=P[_[k]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[r]]=d[_[c]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[k]]=d[_[B]];break end;break;end break;end while(a)/((438+-0x27))==172 do a=(13242734)while((-216/0x9)+268)>=C do a-= a if(_[n]<d[_[S]])then e=_[i];else e=e+v;end;break;end while 3743==(a)/((0x1bd6-3588))do a=(8411025)while C>(-118+0x16b)do a-= a local a;d[_[D]]=P[_[c]];e=e+l;_=o[e];d[_[n]]=P[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[h]]=P[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[n]]=(_[i]~=0);e=e+l;_=o[e];d[_[x]]=(_[k]~=0);e=e+l;_=o[e];d[_[x]]=(_[O]~=0);e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];P[_[O]]=d[_[D]];break end while 2165==(a)/((0x1ec0-(0x1f75-4066)))do d[_[D]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[w]]=d[_[i]]-d[_[B]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[f]];e=e+l;_=o[e];if(d[_[h]]<d[_[u]])then e=_[b];else e=e+v;end;break end;break;end break;end break;end break;end while 445==(a)/((0xd144/59))do a=(8806716)while C<=(569-0x13d)do a-= a a=(1327238)while(596-0x15b)>=C do a-= a a=(3323788)while C<=(0x219-290)do a-= a local C;local a;d[_[n]]=d[_[b]][d[_[f]]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[w]]=d[_[i]]/d[_[f]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[h]]=d[_[c]]/d[_[S]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[h]]=d[_[U]][d[_[t]]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[r]]=d[_[O]][d[_[B]]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[x]]=d[_[U]]/d[_[S]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=d[_[b]]*d[_[s]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[x]]=d[_[c]][_[S]];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[r];C=d[_[b]];d[a+1]=C;d[a]=C[d[_[s]]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[s]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[h]]=d[_[U]]/d[_[B]];e=e+l;_=o[e];d[_[n]]=d[_[U]]/d[_[s]];e=e+l;_=o[e];a=_[n]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=d[_[b]]*d[_[t]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[h]]=d[_[O]]-d[_[B]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[D]]=d[_[c]]*d[_[s]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[n]]=d[_[i]]/d[_[B]];e=e+l;_=o[e];a=_[h]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=d[_[U]]*d[_[s]];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[D]]=d[_[U]]/d[_[f]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[x]]=d[_[O]]-d[_[B]];e=e+l;_=o[e];a=_[w]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]]=d[_[c]]*d[_[S]];e=e+l;_=o[e];d[_[w]]=d[_[U]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[h]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[w];C=d[_[k]];d[a+1]=C;d[a]=C[d[_[B]]];e=e+l;_=o[e];d[_[D]]=d[_[c]];e=e+l;_=o[e];d[_[h]]=d[_[U]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];a=_[x];C=d[_[U]];d[a+1]=C;d[a]=C[d[_[s]]];e=e+l;_=o[e];d[_[r]]=d[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[k]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[k]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];a=_[r];C=d[_[U]];d[a+1]=C;d[a]=C[d[_[B]]];e=e+l;_=o[e];d[_[h]]=d[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[U]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[w]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];a=_[r];C=d[_[k]];d[a+1]=C;d[a]=C[d[_[t]]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[B]];break;end while 2132==(a)/((3205-0x66e))do a=(8894176)while C>(600-0x160)do a-= a local a;d[_[D]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))break end while(a)/((4482-0x8ce))==3992 do if(d[_[w]]~=_[t])then e=e+v;else e=_[c];end;break end;break;end break;end while(a)/((101222/0x6b))==1403 do a=(3571524)while(0x205-267)>=C do a-= a local a;d[_[x]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[w]]=d[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[c]];e=e+l;_=o[e];d[_[n]]=d[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[U]];e=e+l;_=o[e];a=_[h]d[a](N(d,a+v,_[U]))break;end while(a)/((0x25d9a/162))==3732 do a=(1174887)while(-110+0x169)<C do a-= a local a;d[_[n]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[D]]=d[_[U]]*d[_[u]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[t]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[D]]=d[_[k]][_[B]];break end while(a)/((0x1a14-3385))==357 do local a;d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))break end;break;end break;end break;end while(a)/(((545501/0x65)-0xaa5))==3291 do a=(2091979)while(303+-0x30)>=C do a-= a a=(6102117)while(0x221-292)>=C do a-= a d[_[w]][_[c]]=_[u];e=e+l;_=o[e];d[_[D]]=(_[U]~=0);e=e+l;_=o[e];P[_[U]]=d[_[x]];e=e+l;_=o[e];d[_[x]]=(_[b]~=0);e=e+l;_=o[e];P[_[c]]=d[_[h]];e=e+l;_=o[e];do return end;break;end while 2121==(a)/((0x82a52/186))do a=(2144890)while C>(0x5f4/6)do a-= a local a;d[_[D]]=_[c];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[h]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[B]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];break end while(a)/((0x64bd/(0x8a-97)))==3410 do local C;local N;local a;d[_[w]]=(_[U]~=0);e=e+l;_=o[e];P[_[b]]=d[_[D]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];a=_[D]d[a](d[a+v])e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];a=_[n]d[a](d[a+v])e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[h]d[a](d[a+v])e=e+l;_=o[e];d[_[D]]=(_[c]~=0);e=e+l;_=o[e];P[_[O]]=d[_[x]];e=e+l;_=o[e];d[_[n]]=P[_[O]];e=e+l;_=o[e];d[_[x]][_[b]]=_[t];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];a=_[r];N=d[a]C=d[a+2];if(C>0)then if(N>d[a+1])then e=_[c];else d[a+3]=N;end elseif(N<d[a+1])then e=_[O];else d[a+3]=N;end break end;break;end break;end while 1907==(a)/((0xa71f/39))do a=(3416829)while C<=(-0x1c+284)do a-= a local e=_[w];do return d[e](N(d,e+1,_[U]))end;break;end while(a)/((2238-0x469))==3081 do a=(8944)while C>(0xf0f/15)do a-= a d[_[w]]=d[_[i]]*d[_[S]];break end while 344==(a)/((3276/0x7e))do local a;d[_[w]]();e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=P[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[s]];e=e+l;_=o[e];a=_[w]d[a](d[a+v])e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=P[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[h]]=d[_[b]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[n]]=P[_[c]];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[x]]=d[_[k]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[x]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=P[_[c]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[D]]=d[_[U]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[b]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=P[_[c]];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=P[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[D]]=_[O];break end;break;end break;end break;end break;end break;end while(a)/((2377-0x4b7))==717 do a=(1423356)while(62100/0xe6)>=C do a-= a a=(5500508)while(649-0x181)>=C do a-= a a=(1995918)while C<=(591-0x14a)do a-= a a=(616930)while C<=(0x6326/98)do a-= a local a;d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[D]]=d[_[i]]*d[_[u]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[h]][_[c]]=d[_[s]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[n]]=d[_[O]];break;end while(a)/((-0x15+212))==3230 do a=(1998909)while(0x240-316)<C do a-= a local a;d[_[x]][_[k]]=_[t];e=e+l;_=o[e];d[_[r]][_[O]]=_[u];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[k]];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[w]]=P[_[O]];e=e+l;_=o[e];d[_[w]][_[O]]=d[_[B]];e=e+l;_=o[e];a=_[r]d[a](N(d,a+v,_[k]))e=e+l;_=o[e];d[_[D]]=P[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[u]];break end while(a)/((0x22e9/3))==671 do local a;d[_[D]]=_[k];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[x]]=d[_[i]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=P[_[b]];e=e+l;_=o[e];d[_[D]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=P[_[k]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[D]]=d[_[O]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[D]][_[b]]=d[_[f]];e=e+l;_=o[e];d[_[w]]=P[_[U]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=P[_[k]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]]=d[_[O]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[n]]=P[_[O]];e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=P[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[w]]=d[_[O]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]][_[k]]=d[_[s]];break end;break;end break;end while(a)/((0x77b-1009))==2203 do a=(3913680)while(0xde16/217)>=C do a-= a local a;d[_[h]]=_[i];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]][_[i]]=d[_[t]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[c]]=d[_[h]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[t]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[D]][_[O]]=d[_[f]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[h]][_[c]]=d[_[t]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[n]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[n]]=(_[b]~=0);e=e+l;_=o[e];d[_[h]][_[O]]=d[_[u]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];M[_[U]]=d[_[r]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[w]][_[b]]=d[_[B]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[U]]=d[_[D]];e=e+l;_=o[e];d[_[n]]=M[_[k]];break;end while 2127==(a)/((152720/0x53))do a=(1863745)while C>(624-0x169)do a-= a local a;d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[n]]=d[_[k]]*d[_[S]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[x]][_[U]]=d[_[s]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[w]]=d[_[b]];break end while 541==(a)/((0x1aff-3466))do if d[_[r]]then e=e+l;else e=_[c];end;break end;break;end break;end break;end while 3614==(a)/((357670/0xeb))do a=(60480)while C<=(17622/0x42)do a-= a a=(779923)while C<=(8480/0x20)do a-= a d[_[h]]=#d[_[i]];break;end while 3959==(a)/((-0x4e+275))do a=(4898062)while(0x9ad2/149)<C do a-= a local a;d[_[w]]=(_[i]~=0);e=e+l;_=o[e];a=_[n]d[a](N(d,a+v,_[i]))e=e+l;_=o[e];d[_[n]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[w]]=P[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[u]];break end while(a)/((-0x14+1849))==2678 do local a;d[_[n]]=d[_[k]]-d[_[u]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[n]]=d[_[U]][d[_[f]]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=d[_[U]][d[_[S]]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=d[_[i]]*d[_[s]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]]=d[_[U]];break end;break;end break;end while(a)/((2400/(177-0x93)))==756 do a=(9446064)while C<=(25460/0x5f)do a-= a local a;d[_[n]]=_[i];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[n]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[n]]=_[k];break;end while 3984==(a)/(((339669/0x8d)+-0x26))do a=(355911)while(48958/0xb6)<C do a-= a local h;local C,c;local k;local a;M[_[U]]=d[_[w]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];a=_[D];k=d[_[b]];d[a+1]=k;d[a]=k[_[S]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[x]C,c=m(d[a](N(d,a+1,_[U])))g=c+a-1 h=0;for _=a,g do h=h+l;d[_]=C[h];end;e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,g))e=e+l;_=o[e];d[_[D]]();e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[D]]={};break end while 1333==(a)/((61410/0xe6))do local a;d[_[h]]=_[k];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[h]][_[k]]=d[_[B]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[b]]=d[_[r]];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];a=_[D]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[n]][_[U]]=d[_[t]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[w]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]][_[b]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=(_[c]~=0);e=e+l;_=o[e];d[_[n]][_[c]]=d[_[t]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[w]][_[i]]=d[_[s]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[U]]=d[_[w]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[D]][_[U]]=d[_[f]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];M[_[c]]=d[_[r]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[n]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[U]];break end;break;end break;end break;end break;end while 1578==(a)/((-0x6d+1011))do a=(13738843)while C<=(0x29c-392)do a-= a a=(3907200)while(0x278-359)>=C do a-= a a=(545200)while C<=(633-0x16a)do a-= a local o=_[x];local r=_[s];local a=o+2 local o={d[o](d[o+1],d[a])};for _=1,r do d[a+_]=o[_];end;local o=o[1]if o then d[a]=o e=_[b];else e=e+l;end;break;end while 464==(a)/((0x29e1e/146))do a=(1954928)while C>(-0x1e+(61306/0xcb))do a-= a local r;local a;a=_[x]d[a](N(d,a+v,_[U]))e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=d[_[b]][d[_[s]]];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];a=_[w];r=d[_[b]];d[a+1]=r;d[a]=r[d[_[t]]];break end while 976==(a)/((0x7d3/1))do local r;local a;d[_[x]]=P[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[S]];e=e+l;_=o[e];a=_[n];r=d[_[b]];d[a+1]=r;d[a]=r[_[S]];e=e+l;_=o[e];d[_[n]]=d[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[k]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];a=_[h];r=d[_[i]];d[a+1]=r;d[a]=r[_[B]];e=e+l;_=o[e];a=_[n]d[a](d[a+v])e=e+l;_=o[e];do return end;break end;break;end break;end while(a)/((0x12c4-2436))==1650 do a=(1562670)while C<=(-70+0x158)do a-= a local a;d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[n]][_[i]]=d[_[s]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[U]]=d[_[n]];e=e+l;_=o[e];d[_[w]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[r]][_[U]]=d[_[u]];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[r]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[r]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=(_[O]~=0);e=e+l;_=o[e];d[_[r]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[U]]=d[_[t]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];M[_[k]]=d[_[w]];e=e+l;_=o[e];d[_[n]]=M[_[O]];break;end while 1455==(a)/((37590/0x23))do a=(8196979)while C>(62975/0xe5)do a-= a d[_[r]]=d[_[k]]-d[_[s]];break end while 2239==(a)/((0x1d08-(7591-0xeec)))do local r;local a;d[_[n]]=P[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[n]]=d[_[b]];e=e+l;_=o[e];a=_[D]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];r=d[_[t]];if not r then e=e+v;else d[_[h]]=r;e=_[U];end;break end;break;end break;end break;end while 3427==(a)/((0x486da/74))do a=(288078)while C<=(57195/0xcd)do a-= a a=(972144)while C<=(0x269-340)do a-= a local a;d[_[x]]();e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=P[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]]=d[_[i]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]][_[i]]=d[_[f]];e=e+l;_=o[e];d[_[x]]=P[_[c]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=P[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]]=d[_[O]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[r]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=P[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[r]]=d[_[U]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[w]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=P[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]=_[U];break;end while 387==(a)/((5041-0x9e1))do a=(3291132)while(313+(-44+0x9))<C do a-= a local n;local M,i;local a;d[_[D]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[w]]=P[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];a=_[x]M,i=m(d[a](N(d,a+1,_[k])))g=i+a-1 n=0;for _=a,g do n=n+l;d[_]=M[n];end;e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,g))break end while(a)/((3560+-0x5c))==949 do local a;d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[b]];e=e+l;_=o[e];d[_[h]]=d[_[U]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[x]][_[i]]=d[_[t]];break end;break;end break;end while(a)/((38703/0x61))==722 do a=(5446434)while(0x2a1-393)>=C do a-= a local _=_[D];do return d[_](N(d,_+1,g))end;break;end while(a)/((0x114d-2266))==2518 do a=(218420)while C>(-94+0x177)do a-= a d[_[h]]=y(A[_[b]],nil,M);break end while 163==(a)/((0xac1-1413))do if not d[_[r]]then e=e+v;else e=_[i];end;break end;break;end break;end break;end break;end break;end break;end break;end while(a)/(((0x129d005/255)/0x5d))==757 do a=(10969120)while C<=(43099/0x83)do a-= a a=(3416250)while(0x2a6-373)>=C do a-= a a=(272322)while C<=(0x2a4-383)do a-= a a=(10382117)while(594-0x133)>=C do a-= a a=(1967880)while(-0x4b+359)>=C do a-= a a=(6238910)while C>(0x2f89/43)do a-= a local n=A[_[b]];local r;local l={};r=K({},{__index=function(e,_)local _=l[_];return _[1][_[2]];end,__newindex=function(d,_,e)local _=l[_]_[1][_[2]]=e;end;});for a=1,_[S]do e=e+v;local _=o[e];if _[(0xc9/201)]==341 then l[a-1]={d,_[U]};else l[a-1]={P,_[k]};end;L[#L+1]=l;end;d[_[D]]=y(n,r,M);break end while 2978==(a)/(((-26+-0x34)+0x87d))do local a;d[_[w]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[O]]=d[_[s]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[U]]=d[_[x]];e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[D]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];a=_[x]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]][_[U]]=d[_[t]];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=d[_[U]][d[_[f]]];e=e+l;_=o[e];d[_[r]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[n]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[t]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]][_[k]]=d[_[u]];e=e+l;_=o[e];d[_[h]]=(_[i]~=0);e=e+l;_=o[e];d[_[n]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[c]]=d[_[B]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];M[_[c]]=d[_[x]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[w]][_[b]]=d[_[f]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))break end;break;end while(a)/((5600-(346480/0x7a)))==713 do a=(95140)while(-0x5a+375)>=C do a-= a do return d[_[x]]end break;end while 335==(a)/((23288/0x52))do a=(7299124)while(594-0x134)<C do a-= a M[_[U]]=d[_[r]];break end while(a)/((2137+-0x5d))==3571 do local e=_[h]local o,_=m(d[e](N(d,e+1,_[b])))g=_+e-1 local _=0;for e=e,g do _=_+l;d[e]=o[_];end;break end;break;end break;end break;end while 2759==(a)/((7557-(-0x6a+3900)))do a=(1379340)while((0x7889-15487)/0x35)>=C do a-= a a=(1050920)while(0x28a-362)>=C do a-= a local a;d[_[D]]=_[O];e=e+l;_=o[e];d[_[n]]=d[_[k]]*d[_[B]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]=d[_[c]]*d[_[f]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[x]][_[U]]=d[_[u]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[x]]=_[U];break;end while(a)/((0x3cdc8/204))==860 do a=(1814225)while(355+-0x42)<C do a-= a d[_[w]][_[U]]=d[_[t]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];break end while(a)/((0xbb0-1511))==1225 do local e=_[w]local a={d[e](N(d,e+1,_[b]))};local o=0;for _=e,_[u]do o=o+l;d[_]=a[o];end break end;break;end break;end while 3555==(a)/((-105+0x1ed))do a=(448944)while(0x2be-411)>=C do a-= a local a;d[_[D]]=_[U];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[w]]=d[_[b]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[r]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=M[_[U]];break;end while 3184==(a)/((0x159-204))do a=(4927008)while C>((34546+-0x5a)/118)do a-= a if(d[_[n]]==d[_[S]])then e=e+v;else e=_[O];end;break end while 1632==(a)/((6146-0xc37))do d[_[x]][d[_[k]]]=d[_[S]];break end;break;end break;end break;end break;end while 2214==(a)/((296-0xad))do a=(11219676)while(0x13e+-19)>=C do a-= a a=(13487872)while C<=(0x27e-342)do a-= a a=(3912700)while(-94+0x184)>=C do a-= a local a;d[_[w]][_[k]]=d[_[S]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[k]]=d[_[w]];e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[n]][_[c]]=d[_[B]];break;end while(a)/((0x8c8-(19516/0x11)))==3557 do a=(1683796)while C>(699-0x194)do a-= a local i;local a;d[_[r]]=d[_[c]]/d[_[s]];e=e+l;_=o[e];a=_[n]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[x]]=d[_[U]]*d[_[B]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];i={d,_};i[v][i[j][n]]=i[l][i[j][f]]+i[v][i[j][O]];e=e+l;_=o[e];a=_[h]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[h]]=_[c];break end while 1147==(a)/((0xb97-1499))do local a;a=_[D]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[b]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=P[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[U];break end;break;end break;end while(a)/((623040/0xa5))==3572 do a=(5497605)while(0x72db/99)>=C do a-= a local a;d[_[r]][_[c]]=d[_[t]];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[n]][_[U]]=d[_[u]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]=(_[O]~=0);e=e+l;_=o[e];d[_[x]]=(_[c]~=0);e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=M[_[U]];break;end while 1899==(a)/((-0x61+2992))do a=(1594320)while(-0x5a+388)<C do a-= a local a;d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];a=_[x]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[w]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[t]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[w]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[r]][_[k]]=_[t];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[D]][_[U]]=d[_[t]];e=e+l;_=o[e];d[_[D]]=M[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[D]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[D]][_[U]]=d[_[S]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[b]]=d[_[r]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]][_[c]]=d[_[f]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[w]][_[c]]=d[_[u]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[c]]=d[_[x]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[D]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[r]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[U]];break end while(a)/((2234+-0x2c))==728 do local a;d[_[w]]=_[U];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[D]][_[O]]=d[_[f]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[U];break end;break;end break;end break;end while 3127==(a)/(((7374-0xea2)+-40))do a=(58960)while(376+-0x4a)>=C do a-= a a=(10821468)while(713-0x19d)>=C do a-= a d[_[r]]=d[_[i]][_[t]];e=e+l;_=o[e];d[_[D]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[n]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[x]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[h]]=M[_[O]];break;end while 2741==(a)/((0x1f04-3992))do a=(7234344)while(-0x1c+329)<C do a-= a local _=_[r];do return N(d,_,g)end;break end while(a)/((420316/0x89))==2358 do local a;d[_[w]]=(_[k]~=0);e=e+l;_=o[e];d[_[r]][_[b]]=d[_[u]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]][_[O]]=d[_[B]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];M[_[i]]=d[_[x]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]][_[O]]=d[_[f]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[k]]=d[_[r]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[h]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[n]][_[c]]=d[_[S]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[O]]=d[_[B]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[k]]=d[_[t]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];M[_[O]]=d[_[w]];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];a=_[h]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]][_[O]]=d[_[u]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[S]];break end;break;end break;end while(a)/((12672/0x90))==670 do a=(10537)while C<=(0x3543/45)do a-= a local e=_[n]d[e]=d[e](N(d,e+l,_[O]))break;end while 257==(a)/((183-0x8e))do a=(10239936)while C>(0xf4a0/206)do a-= a local i;local h,b;local a;d[_[n]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];a=_[r]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[x]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];a=_[w]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[w]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];a=_[w]h,b=m(d[a](d[a+v]))g=b+a-l i=0;for _=a,g do i=i+l;d[_]=h[i];end;break end while 3208==(a)/((0xcd3+(-0x47ce/202)))do local n;local a;M[_[k]]=d[_[r]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[w]]=d[_[k]][d[_[t]]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[D];n=d[_[k]];d[a+1]=n;d[a]=n[d[_[B]]];break end;break;end break;end break;end break;end break;end while 911==(a)/(((0xab6eb8/107)/0x1c))do a=(2720122)while C<=(714-0x18d)do a-= a a=(357822)while(-121+(0x217+-103))>=C do a-= a a=(2415820)while C<=((-36+-0x22)+0x17a)do a-= a a=(3809970)while(335+-0x1d)>=C do a-= a local a;local i;local x;d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=d[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[c]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];x=_[w]i={d[x](N(d,x+1,_[b]))};a=0;for _=x,_[B]do a=a+l;d[_]=i[a];end e=e+l;_=o[e];if not d[_[r]]then e=e+v;else e=_[U];end;break;end while 2781==(a)/((2859-0x5d1))do a=(3841110)while C>(0x29c-361)do a-= a local a;a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];M[_[c]]=d[_[n]];e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[c]]=d[_[t]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[D]][_[O]]=d[_[t]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[b]]=d[_[D]];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[r]][_[O]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[w]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[t]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[S]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[O]]=d[_[x]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];a=_[w]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[x]][_[c]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[t]];e=e+l;_=o[e];d[_[w]]=_[b];break end while(a)/((1235+-0x1d))==3185 do local b;local a;d[_[r]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];a=_[h];b=d[a];for _=a+1,_[c]do p(b,d[_])end;break end;break;end break;end while(a)/((0x3576c/252))==2780 do a=(8567650)while C<=(0x2bf-394)do a-= a local a=_[n];local r=_[s];local o=a+2 local a={d[a](d[a+1],d[o])};for _=1,r do d[o+_]=a[_];end;local a=a[1]if a then d[o]=a e=_[b];else e=e+l;end;break;end while 2450==(a)/((-78+0xdf7))do a=(2124744)while C>(0x19d+-103)do a-= a local i;local C,u;local a;d[_[x]]=P[_[k]];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[h]]=P[_[c]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[t]];e=e+l;_=o[e];a=_[r]C,u=m(d[a](N(d,a+1,_[k])))g=u+a-1 i=0;for _=a,g do i=i+l;d[_]=C[i];end;e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,g))e=e+l;_=o[e];d[_[w]][_[U]]=d[_[B]];e=e+l;_=o[e];do return end;break end while 794==(a)/((0xc69c/19))do local a;d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]]=d[_[c]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=P[_[U]];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=P[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[s]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]]=d[_[b]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[h]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=P[_[k]];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[n]]=d[_[U]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[D]][_[i]]=d[_[f]];e=e+l;_=o[e];d[_[h]]=P[_[c]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[h]]=P[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[h]]=P[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[w]]=P[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[x]]=d[_[O]];break end;break;end break;end break;end while 618==(a)/(((8641575/0xc7)/75))do a=(74520)while C<=(0x4998/60)do a-= a a=(12206770)while C<=(0x30c0/40)do a-= a local a;d[_[x]]=d[_[c]]*d[_[s]];e=e+l;_=o[e];d[_[D]][_[i]]=d[_[B]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[n]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[B]];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[h]]=d[_[i]];break;end while 3035==(a)/((-95+0x1015))do a=(9753240)while(0x19f+-102)<C do a-= a local a;d[_[x]]=d[_[b]];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[n]]=P[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[h]]=P[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[k]))break end while(a)/((0xcc443/245))==2856 do local a;d[_[w]]=_[O];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[r]][_[c]]=d[_[u]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[U]]=d[_[n]];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];a=_[r]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[h]][_[O]]=d[_[t]];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[n]][_[O]]=d[_[B]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]][_[U]]=d[_[f]];e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[r]][_[c]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=(_[i]~=0);e=e+l;_=o[e];d[_[r]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[t]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[s]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[c]]=d[_[x]];e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[U]]=d[_[u]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[O]]=d[_[x]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[h]][_[i]]=d[_[u]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[h]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[S]];break end;break;end break;end while(a)/((-0x66+1182))==69 do a=(2584903)while C<=(684-(0x35f-494))do a-= a d[_[x]]=d[_[U]][d[_[t]]];break;end while 2131==(a)/(((-0x2e-31)+0x50a))do a=(6348370)while C>(27492/(0x12d-214))do a-= a local a;d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]][_[c]]=d[_[u]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[b]]=d[_[D]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[h]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[h]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[w]][_[b]]=d[_[f]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[x]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[D]][_[O]]=d[_[t]];e=e+l;_=o[e];d[_[D]]=(_[b]~=0);e=e+l;_=o[e];d[_[w]][_[c]]=d[_[t]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[S]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[U]]=d[_[B]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[b]]=d[_[r]];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]][_[U]]=d[_[s]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];M[_[k]]=d[_[n]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[w]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[h]][_[U]]=d[_[f]];e=e+l;_=o[e];d[_[n]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[w]]=_[c];break end while(a)/((4183-(4336-0x88f)))==3115 do if(d[_[D]]==_[S])then e=e+v;else e=_[k];end;break end;break;end break;end break;end break;end while(a)/((0x16008/120))==3622 do a=(9001464)while C<=(0x63ad/79)do a-= a a=(1780219)while C<=(0x2d1-401)do a-= a a=(8319521)while(-16+0x14e)>=C do a-= a if not d[_[h]]then e=e+v;else e=_[i];end;break;end while 3143==(a)/((0x151b-2756))do a=(9432762)while C>(686-(-0x48+439))do a-= a local a;d[_[r]]=_[b];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[n]]=d[_[c]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[D]][_[b]]=d[_[f]];e=e+l;_=o[e];d[_[h]]=P[_[k]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=P[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[r]]=d[_[b]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[n]][_[b]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=P[_[U]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=P[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[h]]=d[_[O]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[h]][_[k]]=d[_[B]];e=e+l;_=o[e];d[_[w]]=P[_[i]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=P[_[k]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[w]]=M[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[x]]=d[_[U]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[n]][_[i]]=d[_[u]];break end while(a)/((0x13d0-2591))==3802 do local a;M[_[i]]=d[_[n]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[u]];e=e+l;_=o[e];a=_[x]d[a](N(d,a+v,_[i]))e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[n]]=d[_[O]][d[_[t]]];e=e+l;_=o[e];d[_[n]]=(_[i]~=0);break end;break;end break;end while(a)/(((303116-0x25038)/196))==2303 do a=(9872400)while(661-0x154)>=C do a-= a local C;local s;local a;d[_[n]]=M[_[c]];e=e+l;_=o[e];a=_[x];s=d[_[c]];d[a+1]=s;d[a]=s[_[f]];e=e+l;_=o[e];d[_[r]]=P[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[n]]=P[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]]=d[_[O]]*d[_[u]];e=e+l;_=o[e];d[_[w]]=d[_[O]]/_[S];e=e+l;_=o[e];d[_[r]]=d[_[U]]-d[_[B]];e=e+l;_=o[e];d[_[n]]=P[_[k]];e=e+l;_=o[e];d[_[r]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[r]]=d[_[b]]*d[_[f]];e=e+l;_=o[e];d[_[h]]=d[_[U]]/_[B];e=e+l;_=o[e];C={d,_};C[v][C[j][x]]=C[l][C[j][S]]+C[v][C[j][k]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]]=d[_[c]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[n];do return d[a](N(d,a+1,_[i]))end;e=e+l;_=o[e];a=_[n];do return N(d,a,g)end;e=e+l;_=o[e];do return end;break;end while(a)/((-0x52+3882))==2598 do a=(1310122)while C>(-76+0x18e)do a-= a if(_[x]<d[_[S]])then e=e+v;else e=_[c];end;break end while(a)/((0x79630/200))==527 do do return end;break end;break;end break;end break;end while 3174==(a)/((5746-0xb5e))do a=(1363725)while((-77+0x1aa)+-0x17)>=C do a-= a a=(4808144)while C<=(66744/0xce)do a-= a local _=_[r]local o,e=m(d[_](d[_+v]))g=e+_-l local e=0;for _=_,g do e=e+l;d[_]=o[e];end;break;end while(a)/((0x63a72/127))==1496 do a=(1124812)while(0x1bb+-118)<C do a-= a d[_[n]]=M[_[O]];break end while(a)/((-0x61+(0x1038d/137)))==2899 do d[_[r]]=#d[_[O]];break end;break;end break;end while 957==(a)/((2918-0x5d5))do a=(4792644)while C<=(689-0x16a)do a-= a local h;local a;d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];a=_[w];h=d[_[c]];d[a+1]=h;d[a]=h[d[_[B]]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[n]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[u]];e=e+l;_=o[e];if not d[_[r]]then e=e+v;else e=_[O];end;break;end while 3974==(a)/((1280+-0x4a))do a=(8166844)while(0x1bf+-119)<C do a-= a d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[n]][_[b]]=d[_[f]];e=e+l;_=o[e];d[_[D]]={};e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[S]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[D]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[r]][_[O]]=d[_[S]];e=e+l;_=o[e];d[_[n]]=M[_[i]];break end while 3836==(a)/((2165+-0x24))do d[_[x]]=d[_[i]]-d[_[B]];break end;break;end break;end break;end break;end break;end break;end while(a)/((-98+0xe5e))==3064 do a=(5435850)while C<=((87616-0xab44)/0x7c)do a-= a a=(470127)while(48763/0x8f)>=C do a-= a a=(5333986)while C<=(0x2b0-353)do a-= a a=(1107600)while C<=(-116+0x1c0)do a-= a a=(2591104)while(-74+0x194)>=C do a-= a local a;d[_[w]]();e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=P[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[B]];e=e+l;_=o[e];a=_[n]d[a](d[a+v])e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=P[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[w]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[h]]=d[_[U]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[n]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[h]]=P[_[O]];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]]=d[_[k]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[h]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=P[_[c]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=P[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[n]]=d[_[O]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[x]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[n]]=P[_[i]];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[h]]=_[i];break;end while 992==(a)/(((-0x75+46)+0xa7b))do a=(15872255)while(368+-0x25)<C do a-= a local l=_[h];local o=d[l]local a=d[l+2];if(a>0)then if(o>d[l+1])then e=_[U];else d[l+3]=o;end elseif(o<d[l+1])then e=_[i];else d[l+3]=o;end break end while 3983==(a)/((0x1f47-4022))do if(d[_[n]]<=d[_[f]])then e=_[c];else e=e+v;end;break end;break;end break;end while 3408==(a)/((0x2e4-415))do a=(8099136)while C<=(0x177+-42)do a-= a local a;d[_[D]]=_[c];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[r]][_[i]]=d[_[B]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[i]]=d[_[n]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];a=_[n]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[x]][_[c]]=d[_[S]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=d[_[i]][d[_[s]]];e=e+l;_=o[e];d[_[h]][_[c]]=d[_[s]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=d[_[O]][d[_[f]]];e=e+l;_=o[e];d[_[h]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[r]][_[i]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[D]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[D]]=(_[O]~=0);e=e+l;_=o[e];d[_[w]][_[c]]=d[_[s]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[D]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[w]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[n]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]][_[U]]=d[_[S]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];M[_[k]]=d[_[D]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=_[U];break;end while 2752==(a)/((0x6047a/134))do a=(6475540)while(0x15e+-16)<C do a-= a local C;local P,B;local a;d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[n]]=d[_[k]][d[_[S]]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=d[_[O]][d[_[f]]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=d[_[U]][d[_[f]]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[h]]=d[_[U]][d[_[S]]];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[r]]=d[_[O]]/d[_[t]];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];a=_[w]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[h]]=-d[_[i]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[w]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];a=_[n]P,B=m(d[a](d[a+v]))g=B+a-l C=0;for _=a,g do C=C+l;d[_]=P[C];end;e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,g))e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]]=d[_[k]]*d[_[f]];e=e+l;_=o[e];d[_[h]]=d[_[b]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]]=d[_[b]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[n]][_[i]]=d[_[t]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[h]]=d[_[i]][_[t]];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[s]];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[D]]=d[_[k]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[c]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[s]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[h]]=_[k];break end while 2173==(a)/((5987-0xbbf))do if(d[_[r]]~=_[S])then e=e+v;else e=_[i];end;break end;break;end break;end break;end while(a)/((2800+-0x3b))==1946 do a=(850950)while(-0x38+394)>=C do a-= a a=(297045)while C<=((54887+-0x77)/163)do a-= a d[_[r]][_[b]]=_[t];break;end while(a)/((347-0xe0))==2415 do a=(9674818)while C>(0x304-435)do a-= a local _={d,_};_[v][_[j][r]]=_[l][_[j][t]]+_[v][_[j][O]];break end while(a)/((7167-0xe09))==2707 do d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[n]][_[U]]=d[_[t]];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[D]][_[c]]=d[_[f]];e=e+l;_=o[e];d[_[h]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=M[_[i]];break end;break;end break;end while 558==(a)/((0x18f1f/67))do a=(4368858)while C<=(-47+0x182)do a-= a local h;local a;d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[B]];e=e+l;_=o[e];a=_[r];h=d[_[i]];d[a+1]=h;d[a]=h[_[u]];e=e+l;_=o[e];a=_[n]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[n]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[D]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[w]][_[b]]=d[_[B]];e=e+l;_=o[e];e=_[U];break;end while(a)/((359463/0xa9))==2054 do a=(2865780)while C>(0x30f-443)do a-= a d[_[x]]=d[_[k]];break end while 3915==(a)/((1560-0x33c))do local j;local C;local a;d[_[x]][_[c]]=d[_[f]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[r]]=d[_[k]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[h]]=-d[_[i]];e=e+l;_=o[e];d[_[h]]=d[_[k]]/_[B];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[x]]=d[_[O]]*d[_[t]];e=e+l;_=o[e];d[_[w]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[h]][_[k]]=d[_[S]];e=e+l;_=o[e];a=_[n]d[a](d[a+v])e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[n]][_[i]]=_[S];e=e+l;_=o[e];d[_[h]][_[c]]=_[f];e=e+l;_=o[e];d[_[n]]=P[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[w]]=P[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[n]]=d[_[O]];e=e+l;_=o[e];a=_[w]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[w]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[w]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[w]][_[U]]=d[_[s]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];a=_[h]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[D]][_[O]]=d[_[f]];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[D]][_[c]]=d[_[B]];e=e+l;_=o[e];d[_[h]][_[U]]=_[B];e=e+l;_=o[e];d[_[w]][_[k]]=d[_[t]];e=e+l;_=o[e];a=_[w]d[a](d[a+v])e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[h];C=d[a]j=d[a+2];if(j>0)then if(C>d[a+1])then e=_[U];else d[a+3]=C;end elseif(C<d[a+1])then e=_[k];else d[a+3]=C;end break end;break;end break;end break;end break;end while(a)/((0x3c5-538))==1101 do a=(11036973)while(43028/0x7c)>=C do a-= a a=(1992000)while C<=(392+-0x30)do a-= a a=(2006235)while C<=(-16+0x166)do a-= a local a;d[_[x]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[n]]=d[_[i]]*d[_[f]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[u]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]][_[k]]=d[_[B]];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[h]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[n]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[n]][_[i]]=d[_[S]];break;end while 965==(a)/((0x1141e/34))do a=(167596)while C>(0x180+(-0x51+40))do a-= a d[_[h]][_[U]]=d[_[t]];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[r]][_[b]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[n]][_[b]]=d[_[t]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=d[_[U]][_[u]];break end while 3223==(a)/((121-0x45))do local a;a=_[r]d[a]=d[a](N(d,a+l,g))e=e+l;_=o[e];d[_[x]]=d[_[b]]*d[_[f]];e=e+l;_=o[e];d[_[h]]=d[_[k]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[n]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[r]]=_[c];break end;break;end break;end while 2400==(a)/((0xefec/74))do a=(7355838)while C<=(459+-0x72)do a-= a local i;local a;d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[r]]=d[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[c]]-d[_[S]];e=e+l;_=o[e];d[_[D]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[n]]=d[_[c]]*d[_[t]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];a=_[x];i=d[_[b]];d[a+1]=i;d[a]=i[_[u]];e=e+l;_=o[e];d[_[h]]=d[_[b]];e=e+l;_=o[e];i=d[_[B]];if not i then e=e+v;else d[_[r]]=i;e=_[b];end;break;end while(a)/((59598/0x21))==4073 do a=(943540)while C>(748-0x192)do a-= a local C;local j,L;local a;d[_[h]]={};e=e+l;_=o[e];d[_[r]][_[c]]=_[B];e=e+l;_=o[e];d[_[n]][_[i]]=_[f];e=e+l;_=o[e];d[_[n]]=P[_[U]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[f]];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[n]]=P[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[r]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[S]];e=e+l;_=o[e];d[_[x]]=d[_[b]];e=e+l;_=o[e];a=_[D]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[x]]=P[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[n]]=P[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]]=P[_[c]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[r]]=P[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[h]j,L=m(d[a](N(d,a+1,_[O])))g=L+a-1 C=0;for _=a,g do C=C+l;d[_]=j[C];end;e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,g))e=e+l;_=o[e];d[_[n]]=d[_[i]]*d[_[S]];e=e+l;_=o[e];d[_[x]]=P[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[B]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[x]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[h]]=d[_[U]]*d[_[s]];e=e+l;_=o[e];d[_[h]]=d[_[O]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[h]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[x]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[w]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[n]][_[b]]=d[_[S]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];a=_[x]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[w]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[w]]=P[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]][_[k]]=d[_[u]];e=e+l;_=o[e];d[_[r]][_[b]]=_[t];e=e+l;_=o[e];d[_[h]][_[b]]=d[_[B]];e=e+l;_=o[e];a=_[D]d[a](d[a+v])break end while 247==(a)/(((7916-0xf8c)+-116))do local l=_[D];local o=d[l]local a=d[l+2];if(a>0)then if(o>d[l+1])then e=_[i];else d[l+3]=o;end elseif(o<d[l+1])then e=_[c];else d[l+3]=o;end break end;break;end break;end break;end while(a)/((0x1ca1-3678))==3023 do a=(8451926)while(0x311-435)>=C do a-= a a=(4448010)while C<=(56724/0xa3)do a-= a local N;local M;local a;d[_[h]]=(_[b]~=0);e=e+l;_=o[e];P[_[i]]=d[_[D]];e=e+l;_=o[e];d[_[r]]=(_[U]~=0);e=e+l;_=o[e];P[_[k]]=d[_[h]];e=e+l;_=o[e];d[_[r]]=P[_[U]];e=e+l;_=o[e];d[_[x]][_[k]]=_[t];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[n];M=d[a]N=d[a+2];if(N>0)then if(M>d[a+1])then e=_[U];else d[a+3]=M;end elseif(M<d[a+1])then e=_[O];else d[a+3]=M;end break;end while(a)/((2534-0x50f))==3590 do a=(427050)while C>(0x312-437)do a-= a d[_[n]]=d[_[c]][_[S]];break end while(a)/((1880+-0x37))==234 do local a;d[_[h]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[r]]=d[_[O]]*d[_[B]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[S]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[n]]=d[_[i]][_[f]];break end;break;end break;end while 3983==(a)/(((579496/0x88)-0x85b))do a=(2664640)while(0x326-455)>=C do a-= a d[_[r]][_[U]]=d[_[B]];e=e+l;_=o[e];d[_[x]]=(_[i]~=0);e=e+l;_=o[e];d[_[r]][_[k]]=d[_[S]];e=e+l;_=o[e];d[_[h]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[D]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[t]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[t]];break;end while 3785==(a)/((-0x5a+794))do a=(106733)while C>((0x11fcb+-107)/0xd1)do a-= a d[_[D]]=d[_[O]]%d[_[S]];break end while 313==(a)/((410+-0x45))do local a;d[_[h]]();e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[D]]=d[_[b]][_[f]];e=e+l;_=o[e];a=_[w]d[a](d[a+v])e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=P[_[c]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[f]];e=e+l;_=o[e];d[_[n]]=M[_[i]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[r]]=d[_[k]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[x]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=P[_[i]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=P[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[B]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[S]];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[D]]=d[_[b]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[D]][_[b]]=d[_[B]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=P[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[r]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[h]]=d[_[b]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];d[_[r]][_[k]]=d[_[t]];e=e+l;_=o[e];d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[B]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[D]]=_[k];break end;break;end break;end break;end break;end break;end while 1670==(a)/((442680/0x88))do a=(579150)while C<=(806-(499+-0x3a))do a-= a a=(1100040)while(799-0x1b8)>=C do a-= a a=(2818475)while C<=(-83+0x1b7)do a-= a a=(13430)while(-80+0x1b2)>=C do a-= a d[_[x]]=P[_[U]];break;end while 79==(a)/((282+-0x70))do a=(1955646)while(0x1d5+-114)<C do a-= a local U;local a;d[_[n]]=_[b];e=e+l;_=o[e];a=_[h];U=d[_[k]];d[a+1]=U;d[a]=U[d[_[B]]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[h]]=d[_[b]][d[_[S]]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[r];U=d[_[k]];d[a+1]=U;d[a]=U[d[_[S]]];break end while(a)/((74052/(0x1c1a/109)))==1743 do local a;local O;local C,B;local P;local a;d[_[h]]=_[U];e=e+l;_=o[e];d[_[h]]=d[_[U]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[n]][_[c]]=_[S];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];a=_[w];P=d[_[c]];d[a+1]=P;d[a]=P[_[t]];e=e+l;_=o[e];a=_[n]C,B=m(d[a](d[a+v]))g=B+a-l O=0;for _=a,g do O=O+l;d[_]=C[O];end;e=e+l;_=o[e];a=_[D]C={d[a](N(d,a+1,g))};O=0;for _=a,_[t]do O=O+l;d[_]=C[O];end e=e+l;_=o[e];e=_[k];break end;break;end break;end while 925==(a)/((0xc10+-41))do a=(504570)while(779-0x1a6)>=C do a-= a local _=_[h]d[_](d[_+v])break;end while(a)/((0x36d7/101))==3630 do a=(3415500)while C>(-0x69+463)do a-= a local a;d[_[h]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[D]][_[O]]=d[_[s]];e=e+l;_=o[e];d[_[n]][_[U]]=_[B];e=e+l;_=o[e];d[_[x]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[f]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[D]][_[O]]=d[_[S]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];M[_[c]]=d[_[x]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[n]]=M[_[O]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[h]]=M[_[U]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[S]];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[n]][_[k]]=d[_[t]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[b]]=d[_[w]];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[r]]=M[_[c]];e=e+l;_=o[e];d[_[w]][_[k]]=d[_[f]];e=e+l;_=o[e];d[_[w]]=M[_[b]];e=e+l;_=o[e];d[_[h]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[r]][_[i]]=d[_[s]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[x]]=d[_[b]][_[f]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[x]][_[b]]=d[_[t]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];M[_[O]]=d[_[D]];break end while 3795==(a)/((0x784-1024))do local e=_[r]d[e](N(d,e+v,_[U]))break end;break;end break;end break;end while 618==(a)/((0x4dc9c/179))do a=(78374)while(-0x4d+439)>=C do a-= a a=(1776591)while(52920/0x93)>=C do a-= a local a;a=_[x]d[a](N(d,a+v,g))e=e+l;_=o[e];d[_[D]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=P[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[u]];e=e+l;_=o[e];for _=_[n],_[O]do d[_]=nil;end;e=e+l;_=o[e];e=_[b];break;end while(a)/((3699-(2006+-0x76)))==981 do a=(65556)while C>(-91+0x1c4)do a-= a local a;d[_[h]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))break end while(a)/((0x91+-91))==1214 do local a;d[_[h]]=_[k];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[r]]=d[_[O]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[h]][_[b]]=d[_[s]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[h]]=M[_[c]];e=e+l;_=o[e];d[_[D]]=P[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[s]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[B]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[r]]=d[_[b]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[D]][_[U]]=d[_[f]];e=e+l;_=o[e];d[_[x]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=P[_[c]];e=e+l;_=o[e];d[_[n]]=d[_[U]][_[B]];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[w]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]]=d[_[b]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[w]][_[O]]=d[_[f]];e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[n]]=P[_[b]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[r]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[r]]=d[_[U]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]][_[U]]=d[_[s]];break end;break;end break;end while(a)/((19988/0x26))==149 do a=(1643961)while C<=(8349/0x17)do a-= a local a;d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[h]]={};e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[B]];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[h]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[n]][_[O]]=d[_[B]];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[U]]=d[_[h]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[h]]=M[_[i]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[r]][_[O]]=d[_[t]];e=e+l;_=o[e];d[_[r]]=M[_[i]];e=e+l;_=o[e];d[_[n]][_[k]]=d[_[u]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=d[_[c]][_[u]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[x]][_[O]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[O]];e=e+l;_=o[e];d[_[D]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[h]]=_[U];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[w]]=_[U];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[r]][_[U]]=d[_[B]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];M[_[b]]=d[_[h]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[h]]=_[c];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[x]]={};e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[k]][_[t]];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];a=_[D]d[a]=d[a](d[a+v])e=e+l;_=o[e];d[_[w]][_[U]]=d[_[S]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[x]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[r]][_[O]]=d[_[t]];e=e+l;_=o[e];d[_[r]]=M[_[b]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[w]][_[c]]=d[_[u]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[n]]=_[U];e=e+l;_=o[e];d[_[w]]=_[U];break;end while 1023==(a)/((154272/0x60))do a=(2172576)while C>(388+-0x18)do a-= a local a;d[_[x]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[i]))break end while(a)/(((0x9f78-20472)/0x10))==1708 do if(d[_[D]]~=d[_[S]])then e=e+v;else e=_[U];end;break end;break;end break;end break;end break;end while(a)/((0x7641c/138))==165 do a=(2751098)while C<=(-60+0x1af)do a-= a a=(2498135)while(0x30d-(0x3b2-533))>=C do a-= a a=(11509430)while(805-0x1b7)>=C do a-= a local a;d[_[h]]=P[_[i]];e=e+l;_=o[e];d[_[x]]=P[_[c]];e=e+l;_=o[e];d[_[n]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[w]]=P[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[x]]=P[_[b]];e=e+l;_=o[e];d[_[h]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[n]]=P[_[b]];e=e+l;_=o[e];d[_[n]]=d[_[O]][_[f]];e=e+l;_=o[e];d[_[h]]=P[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[S]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];P[_[U]]=d[_[x]];e=e+l;_=o[e];e=_[i];break;end while(a)/((0x203aa/43))==3749 do a=(7423230)while(0x1db+-108)<C do a-= a local a;d[_[w]]=_[U];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[D]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[D]][_[k]]=d[_[B]];e=e+l;_=o[e];d[_[x]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=d[_[k]][_[u]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[h]]=_[c];break end while(a)/((0xe2b+-82))==2094 do e=_[c];break end;break;end break;end while 2201==(a)/((0x41ac3/237))do a=(12917385)while C<=(0x16cad/253)do a-= a local a;d[_[n]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[n]]=d[_[O]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[x]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[h]]=P[_[c]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[r]]=P[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[i]][_[s]];e=e+l;_=o[e];d[_[w]]=M[_[O]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[S]];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[x]]=_[U];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[w]]=d[_[O]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[n]][_[O]]=d[_[u]];e=e+l;_=o[e];d[_[h]]=P[_[k]];e=e+l;_=o[e];d[_[D]]=M[_[i]];e=e+l;_=o[e];d[_[D]]=P[_[c]];e=e+l;_=o[e];d[_[D]]=d[_[U]][_[S]];e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[h]]=d[_[O]][_[t]];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[h]]=d[_[U]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];d[_[D]][_[c]]=d[_[S]];e=e+l;_=o[e];d[_[D]]=P[_[O]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[D]]=P[_[b]];e=e+l;_=o[e];d[_[h]]=d[_[i]][_[u]];e=e+l;_=o[e];d[_[w]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[O]][_[u]];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[n]]=_[b];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[r]]=_[O];e=e+l;_=o[e];d[_[n]]=_[k];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[i]))e=e+l;_=o[e];d[_[x]]=d[_[b]];e=e+l;_=o[e];a=_[w]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[w]][_[O]]=d[_[s]];break;end while 3195==(a)/((-32+0xfeb))do a=(927960)while(0x343-465)<C do a-= a d[_[n]]=d[_[k]]/_[S];break end while 627==(a)/(((6187-0xc4c)-0x617))do local a;d[_[r]]=_[i];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[x]]=d[_[i]];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[r]][_[U]]=d[_[f]];e=e+l;_=o[e];e=_[i];break end;break;end break;end break;end while 791==(a)/(((-50-0x1a)+0xde2))do a=(10763535)while C<=(0x145ca/223)do a-= a a=(2118251)while C<=(-123+0x1ef)do a-= a if(d[_[x]]~=d[_[t]])then e=e+v;else e=_[k];end;break;end while 2351==(a)/((-0x76+1019))do a=(808635)while C>(51847/0x8b)do a-= a local e=_[n]d[e](N(d,e+v,_[b]))break end while(a)/((126947/0x49))==465 do local a;d[_[r]]=_[U];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];a=_[D]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];d[_[w]][_[c]]=d[_[u]];e=e+l;_=o[e];a=_[n]d[a]=d[a](N(d,a+l,_[O]))e=e+l;_=o[e];M[_[k]]=d[_[h]];e=e+l;_=o[e];d[_[n]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=_[c];e=e+l;_=o[e];d[_[D]]=M[_[b]];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[x]]=d[_[c]][_[t]];e=e+l;_=o[e];d[_[r]]=d[_[U]][_[u]];e=e+l;_=o[e];d[_[h]][_[b]]=d[_[u]];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[u]];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[w]][_[k]]=d[_[s]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[r]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[i];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[n]]=_[c];e=e+l;_=o[e];d[_[r]]=_[U];e=e+l;_=o[e];d[_[h]]=_[O];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[w]]=_[b];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[x]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[U]))e=e+l;_=o[e];d[_[w]][_[i]]=d[_[B]];e=e+l;_=o[e];d[_[r]]=(_[O]~=0);e=e+l;_=o[e];d[_[h]][_[c]]=d[_[S]];e=e+l;_=o[e];a=_[h]d[a]=d[a](N(d,a+l,_[c]))e=e+l;_=o[e];M[_[O]]=d[_[r]];e=e+l;_=o[e];d[_[h]]=M[_[O]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[r]]=M[_[k]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[w]]={};e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[k]][_[s]];e=e+l;_=o[e];d[_[x]]=_[c];e=e+l;_=o[e];d[_[D]]=_[i];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];a=_[r]d[a]=d[a](N(d,a+l,_[k]))e=e+l;_=o[e];d[_[D]][_[O]]=d[_[B]];e=e+l;_=o[e];a=_[x]d[a]=d[a](N(d,a+l,_[b]))e=e+l;_=o[e];M[_[b]]=d[_[x]];e=e+l;_=o[e];d[_[w]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=_[k];e=e+l;_=o[e];d[_[x]]=M[_[U]];e=e+l;_=o[e];d[_[D]]=_[b];e=e+l;_=o[e];d[_[r]]={};e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[h]][_[c]]=d[_[f]];e=e+l;_=o[e];d[_[x]]=M[_[c]];e=e+l;_=o[e];d[_[w]][_[O]]=d[_[f]];e=e+l;_=o[e];d[_[n]]=M[_[b]];e=e+l;_=o[e];d[_[r]]=d[_[b]][_[s]];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[r]]=_[k];e=e+l;_=o[e];d[_[r]]=_[i];e=e+l;_=o[e];d[_[x]]=_[b];e=e+l;_=o[e];d[_[D]]=_[c];e=e+l;_=o[e];d[_[D]]=_[O];e=e+l;_=o[e];d[_[h]]=_[i];e=e+l;_=o[e];d[_[r]]=_[b];e=e+l;_=o[e];d[_[r]]=_[c];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];d[_[r]]=_[i];break end;break;end break;end while 3695==(a)/((-0x7a+3035))do a=(6004791)while(0x1b2+-59)>=C do a-= a d[_[n]]=P[_[O]];e=e+l;_=o[e];d[_[h]]=#d[_[i]];e=e+l;_=o[e];P[_[i]]=d[_[h]];e=e+l;_=o[e];d[_[x]]=P[_[k]];e=e+l;_=o[e];d[_[n]]=#d[_[O]];e=e+l;_=o[e];P[_[O]]=d[_[h]];e=e+l;_=o[e];do return end;break;end while 3019==(a)/((4038-0x801))do a=(1878137)while(0x138d8/213)<C do a-= a local a;d[_[D]]=d[_[k]]*d[_[t]];e=e+l;_=o[e];d[_[D]]=_[U];e=e+l;_=o[e];a={d,_};a[v][a[j][n]]=a[l][a[j][f]]+a[v][a[j][O]];e=e+l;_=o[e];d[_[n]]=_[O];e=e+l;_=o[e];d[_[w]]=_[O];e=e+l;_=o[e];d[_[x]]=_[i];e=e+l;_=o[e];d[_[x]]=_[k];e=e+l;_=o[e];d[_[h]]=_[k];e=e+l;_=o[e];d[_[n]]=_[i];e=e+l;_=o[e];d[_[h]]=_[b];break end while(a)/((3695-0x774))==1051 do d[_[w]][_[U]]=d[_[s]];e=e+l;_=o[e];d[_[n]]={};e=e+l;_=o[e];d[_[D]]=M[_[k]];e=e+l;_=o[e];d[_[w]]=d[_[c]][_[f]];e=e+l;_=o[e];d[_[n]][_[b]]=d[_[S]];e=e+l;_=o[e];d[_[w]]=d[_[b]][_[t]];e=e+l;_=o[e];d[_[n]]=M[_[U]];e=e+l;_=o[e];d[_[h]]=d[_[b]][_[S]];e=e+l;_=o[e];d[_[x]]=d[_[U]][_[s]];e=e+l;_=o[e];d[_[r]]=M[_[b]];break end;break;end break;end break;end break;end break;end break;end break;end break;end e+= v end;end);end;return y(J(),{},z())()end)_msec({[(-0x48+(40397/0xcb))]='\115\116'..(function(_)return(_ and'(0x445c/(0x18e-223))')or'\114\105'or'\120\58'end)((0x375/177)==(41+-0x23))..'\110g',[(1491-0x30a)]='\108\100'..(function(_)return(_ and'(299-0xc7)')or'\101\120'or'\119\111'end)((25+-0x14)==(0x20+-26))..'\112',[(18072/0x48)]=(function(_)return(_ and'(-0x40+164)')and'\98\121'or'\100\120'end)((0x26-33)==(117+-0x70))..'\116\101',[(0xce24/167)]='\99'..(function(_)return(_ and'(0x117-179)')and'\90\19\157'or'\104\97'end)((-62+0x43)==(0x2e-43))..'\114',[(0x464-579)]='\116\97'..(function(_)return(_ and'((17818+-0x76)/0xb1)')and'\64\113'or'\98\108'end)((33+-0x1b)==(0x76-113))..'\101',[(-104+0x210)]=(function(_)return(_ and'(235-0x87)')or'\115\117'or'\78\107'end)((0x5e-91)==(0x193/13))..'\98',[(1736-0x37b)]='\99\111'..(function(_)return(_ and'(8800/(0xbb0/34))')and'\110\99'or'\110\105\103\97'end)((2356/0x4c)==(0xb6-151))..'\97\116',[(1498-0x320)]=(function(_,e)return(_ and'(307-0xcf)')and'\48\159\158\188\10'or'\109\97'end)((0x20-27)==(30/0x5))..'\116\104',[(0xb35-1490)]=(function(e,_)return((122-0x75)==(648/0xd8)and'\48'..'\195'or e..((not'\20\95\69'and'\90'..'\180'or _)))or'\199\203\95'end),[(1033+-0x5f)]='\105\110'..(function(_,e)return(_ and'(4000/0x28)')and'\90\115\138\115\15'or'\115\101'end)((-0x27+44)==((6394-0xca0)/102))..'\114\116',[(0x860-1131)]='\117\110'..(function(_,e)return(_ and'(5800/(0x386a/249))')or'\112\97'or'\20\38\154'end)((545/0x6d)==(0xa6-135))..'\99\107',[(0x94f-1210)]='\115\101'..(function(_)return(_ and'((-95+0x257b)/95)')and'\110\112\99\104'or'\108\101'end)((0x221/109)==(1426/0x2e))..'\99\116',[(0x4741e/230)]='\116\111\110'..(function(_,e)return(_ and'(0x251c/95)')and'\117\109\98'or'\100\97\120\122'end)((0x122/58)==(0x4b-70))..'\101\114'},{[(0xaa-136)]=((getfenv))},((getfenv))()) end)()


