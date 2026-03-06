local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local function serverHop()
    local api = `https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true`
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(api))
    end)
    if success and result and result.data then
        for _, v in result.data do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/rex-rbx/Games/refs/heads/main/LifeInPrisonShallSuffer.luau"))()]])
                task.wait(0.22)
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, lp)
                break
            end
        end
    end
end
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = workspace
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	Players.PlayerAdded:Wait()
	LocalPlayer = Players.LocalPlayer
end
local RemoteEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RemoteEvent")
RemoteEvent:FireServer(1, game:GetService("Teams"):WaitForChild("Prisoners"))
task.wait(1.5)
local Pickups = Workspace.pickups
local function GetKnife(MyChar)
	local Root = MyChar:FindFirstChild("HumanoidRootPart")
	if not Root then return false end
	for _, Pickup in Pickups:GetChildren() do
		if Pickup.Name == "Knife" then
			local MeshPart = Pickup:FindFirstChild("Meshes/knife1")
			if MeshPart and MeshPart:IsA("BasePart") and MeshPart.Parent then
				Root.CFrame = CFrame.new(MeshPart.Position)
				RemoteEvent:FireServer(12, Pickup)
				return true
			end
		end
	end
	return false
end
local Victims = Players:GetPlayers()
for _, Target in ipairs(Victims) do
	if Target == LocalPlayer then continue end
	if not Target.Character or not Target.Character:FindFirstChild("Humanoid") or Target.Character.Humanoid.Health <= 0 then
		continue
	end
	while Target.Parent and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 do
		local MyChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		if not MyChar or not MyChar:FindFirstChild("Humanoid") or MyChar.Humanoid.Health <= 0 then
			break
        end
		local Humanoid = MyChar.Humanoid
		local Root = MyChar:FindFirstChild("HumanoidRootPart")
		local Backpack = LocalPlayer:FindFirstChild("Backpack")
		local Knife = (MyChar:FindFirstChild("Knife")) or (Backpack and Backpack:FindFirstChild("Knife"))
		if not Knife then
			if not GetKnife(MyChar) then
				task.wait(0.1)
			end
			task.wait()
			continue
        end
		local TargetChar = Target.Character
		local TargetRoot = TargetChar:FindFirstChild("HumanoidRootPart")
		local TargetHead = TargetChar:FindFirstChild("Head")
		local ForceField = TargetChar:FindFirstChildOfClass("ForceField")
		if ForceField then break end
		if TargetRoot and TargetHead and Root then
			if Humanoid.Sit then Humanoid.Sit = false end
			Root.CFrame = TargetRoot.CFrame
			Root.Velocity = Vector3.zero 
			local MyTeam = LocalPlayer.Team
			local TargetTeam = Target.Team
			local IsPolice = MyTeam and MyTeam.Name == "Police"
			local TargetIsPolice = TargetTeam and TargetTeam.Name == "Police"
			if IsPolice and TargetIsPolice then
				if Knife.Parent == MyChar then Humanoid:UnequipTools() end
				if (Root.Position - TargetRoot.Position).Magnitude <= 17 then
					RemoteEvent:FireServer(33, TargetHead)
				end
			else
				if Knife.Parent == Backpack then Humanoid:EquipTool(Knife) end
				if (Root.Position - TargetRoot.Position).Magnitude <= 37 then
					local Direction = (TargetHead.Position - Root.Position).Unit
					RemoteEvent:FireServer(16, Knife, TargetHead, Direction)
				end
			end
        end
		task.wait()
	end
end
serverHop()
