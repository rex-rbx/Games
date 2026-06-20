local RandomUTF8String = function(Length)
    local b = buffer.create(Length)
    local offset = 0
    local Ranges = {
        {0x00A1, 0x00AC}, {0x00AE, 0x00FF},
        {0x0100, 0x052F},
        {0x0530, 0x07BF},
        {0x0900, 0x0DFF},
        {0x0E00, 0x10FF},
        {0x1100, 0x13FF},
        {0x1400, 0x16FF},
        {0xFF01, 0xFF5E},
        {0x00A1, 0x00FF},
        {0x2000, 0x2BFF},
        {0x4E00, 0x9FFF},
        {0x1F600, 0x1F64F},
        {0xA000, 0xA48C},
        {0x3400, 0x4DBF},
        {0xAC00, 0xD7AF},
        {0xF900, 0xFAFF},
        {0x1F300, 0x1F5FF},
        {0x1F680, 0x1F6FF},
        {0x1F900, 0x1F9FF},
    }
    local ExcludeCodepoints = {
        0x000A,
        0x000D,
        0x000C,
        0x0085,
        0x2028,
        0x2029,
        0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0006, 0x0007,
        0x0008, 0x0009,
        0x000B,
        0x000E, 0x000F, 0x0010, 0x0011, 0x0012, 0x0013, 0x0014, 0x0015,
        0x0016, 0x0017, 0x0018, 0x0019, 0x001A, 0x001B, 0x001C, 0x001D,
        0x001E, 0x001F, 0x007F,
        0x200E, 0x200F, 0x202A, 0x202B, 0x202C, 0x202D, 0x202E,
        0x200B, 0x200C, 0x200D, 0xFEFF,
        0xD800, 0xDBFF, 0xDC00, 0xDFFF,
    }
    local ExcludeSet = {}
    for _, cp in ipairs(ExcludeCodepoints) do
        ExcludeSet[cp] = true
    end
    local function isAllowedCodepoint(cp)
        return not ExcludeSet[cp]
    end
    while offset < Length do
        local selectedRange = Ranges[math.random(1, #Ranges)]
        local cp = math.random(selectedRange[1], selectedRange[2])
        while not isAllowedCodepoint(cp) do
            cp = math.random(selectedRange[1], selectedRange[2])
        end
        local ok, str = pcall(utf8.char, cp)
        if not ok then
            str = "?"
        end
        local charLen = #str
        if offset + charLen <= Length then
            for i = 1, charLen do
                buffer.writeu8(b, offset, string.byte(str, i))
                offset = offset + 1
            end
        else
            while offset < Length do
                buffer.writeu8(b, offset, math.random(33, 126))
                offset = offset + 1
            end
        end
    end
    return buffer.tostring(b)
end
local fovRadius = 300
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RepStore = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
while not LocalPlayer do
	Players.PlayerAdded:Wait()
	LocalPlayer = Players.LocalPlayer
end
local Camera = workspace.CurrentCamera
local function GetClosestTarget(raycastOrigin)
    local targetHead = nil
    local minDistance = fovRadius
    local mid = UIS:GetMouseLocation()
    if not LocalPlayer or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return nil
    end
    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character.Head
            if head and humanoid and humanoid.Health > 0 then
                local screenpos, onscreen = Camera:WorldToViewportPoint(head.Position)
                if onscreen then
                    local dist = (Vector2.new(screenpos.X, screenpos.Y) - mid).Magnitude
                    if dist < minDistance then
                        local isVisible = true
                        local rayDirection = (head.Position - raycastOrigin)
                        local raycastParams = RaycastParams.new()
                        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                        raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                        local raycastResult = workspace:Raycast(raycastOrigin, rayDirection.Unit * rayDirection.Magnitude, raycastParams)
                        if raycastResult and not raycastResult.Instance:IsDescendantOf(player.Character) then
                            isVisible = false
                        end
                        if isVisible then
                            targetHead = head
                            minDistance = dist
                        end
                    end
                end
            end
        end
    end
    return targetHead
end
local BH = require(RepStore:WaitForChild("ModuleScripts", math.huge):WaitForChild("GunModules", math.huge):WaitForChild("BulletHandler", math.huge))
local OldFire = BH.Fire
BH.Fire = (newcclosure or function(f) return f end)(function(tbl)
	local ye = GetClosestTarget(tbl.Origin)
	if ye then
		tbl.Direction = (ye.Position - tbl.Origin).Unit
	end
	return OldFire(tbl)
end)
if DrawingImmediate then
	DrawingImmediate.GetPaint(1):Connect(function()
		DrawingImmediate.Circle(UIS:GetMouseLocation(), fovRadius, Color3.new(1, 0, 0), 1, 0, 1)
	end)
elseif Drawing then
	local Circle = Drawing.new("Circle")
	Circle.Position = UIS:GetMouseLocation()
	Circle.Radius = fovRadius
	Circle.Color = Color3.new(1, 0, 0)
	RunService.RenderStepped:Connect(function()
		Circle.Position = UIS:GetMouseLocation()
	end)
else
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = RandomUTF8String(64)
	local FovCircle = Instance.new("Frame")
	local CircleCorner = Instance.new("UICorner")
	local CircleStroke = Instance.new("UIStroke")
	pcall(function()
		ScreenGui.Parent = gethui()
	end)
	if not ScreenGui.Parent then
		pcall(function()
			ScreenGui.Parent = game:GetService("CoreGui")
		end)
	end
	if not ScreenGui.Parent then
		pcall(function()
			ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui", math.huge)
		end)
	end
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 2^31-1
	FovCircle.Parent = ScreenGui
	FovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	FovCircle.BackgroundTransparency = 0
	CircleCorner.CornerRadius = UDim.new(1, 0)
	CircleCorner.Parent = FovCircle
	CircleStroke.Color = Color3.fromRGB(255, 255, 255)
	CircleStroke.Thickness = 1
	CircleStroke.Transparency = 0.5
	CircleStroke.Parent = FovCircle
	RunService.RenderStepped:Connect(function()
		local ScreenCenter = UIS:GetMouseLocation()
		FovCircle.Position = UDim2.new(0, ScreenCenter.X, 0, ScreenCenter.Y)
		FovCircle.Size = UDim2.new(0, fovRadius * 2, 0, fovRadius * 2)
	end)
end
