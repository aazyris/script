-- Gravity Changer GUI
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- Create the GUI
local gravityGui = Instance.new("ScreenGui")
gravityGui.Name = "GravityChangerGui"
gravityGui.ResetOnSpawn = false
gravityGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gravityGui.Parent = game:GetService("CoreGui")

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gravityGui

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
titleText.Text = "Gravity Changer"
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

-- Create gravity slider
local gravitySlider = Instance.new("Frame")
gravitySlider.Name = "GravitySlider"
gravitySlider.Size = UDim2.new(0.8, 0, 0, 20)
gravitySlider.Position = UDim2.new(0.1, 0, 0.4, 0)
gravitySlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
gravitySlider.BorderSizePixel = 0
gravitySlider.Parent = mainFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0.1, 0, 1.5, 0)
sliderButton.Position = UDim2.new(0.5, 0, -0.25, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = gravitySlider

-- Gravity value label
local gravityLabel = Instance.new("TextLabel")
gravityLabel.Size = UDim2.new(0.8, 0, 0, 20)
gravityLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
gravityLabel.BackgroundTransparency = 1
gravityLabel.Text = "Gravity: 196.2"
gravityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
gravityLabel.TextSize = 14
gravityLabel.Font = Enum.Font.Code
gravityLabel.Parent = mainFrame

-- Reset button
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0.8, 0, 0, 30)
resetButton.Position = UDim2.new(0.1, 0, 0.75, 0)
resetButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
resetButton.BorderSizePixel = 0
resetButton.Text = "Reset Gravity"
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.TextSize = 14
resetButton.Font = Enum.Font.Code
resetButton.Parent = mainFrame

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

-- Slider functionality
local sliding = false
local defaultGravity = workspace.Gravity
local function updateGravity(input)
    local relativeX = math.clamp((input.Position.X - gravitySlider.AbsolutePosition.X) / gravitySlider.AbsoluteSize.X, 0, 1)
    sliderButton.Position = UDim2.new(relativeX, 0, -0.25, 0)
    local gravity = math.floor(relativeX * 500) -- Gravity range: 0-500
    gravityLabel.Text = "Gravity: " .. gravity
    workspace.Gravity = gravity
end

sliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        sliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and sliding then
        updateGravity(input)
    end
end)

-- Reset button functionality
resetButton.MouseButton1Click:Connect(function()
    workspace.Gravity = defaultGravity
    local relativeX = defaultGravity / 500
    sliderButton.Position = UDim2.new(relativeX, 0, -0.25, 0)
    gravityLabel.Text = "Gravity: " .. defaultGravity
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        workspace.Gravity = defaultGravity
        gravityGui:Destroy()
    end)
end)

-- Animate opening
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 300, 0, 200),
    Position = UDim2.new(0.5, -150, 0.5, -100)
})
openTween:Play() 