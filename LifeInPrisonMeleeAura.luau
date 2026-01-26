local Services = setmetatable({}, {
	__index = function(Self, Name)
		Self[Name] = game:GetService(Name)
		return Self[Name]
	end
})

local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local RunService = Services.RunService
local LocalPlayer = Players.LocalPlayer

local RemoteEvent = ReplicatedStorage.Events.RemoteEvent

local Melees = {
	{Name = "Knife", Code = 16},
	{Name = "Hammer", Code = 16},
	{Name = "Screwdriver", Code = 16},
	{Name = "Baton", Code = 16},
	{Name = "Punch", Code = 33}
}

RunService.Heartbeat:Connect(function()
	local MyChar = LocalPlayer.Character
	if not MyChar then return end
	
	local Root = MyChar:FindFirstChild("HumanoidRootPart")
	if not Root then return end
	
	local CurrentMelee, CurrentTool
	
	for _, Melee in Melees do
		if Melee.Name == "Punch" then
			local HasTool = false
			for _, Other in Melees do
				if Other.Name ~= "Punch" and MyChar:FindFirstChild(Other.Name) then
					HasTool = true
					break
				end
			end
			if not HasTool then
				CurrentMelee = Melee
				break
			end
		else
			local Tool = MyChar:FindFirstChild(Melee.Name)
			if Tool and Tool:IsA("Tool") then
				CurrentMelee = Melee
				CurrentTool = Tool
				break
			end
		end
	end
	
	if not CurrentMelee then return end
	
	for _, Player in Players:GetPlayers() do
		if Player ~= LocalPlayer then
			local Character = Player.Character
			if Character then
				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local Root2 = Character:FindFirstChild("HumanoidRootPart")
				local Head = Character:FindFirstChild("Head")
				
				if Humanoid and Humanoid.Health > 0 and Root2 and Head and (Root.Position - Root2.Position).Magnitude <= 17 then
					if CurrentMelee.Name == "Punch" then
						RemoteEvent:FireServer(CurrentMelee.Code, Head)
					elseif CurrentTool then
						local Direction = (Head.Position - Root.Position).Unit
						RemoteEvent:FireServer(CurrentMelee.Code, CurrentTool, Head, Direction)
					end
				end
			end
		end
	end
end)

warn("ok")
