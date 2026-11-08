local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local power = 25
local dummy, humanoid, touchConnection
local touchReady, swingReady = true, true

local function make(className, props, parent)
    local object = Instance.new(className)
    for key, value in pairs(props) do object[key] = value end
    object.Parent = parent
    return object
end

local gui = make("ScreenGui", {Name = "ClientDummyTesterGui", ResetOnSpawn = false}, player:WaitForChild("PlayerGui"))
local panel = make("Frame", {Position = UDim2.fromOffset(18, 18), Size = UDim2.fromOffset(250, 150), BackgroundColor3 = Color3.fromRGB(28, 33, 43), BorderSizePixel = 0}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, panel)
make("TextLabel", {Position = UDim2.fromOffset(12, 8), Size = UDim2.fromOffset(226, 24), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = "CLIENT DUMMY TESTER", TextColor3 = Color3.new(1, 1, 1), TextSize = 15, TextXAlignment = Enum.TextXAlignment.Left}, panel)
local status = make("TextLabel", {Position = UDim2.fromOffset(12, 35), Size = UDim2.fromOffset(226, 20), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "Dummy not spawned", TextColor3 = Color3.fromRGB(180, 190, 205), TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, panel)
local powerBox = make("TextBox", {Position = UDim2.fromOffset(12, 65), Size = UDim2.fromOffset(90, 32), BackgroundColor3 = Color3.fromRGB(48, 57, 72), BorderSizePixel = 0, ClearTextOnFocus = false, Font = Enum.Font.Gotham, Text = "25", TextColor3 = Color3.new(1, 1, 1), TextSize = 14}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 5)}, powerBox)
local spawnButton = make("TextButton", {Position = UDim2.fromOffset(112, 65), Size = UDim2.fromOffset(126, 32), BackgroundColor3 = Color3.fromRGB(48, 135, 225), BorderSizePixel = 0, Font = Enum.Font.GothamBold, Text = "SPAWN DUMMY", TextColor3 = Color3.new(1, 1, 1), TextSize = 12}, panel)
make("UICorner", {CornerRadius = UDim.new(0, 5)}, spawnButton)
make("TextLabel", {Position = UDim2.fromOffset(12, 108), Size = UDim2.fromOffset(226, 32), BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "Set power (1-1000), equip Client Test Bat, click dummy. Touching also damages it.", TextColor3 = Color3.fromRGB(180, 190, 205), TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, panel)

local function readPower()
    power = math.clamp(math.floor(tonumber(powerBox.Text) or power), 1, 1000)
    powerBox.Text = tostring(power)
end
powerBox.FocusLost:Connect(readPower)

local function clearDummy()
    if touchConnection then touchConnection:Disconnect(); touchConnection = nil end
    if dummy then dummy:Destroy(); dummy = nil; humanoid = nil end
end

local function spawnDummy()
    readPower()
    clearDummy()
    local character = player.Character
    local characterRoot = character and character:FindFirstChild("HumanoidRootPart")
    if not characterRoot then status.Text = "Character is not ready"; return end
    local origin = characterRoot.Position + characterRoot.CFrame.LookVector * 7 + Vector3.new(0, 3, 0)
    dummy = make("Model", {Name = "ClientTestDummy"}, workspace)
    humanoid = make("Humanoid", {MaxHealth = 100, Health = 100, DisplayName = "Test Dummy", BreakJointsOnDeath = false}, dummy)
    local function part(name, size, offset, color)
        return make("Part", {Name = name, Size = size, Position = origin + offset, Color = color, Material = Enum.Material.SmoothPlastic, CanTouch = true, CanCollide = true, TopSurface = Enum.SurfaceType.Smooth, BottomSurface = Enum.SurfaceType.Smooth}, dummy)
    end
    local torso = part("Torso", Vector3.new(2, 2, 1), Vector3.zero, Color3.fromRGB(55, 125, 195))
    local head = part("Head", Vector3.new(2, 1, 1), Vector3.new(0, 1.6, 0), Color3.fromRGB(255, 204, 153))
    local leftArm = part("Left Arm", Vector3.new(1, 2, 1), Vector3.new(-1.5, 0, 0), Color3.fromRGB(55, 125, 195))
    local rightArm = part("Right Arm", Vector3.new(1, 2, 1), Vector3.new(1.5, 0, 0), Color3.fromRGB(55, 125, 195))
    local leftLeg = part("Left Leg", Vector3.new(1, 2, 1), Vector3.new(-0.5, -2, 0), Color3.fromRGB(38, 54, 82))
    local rightLeg = part("Right Leg", Vector3.new(1, 2, 1), Vector3.new(0.5, -2, 0), Color3.fromRGB(38, 54, 82))
    for _, bodyPart in ipairs({head, leftArm, rightArm, leftLeg, rightLeg}) do
        make("WeldConstraint", {Part0 = torso, Part1 = bodyPart}, torso)
    end
    local root = make("Part", {Name = "HumanoidRootPart", Size = Vector3.new(2, 2, 1), Position = origin, Transparency = 1, CanCollide = false, CanTouch = false}, dummy)
    make("WeldConstraint", {Part0 = torso, Part1 = root}, torso)
    dummy.PrimaryPart = root
    local board = make("BillboardGui", {Adornee = head, Size = UDim2.fromOffset(140, 30), StudsOffset = Vector3.new(0, 1.8, 0), AlwaysOnTop = true}, dummy)
    local healthText = make("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextColor3 = Color3.new(1, 1, 1), TextStrokeTransparency = 0.3, TextSize = 14, Text = "100 / 100"}, board)
    humanoid.HealthChanged:Connect(function(value)
        healthText.Text = string.format("%d / 100", math.max(0, math.ceil(value)))
        if value <= 0 then status.Text = "Dummy defeated" end
    end)
    touchConnection = torso.Touched:Connect(function(hit)
        if touchReady and player.Character and hit:IsDescendantOf(player.Character) and humanoid and humanoid.Health > 0 then
            touchReady = false
            humanoid:TakeDamage(power)
            task.delay(0.35, function() touchReady = true end)
        end
    end)
    status.Text = "Dummy active: 100 health"
end

local backpack = player:WaitForChild("Backpack")
local tool = make("Tool", {Name = "Client Test Bat", RequiresHandle = true, CanBeDropped = false, ToolTip = "Click your spawned dummy to hit"}, backpack)
make("Part", {Name = "Handle", Size = Vector3.new(0.35, 3, 0.35), Color = Color3.fromRGB(190, 135, 72), Material = Enum.Material.Wood, CanCollide = false}, tool)
tool.Activated:Connect(function()
    if not swingReady then return end
    swingReady = false
    readPower()
    if dummy and humanoid and humanoid.Health > 0 and mouse.Target and mouse.Target:IsDescendantOf(dummy) then
        humanoid:TakeDamage(power)
        status.Text = "Hit for " .. power .. " damage"
    end
    task.delay(0.25, function() swingReady = true end)
end)
spawnButton.MouseButton1Click:Connect(spawnDummy)
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.F6 then spawnDummy() end
end)
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    clearDummy()
    status.Text = "Dummy not spawned"
end)
