local GetService = setmetatable({}, {
	__index = function(Table, Index)
		Table[Index] = game:GetService(Index)
		return Table[Index]
	end
})

local LocalPlayer = GetService.Players.LocalPlayer
local RemoteEvent = GetService.ReplicatedStorage:FindFirstChild("Events"):FindFirstChild("RemoteEvent")
local Teams = GetService.Teams
local Camera = GetService.Workspace.CurrentCamera

local MyChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local OriginalTeam = LocalPlayer.Team
local OriginalPosition = MyChar:WaitForChild("HumanoidRootPart").CFrame
local CameraPosition = Camera.CFrame

RemoteEvent:FireServer(1, Teams:FindFirstChild("Neutral"))
task.wait(.03)

RemoteEvent:FireServer(1, OriginalTeam == Teams:FindFirstChild("Police") and Teams:FindFirstChild("Police") or Teams:FindFirstChild("Prisoners"))

local NewChar = LocalPlayer.CharacterAdded:Wait()
task.wait(.03)

local HumanoidRootPart = NewChar:WaitForChild("HumanoidRootPart")
local Humanoid = NewChar:WaitForChild("Humanoid")
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
HumanoidRootPart.CFrame = OriginalPosition
Camera.CFrame = CameraPosition

if OriginalTeam == Teams:FindFirstChild("Criminals") then
	task.wait(.03)
	HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-421, 1069, 28))
	task.wait(.03)
	HumanoidRootPart.CFrame = OriginalPosition
	Camera.CFrame = CameraPosition
end

local HumanoidCheck = MyChar:FindFirstChildOfClass("Humanoid")
if HumanoidCheck then
	HumanoidCheck.Died:Connect(function()
		local CurrentTeam = LocalPlayer.Team
		local CurrentPosition = MyChar:WaitForChild("HumanoidRootPart").CFrame
		local CurrentCamera = Camera.CFrame
		
		RemoteEvent:FireServer(1, Teams:FindFirstChild("Neutral"))
		task.wait(.03)
		RemoteEvent:FireServer(1, CurrentTeam == Teams:FindFirstChild("Police") and Teams:FindFirstChild("Police") or Teams:FindFirstChild("Prisoners"))
		
		local RespawnedChar = LocalPlayer.CharacterAdded:Wait()
		task.wait(.03)
		
		local RespawnedHRP = RespawnedChar:WaitForChild("HumanoidRootPart")
		local RespawnedHum = RespawnedChar:WaitForChild("Humanoid")
		RespawnedHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		RespawnedHum:ChangeState(Enum.HumanoidStateType.GettingUp)
		RespawnedHRP.CFrame = CurrentPosition
		Camera.CFrame = CurrentCamera
		
		if CurrentTeam == Teams:FindFirstChild("Criminals") then
			task.wait(.03)
			RespawnedHRP.CFrame = CFrame.new(Vector3.new(-421, 1069, 28))
			task.wait(.03)
			RespawnedHRP.CFrame = CurrentPosition
			Camera.CFrame = CurrentCamera
		end
	end)
end

local AnimCheck = MyChar:FindFirstChildOfClass("Humanoid")
if AnimCheck then
	AnimCheck.AnimationPlayed:Connect(function(AnimationTrack)
		if AnimationTrack.Animation.AnimationId == "rbxassetid://98171520163530" then
			local CurrentTeam = LocalPlayer.Team
			local CurrentPosition = MyChar:WaitForChild("HumanoidRootPart").CFrame
			local CurrentCamera = Camera.CFrame
			
			RemoteEvent:FireServer(1, Teams:FindFirstChild("Neutral"))
			task.wait(.03)
			RemoteEvent:FireServer(1, CurrentTeam == Teams:FindFirstChild("Police") and Teams:FindFirstChild("Police") or Teams:FindFirstChild("Prisoners"))
			
			local RespawnedChar = LocalPlayer.CharacterAdded:Wait()
			task.wait(.03)
			
			local RespawnedHRP = RespawnedChar:WaitForChild("HumanoidRootPart")
			local RespawnedHum = RespawnedChar:WaitForChild("Humanoid")
			RespawnedHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			RespawnedHum:ChangeState(Enum.HumanoidStateType.GettingUp)
			RespawnedHRP.CFrame = CurrentPosition
			Camera.CFrame = CurrentCamera
			
			if CurrentTeam == Teams:FindFirstChild("Criminals") then
				task.wait(.03)
				RespawnedHRP.CFrame = CFrame.new(Vector3.new(-421, 1069, 28))
				task.wait(.03)
				RespawnedHRP.CFrame = CurrentPosition
				Camera.CFrame = CurrentCamera
			end
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(function(Character)
	MyChar = Character
	
	local CharHumanoid = Character:WaitForChild("Humanoid")
	if CharHumanoid then
		CharHumanoid.Died:Connect(function()
			local CurrentTeam = LocalPlayer.Team
			local CurrentPosition = Character:WaitForChild("HumanoidRootPart").CFrame
			local CurrentCamera = Camera.CFrame
			
			RemoteEvent:FireServer(1, Teams:FindFirstChild("Neutral"))
			task.wait(.03)
			RemoteEvent:FireServer(1, CurrentTeam == Teams:FindFirstChild("Police") and Teams:FindFirstChild("Police") or Teams:FindFirstChild("Prisoners"))
			
			local RespawnedChar = LocalPlayer.CharacterAdded:Wait()
			task.wait(.03)
			
			local RespawnedHRP = RespawnedChar:WaitForChild("HumanoidRootPart")
			local RespawnedHum = RespawnedChar:WaitForChild("Humanoid")
			RespawnedHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			RespawnedHum:ChangeState(Enum.HumanoidStateType.GettingUp)
			RespawnedHRP.CFrame = CurrentPosition
			Camera.CFrame = CurrentCamera
		end)
		
		CharHumanoid.AnimationPlayed:Connect(function(AnimationTrack)
			if AnimationTrack.Animation.AnimationId == "rbxassetid://98171520163530" then
				local CurrentTeam = LocalPlayer.Team
				local CurrentPosition = Character:WaitForChild("HumanoidRootPart").CFrame
				local CurrentCamera = Camera.CFrame
				
				RemoteEvent:FireServer(1, Teams:FindFirstChild("Neutral"))
				task.wait(.03)
				RemoteEvent:FireServer(1, CurrentTeam == Teams:FindFirstChild("Police") and Teams:FindFirstChild("Police") or Teams:FindFirstChild("Prisoners"))
				
				local RespawnedChar = LocalPlayer.CharacterAdded:Wait()
				task.wait(.03)
				
				local RespawnedHRP = RespawnedChar:WaitForChild("HumanoidRootPart")
				local RespawnedHum = RespawnedChar:WaitForChild("Humanoid")
				RespawnedHum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				RespawnedHum:ChangeState(Enum.HumanoidStateType.GettingUp)
				RespawnedHRP.CFrame = CurrentPosition
				Camera.CFrame = CurrentCamera
			end
		end)
	end
end)

warn("ok")
