local function GetGST(timestamp: number?)
    local t = timestamp or time()
    local b = buffer.create(8)
    buffer.writef64(b, 0, t)
    local b0 = buffer.readu8(b, 0)
    local b1 = buffer.readu8(b, 1)
    local b2 = buffer.readu8(b, 2)
    local b3 = buffer.readu8(b, 3)
    local b4 = buffer.readu8(b, 4)
    local b5 = buffer.readu8(b, 5)
    local b6 = buffer.readu8(b, 6)
    local b7 = buffer.readu8(b, 7)
    local nb0 = bit32.bnot(b0)
    local nb1 = bit32.bnot(b1)
    local v11 = bit32.bor(bit32.lshift(bit32.band(b2, 51), 2), (bit32.rshift(bit32.band(b2, 204), 2)))
    local v12 = bit32.bor(bit32.rshift(bit32.band(b3, 240), 4), (bit32.lshift(bit32.band(b3, 15), 4)))
    local v13 = bit32.bor(bit32.rshift(bit32.band(b4, 240), 4), (bit32.lshift(bit32.band(b4, 15), 4)))
    local v14 = bit32.bor(bit32.rshift(bit32.band(v13, 204), 2), (bit32.lshift(bit32.band(v13, 51), 2)))
    local v15 = bit32.bor(bit32.rshift(bit32.band(v14, 170), 1), (bit32.lshift(bit32.band(v14, 85), 1)))
    local nb5 = bit32.bnot(b5)
    local nb6 = bit32.bnot(b6)
    local v18 = bit32.bor(bit32.rshift(bit32.band(b7, 240), 4), (bit32.lshift(bit32.band(b7, 15), 4)))
    local v19 = bit32.bor(bit32.rshift(bit32.band(v18, 204), 2), (bit32.lshift(bit32.band(v18, 51), 2)))
    local v20 = bit32.bor(bit32.rshift(bit32.band(v19, 170), 1), (bit32.lshift(bit32.band(v19, 85), 1)))
    local m0 = bit32.band(255, nb0)
    local m1 = bit32.band(255, nb1)
    local m5 = bit32.band(255, nb5)
    local res1 = bit32.bor(m1, bit32.lshift(bit32.band(255, nb6), 8), bit32.lshift(m0, 16), (bit32.lshift(v12, 24)))
    local res2 = bit32.bor(v20, bit32.lshift(m5, 8), bit32.lshift(v11, 16), (bit32.lshift(v15, 24)))
    local res3 = bit32.bnot((bit32.bor(bit32.lshift(res1, 8), (bit32.rshift(res2, 16)))))
    return { res1, res2, res3 }
end
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Workspace = workspace
local scriptUrl = "https://raw.githubusercontent.com/rex-rbx/Games/refs/heads/main/LifeInPrisonShallSuffer.luau"
local function serverHop()
    local api = `https://games.roblox.com/v1/games/{game.PlaceId}/servers/Public?sortOrder=2&limit=100&excludeFullGames=true`
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(api))
    end)
    if success and result and result.data then
        for _, v in pairs(result.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                queue_on_teleport(`repeat task.wait() until game:IsLoaded(); loadstring(game:HttpGet("{scriptUrl}"))()`)
                local teleSuccess = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                end)
                if teleSuccess then return end
            end
        end
    end
    task.wait(5)
    serverHop()
end
repeat task.wait() until game:IsLoaded()
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end
local RemoteEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("RemoteEvent")
RemoteEvent:FireServer(1, Teams:WaitForChild("Prisoners"))
task.wait(1.2)
local Pickups = Workspace:WaitForChild("pickups")
local function GetKnife(MyChar)
    local Root = MyChar:FindFirstChild("HumanoidRootPart")
    if not Root then return false end
    for _, Pickup in Pickups:GetChildren() do
        if Pickup.Name == "Knife" then
            local MeshPart = Pickup:FindFirstChild("Meshes/knife1")
            if MeshPart and MeshPart:IsA("BasePart") then
                Root.CFrame = CFrame.new(MeshPart.Position)
                RemoteEvent:FireServer(12, Pickup)
                return true
            end
        end
    end
    return false
end
task.delay(210, serverHop)
task.spawn(function()
    LocalPlayer.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(serverHop)
    end)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Died:Connect(serverHop)
    end
end)
local Victims = Players:GetPlayers()
for _, Target in Victims do
    if Target == LocalPlayer then continue end
    while Target.Parent and Target.Character and Target.Character:FindFirstChild("Humanoid") and Target.Character.Humanoid.Health > 0 do
        local MyChar = LocalPlayer.Character
        if not MyChar or not MyChar:FindFirstChild("Humanoid") or MyChar.Humanoid.Health <= 0 then break end
        local Humanoid = MyChar.Humanoid
        local Root = MyChar:FindFirstChild("HumanoidRootPart")
        local Backpack = LocalPlayer:FindFirstChild("Backpack")
        local Knife = MyChar:FindFirstChild("Knife") or (Backpack and Backpack:FindFirstChild("Knife"))
        if not Knife then
            if not GetKnife(MyChar) then task.wait(0.2) end
            task.wait()
            continue
        end
        local TargetChar = Target.Character
        local TargetRoot = TargetChar:FindFirstChild("HumanoidRootPart")
        local TargetHead = TargetChar:FindFirstChild("Head")
        if TargetChar:FindFirstChildOfClass("ForceField") then break end
        if TargetRoot and TargetHead and Root then
            if Humanoid.Sit then Humanoid.Sit = false end
            Root.CFrame = TargetRoot.CFrame
            Root.Velocity = Vector3.zero 
            if Knife.Parent == Backpack then Humanoid:EquipTool(Knife) end
            if (Root.Position - TargetRoot.Position).Magnitude <= 37 then
                local Direction = (TargetHead.Position - Root.Position).Unit
                RemoteEvent:FireServer(16, Knife, GetGST(), TargetHead, Direction)
            end
        end
        task.wait()
    end
end
serverHop()
