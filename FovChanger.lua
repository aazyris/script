-- FOV Changer GUI
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Create the GUI
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "FovChangerGui"
fovGui.ResetOnSpawn = false
fovGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
fovGui.Parent = game:GetService("CoreGui")

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = fovGui

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
titleText.Text = "FOV Changer"
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

-- Create FOV slider
local fovSlider = Instance.new("Frame")
fovSlider.Name = "FovSlider"
fovSlider.Size = UDim2.new(0.8, 0, 0, 20)
fovSlider.Position = UDim2.new(0.1, 0, 0.4, 0)
fovSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovSlider.BorderSizePixel = 0
fovSlider.Parent = mainFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0.1, 0, 1.5, 0)
sliderButton.Position = UDim2.new(0.5, 0, -0.25, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = fovSlider

-- FOV value label
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.8, 0, 0, 20)
fovLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 70"
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.TextSize = 14
fovLabel.Font = Enum.Font.Code
fovLabel.Parent = mainFrame

-- Reset button
local resetButton = Instance.new("TextButton")
resetButton.Size = UDim2.new(0.8, 0, 0, 30)
resetButton.Position = UDim2.new(0.1, 0, 0.75, 0)
resetButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
resetButton.BorderSizePixel = 0
resetButton.Text = "Reset FOV"
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
local defaultFOV = camera.FieldOfView
local function updateFOV(input)
    local relativeX = math.clamp((input.Position.X - fovSlider.AbsolutePosition.X) / fovSlider.AbsoluteSize.X, 0, 1)
    sliderButton.Position = UDim2.new(relativeX, 0, -0.25, 0)
    local fov = math.floor(30 + relativeX * 90) -- FOV range: 30-120
    fovLabel.Text = "FOV: " .. fov
    camera.FieldOfView = fov
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
        updateFOV(input)
    end
end)

-- Reset button functionality
resetButton.MouseButton1Click:Connect(function()
    camera.FieldOfView = defaultFOV
    local relativeX = (defaultFOV - 30) / 90
    sliderButton.Position = UDim2.new(relativeX, 0, -0.25, 0)
    fovLabel.Text = "FOV: " .. defaultFOV
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        camera.FieldOfView = defaultFOV
        fovGui:Destroy()
    end)
end)

-- Animate opening
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 300, 0, 200),
    Position = UDim2.new(0.5, -150, 0.5, -100)
})
openTween:Play() 