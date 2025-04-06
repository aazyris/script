-- Click Teleport GUI
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create the GUI
local teleportGui = Instance.new("ScreenGui")
teleportGui.Name = "ClickTeleportGui"
teleportGui.ResetOnSpawn = false
teleportGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
teleportGui.Parent = game:GetService("CoreGui")

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = teleportGui

-- Create title bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Add title text
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 10, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Click Teleport"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 16
titleText.Font = Enum.Font.Code
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Parent = titleBar

-- Add close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.Code
closeButton.Parent = titleBar

-- Create toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.8, 0, 0, 30)
toggleButton.Position = UDim2.new(0.1, 0, 0.3, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Enable Click Teleport"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.Code
toggleButton.Parent = mainFrame

-- Create key bind button
local keyBindButton = Instance.new("TextButton")
keyBindButton.Size = UDim2.new(0.8, 0, 0, 30)
keyBindButton.Position = UDim2.new(0.1, 0, 0.5, 0)
keyBindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
keyBindButton.BorderSizePixel = 0
keyBindButton.Text = "Change Key (LeftControl)"
keyBindButton.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBindButton.TextSize = 14
keyBindButton.Font = Enum.Font.Code
keyBindButton.Parent = mainFrame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 20)
statusLabel.Position = UDim2.new(0.1, 0, 0.7, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.Code
statusLabel.Parent = mainFrame

-- Make frame draggable
local dragging = false
local dragStart = nil
local startPos = nil

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Click Teleport functionality
local teleportEnabled = false
local currentKey = Enum.KeyCode.LeftControl
local changingKey = false
local connection

local function updateKeyText()
    keyBindButton.Text = "Change Key (" .. currentKey.Name .. ")"
end

local function enableClickTeleport()
    if connection then connection:Disconnect() end
    
    connection = UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and teleportEnabled then
            local mouse = player:GetMouse()
            if UserInputService:IsKeyDown(currentKey) and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
            end
        end
    end)
end

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    teleportEnabled = not teleportEnabled
    
    if teleportEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        statusLabel.Text = "Status: Enabled"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        enableClickTeleport()
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        statusLabel.Text = "Status: Disabled"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        if connection then
            connection:Disconnect()
            connection = nil
        end
    end
end)

-- Key bind button functionality
keyBindButton.MouseButton1Click:Connect(function()
    if not changingKey then
        changingKey = true
        keyBindButton.Text = "Press any key..."
        keyBindButton.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
        
        local keyConnection
        keyConnection = UserInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                currentKey = input.KeyCode
                changingKey = false
                keyBindButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                updateKeyText()
                keyConnection:Disconnect()
            end
        end)
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        if connection then
            connection:Disconnect()
        end
        teleportGui:Destroy()
    end)
end)

-- Animate opening
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 300, 0, 200),
    Position = UDim2.new(0.5, -150, 0.5, -100)
})
openTween:Play() 