local buffer_writef64 = buffer.writef64;
local buffer_readu8 = buffer.readu8;
local bit32_bnot = bit32.bnot;
local bit32_band = bit32.band;
local bit32_bor = bit32.bor;
local bit32_lshift = bit32.lshift;
local bit32_rshift = bit32.rshift;
local buffer_create_ret = buffer.create(8);
local function GetGST()
    local time = time()
    buffer_writef64(buffer_create_ret, 0, time);
    local v1 = buffer_readu8(buffer_create_ret, 0);
    local v2 = buffer_readu8(buffer_create_ret, 1);
    local v3 = buffer_readu8(buffer_create_ret, 2);
    local v4 = buffer_readu8(buffer_create_ret, 3);
    local v5 = buffer_readu8(buffer_create_ret, 4);
    local v6 = buffer_readu8(buffer_create_ret, 5);
    local v7 = buffer_readu8(buffer_create_ret, 6);
    local v8 = buffer_readu8(buffer_create_ret, 7);
    local v9 = bit32_bnot(v1);
    local v10 = bit32_bnot(v2);
    local v11 = bit32_bor(bit32_lshift(bit32_band(v3, 51), 2), (bit32_rshift(bit32_band(v3, 204), 2)));
    local v12 = bit32_bor(bit32_rshift(bit32_band(v4, 240), 4), (bit32_lshift(bit32_band(v4, 15), 4)));
    local v13 = bit32_bor(bit32_rshift(bit32_band(v5, 240), 4), (bit32_lshift(bit32_band(v5, 15), 4)));
    local v14 = bit32_bor(bit32_rshift(bit32_band(v13, 204), 2), (bit32_lshift(bit32_band(v13, 51), 2)));
    local v15 = bit32_bor(bit32_rshift(bit32_band(v14, 170), 1), (bit32_lshift(bit32_band(v14, 85), 1)));
    local v16 = bit32_bnot(v6);
    local v17 = bit32_bnot(v7);
    local v19 = bit32_bor(bit32_rshift(bit32_band(v8, 240), 4), (bit32_lshift(bit32_band(v8, 15), 4)));
    local v20 = bit32_bor(bit32_rshift(bit32_band(v19, 204), 2), (bit32_lshift(bit32_band(v19, 51), 2)));
    local v21 = bit32_bor(bit32_rshift(bit32_band(v20, 170), 1), (bit32_lshift(bit32_band(v20, 85), 1)));
    local v22 = bit32_band(255, v9);
    local v23 = bit32_band(255, v10);
    local v24 = bit32_band(255, v16);
    local v25 = bit32_bor(v23, bit32_lshift(bit32_band(255, v17), 8), bit32_lshift(v22, 16), (bit32_lshift(v12, 24)));
    local v26 = bit32_bor(v21, bit32_lshift(v24, 8), bit32_lshift(v11, 16), (bit32_lshift(v15, 24)));
    return { v25, v26, (bit32_bnot((bit32_bor(bit32_lshift(v25, 8), (bit32_rshift(v26, 16)))))) };
end;
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
            if not GetKnife(MyChar) then task.wait(0.5) end
            task.wait()
            continue
        end
        local TargetChar = Target.Character
        local TargetRoot = TargetChar:FindFirstChild("HumanoidRootPart")
        local TargetHead = TargetChar:FindFirstChild("Head")
        if TargetChar:FindFirstChildOfClass("ForceField") then break end
        if TargetRoot and TargetHead and Root then
            if Humanoid.Sit then Humanoid.Sit = false end
            Root.CFrame = TargetRoot.CFrame - Vector3.new(0,5,0)
            Root.Velocity = Vector3.zero 
            if Knife.Parent == Backpack then Humanoid:EquipTool(Knife) end
            if (Root.Position - TargetRoot.Position).Magnitude <= 37 then
                local Direction = (TargetHead.Position - Root.Position).Unit
                RemoteEvent:FireServer(19, Knife, GetGST(), TargetHead, Direction)
            end
        end
        task.wait()
    end
end
serverHop()
