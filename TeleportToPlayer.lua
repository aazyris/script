-- Teleport to Player GUI
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Create the GUI
local teleportGui = Instance.new("ScreenGui")
teleportGui.Name = "TeleportGui"
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
titleText.Text = "Teleport to Player"
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

-- Create player list
local playerList = Instance.new("ScrollingFrame")
playerList.Name = "PlayerList"
playerList.Size = UDim2.new(0.8, 0, 0.6, 0)
playerList.Position = UDim2.new(0.1, 0, 0.2, 0)
playerList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 6
playerList.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
playerList.Parent = mainFrame

-- Create UIListLayout for player buttons
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.Name
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = playerList

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 20)
statusLabel.Position = UDim2.new(0.1, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Click a player to teleport"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
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

-- Function to create player button
local function createPlayerButton(plr)
    if plr == player then return end
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = plr.Name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 14
    button.Font = Enum.Font.Code
    button.Parent = playerList
    
    button.MouseButton1Click:Connect(function()
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            statusLabel.Text = "Teleporting to " .. plr.Name .. "..."
            statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            
            player.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
            
            task.wait(1)
            statusLabel.Text = "Click a player to teleport"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        else
            statusLabel.Text = "Failed to teleport to " .. plr.Name
            statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            
            task.wait(1)
            statusLabel.Text = "Click a player to teleport"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        end
    end)
    
    return button
end

-- Update player list
local function updatePlayerList()
    for _, child in pairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            createPlayerButton(plr)
        end
    end
    
    playerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end

-- Player events
Players.PlayerAdded:Connect(function(plr)
    createPlayerButton(plr)
    playerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

Players.PlayerRemoving:Connect(function(plr)
    for _, button in pairs(playerList:GetChildren()) do
        if button:IsA("TextButton") and button.Text == plr.Name then
            button:Destroy()
        end
    end
    playerList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        teleportGui:Destroy()
    end)
end)

-- Initial setup
updatePlayerList()

-- Animate opening
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 300, 0, 250),
    Position = UDim2.new(0.5, -150, 0.5, -125)
})
openTween:Play() 