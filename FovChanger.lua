-- Advanced FOV Changer GUI with smooth transitions and presets
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local player = Players.LocalPlayer

-- Create the GUI
local fovGui = Instance.new("ScreenGui")
fovGui.Name = "AdvancedFOVGui"
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
titleText.Text = "Advanced FOV"
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
fovSlider.Name = "FOVSlider"
fovSlider.Size = UDim2.new(0.8, 0, 0, 20)
fovSlider.Position = UDim2.new(0.1, 0, 0.3, 0)
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
fovLabel.Position = UDim2.new(0.1, 0, 0.4, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: 70°"
fovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fovLabel.TextSize = 14
fovLabel.Font = Enum.Font.Code
fovLabel.Parent = mainFrame

-- Create transition time slider
local transitionSlider = Instance.new("Frame")
transitionSlider.Name = "TransitionSlider"
transitionSlider.Size = UDim2.new(0.8, 0, 0, 20)
transitionSlider.Position = UDim2.new(0.1, 0, 0.55, 0)
transitionSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
transitionSlider.BorderSizePixel = 0
transitionSlider.Parent = mainFrame

local transitionButton = Instance.new("TextButton")
transitionButton.Size = UDim2.new(0.1, 0, 1.5, 0)
transitionButton.Position = UDim2.new(0.2, 0, -0.25, 0)
transitionButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
transitionButton.BorderSizePixel = 0
transitionButton.Text = ""
transitionButton.Parent = transitionSlider

-- Transition time label
local transitionLabel = Instance.new("TextLabel")
transitionLabel.Size = UDim2.new(0.8, 0, 0, 20)
transitionLabel.Position = UDim2.new(0.1, 0, 0.65, 0)
transitionLabel.BackgroundTransparency = 1
transitionLabel.Text = "Transition Time: 0.2s"
transitionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
transitionLabel.TextSize = 14
transitionLabel.Font = Enum.Font.Code
transitionLabel.Parent = mainFrame

-- Create preset buttons container
local presetsContainer = Instance.new("Frame")
presetsContainer.Name = "PresetsContainer"
presetsContainer.Size = UDim2.new(0.8, 0, 0.2, 0)
presetsContainer.Position = UDim2.new(0.1, 0, 0.75, 0)
presetsContainer.BackgroundTransparency = 1
presetsContainer.Parent = mainFrame

-- FOV presets
local presets = {
    {name = "Normal", fov = 70},
    {name = "Wide", fov = 90},
    {name = "Ultra Wide", fov = 110},
    {name = "Quake Pro", fov = 120}
}

-- Create preset buttons
for i, preset in ipairs(presets) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.23, 0, 0, 25)
    button.Position = UDim2.new(0.02 + (0.25 * (i-1)), 0, 0, 0)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    button.BorderSizePixel = 0
    button.Text = preset.name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Code
    button.Parent = presetsContainer
    
    button.MouseButton1Click:Connect(function()
        local transitionTime = tonumber(transitionLabel.Text:match("%d+%.?%d*"))
        local currentFOV = camera.FieldOfView
        
        local fovTween = TweenService:Create(camera, TweenInfo.new(transitionTime, Enum.EasingStyle.Quad), {
            FieldOfView = preset.fov
        })
        fovTween:Play()
        
        sliderButton.Position = UDim2.new((preset.fov - 30) / 90, 0, -0.25, 0)
        fovLabel.Text = "FOV: " .. preset.fov .. "°"
    end)
end

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

-- FOV slider functionality
local sliding = false

local function updateFOV(input)
    local relativeX = math.clamp((input.Position.X - fovSlider.AbsolutePosition.X) / fovSlider.AbsoluteSize.X, 0, 1)
    sliderButton.Position = UDim2.new(relativeX, 0, -0.25, 0)
    local newFOV = math.floor(30 + (relativeX * 90))
    fovLabel.Text = "FOV: " .. newFOV .. "°"
    
    local transitionTime = tonumber(transitionLabel.Text:match("%d+%.?%d*"))
    local currentFOV = camera.FieldOfView
    
    local fovTween = TweenService:Create(camera, TweenInfo.new(transitionTime, Enum.EasingStyle.Quad), {
        FieldOfView = newFOV
    })
    fovTween:Play()
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

-- Transition slider functionality
local transitionSliding = false

local function updateTransition(input)
    local relativeX = math.clamp((input.Position.X - transitionSlider.AbsolutePosition.X) / transitionSlider.AbsoluteSize.X, 0, 1)
    transitionButton.Position = UDim2.new(relativeX, 0, -0.25, 0)
    local newTime = math.floor(relativeX * 20) / 10
    transitionLabel.Text = "Transition Time: " .. newTime .. "s"
end

transitionButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        transitionSliding = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        transitionSliding = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and transitionSliding then
        updateTransition(input)
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    local transitionTime = tonumber(transitionLabel.Text:match("%d+%.?%d*"))
    local fovTween = TweenService:Create(camera, TweenInfo.new(transitionTime, Enum.EasingStyle.Quad), {
        FieldOfView = 70
    })
    fovTween:Play()
    
    local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    })
    closeTween:Play()
    closeTween.Completed:Connect(function()
        fovGui:Destroy()
    end)
end)

-- Animate opening
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 300, 0, 250),
    Position = UDim2.new(0.5, -150, 0.5, -125)
})
openTween:Play()

-- Set initial FOV slider position based on current FOV
local initialFOV = camera.FieldOfView
sliderButton.Position = UDim2.new((initialFOV - 30) / 90, 0, -0.25, 0)
fovLabel.Text = "FOV: " .. initialFOV .. "°" 
