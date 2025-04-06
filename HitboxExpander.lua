-- Hitbox Expander GUI
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Create the GUI
local hitboxGui = Instance.new("ScreenGui")
hitboxGui.Name = "HitboxExpanderGui"
hitboxGui.ResetOnSpawn = false
hitboxGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
hitboxGui.Parent = game:GetService("CoreGui")

-- Create main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 0, 0, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = hitboxGui

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
titleText.Text = "Hitbox Expander"
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
toggleButton.Text = "Enable Hitbox Expander"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 16
toggleButton.Font = Enum.Font.Code
toggleButton.Parent = mainFrame

-- Create size slider
local sizeSlider = Instance.new("Frame")
sizeSlider.Name = "SizeSlider"
sizeSlider.Size = UDim2.new(0.8, 0, 0, 20)
sizeSlider.Position = UDim2.new(0.1, 0, 0.5, 0)
sizeSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
sizeSlider.BorderSizePixel = 0
sizeSlider.Parent = mainFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0.1, 0, 1.5, 0)
sliderButton.Position = UDim2.new(0.5, 0, -0.25, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = sizeSlider

-- Size value label
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(0.8, 0, 0, 20)
sizeLabel.Position = UDim2.new(0.1, 0, 0.6, 0)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Hitbox Size: 2x"
sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
sizeLabel.TextSize = 14
sizeLabel.Font = Enum.Font.Code
sizeLabel.Parent = mainFrame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.8, 0, 0, 20)
statusLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
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

-- Hitbox functionality
local hitboxEnabled = false
local sizeMultiplier = 2
local defaultSizes = {}
local connection

local function updateHitboxes()
    if not player.Character then return end
    
    for _, part in pairs(player.Character:GetDescendants()) do
        if part:IsA("BasePart") then
            if not defaultSizes[part] then
                defaultSizes[part] = part.Size
            end
            
            if hitboxEnabled then
                part.Size = defaultSizes[part] * sizeMultiplier
                part.Transparency = 0.5
            else
                part.Size = defaultSizes[part]
                part.Transparency = 0
            end
        end
    end
end

local function updateSize(input)
    local relativeX = math.clamp((input.Position.X - sizeSlider.AbsolutePosition.X) / sizeSlider.AbsoluteSize.X, 0, 1)
    sliderButton.Position = UDim2.new(relativeX, 0, -0.25, 0)
    sizeMultiplier = 1 + (relativeX * 4) -- Size range: 1x-5x
    sizeLabel.Text = "Hitbox Size: " .. string.format("%.1fx", sizeMultiplier)
    
    if hitboxEnabled then
        updateHitboxes()
    end
end

-- Slider functionality
local sliding = false

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
        updateSize(input)
    end
end)

-- Toggle button functionality
toggleButton.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    
    if hitboxEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        statusLabel.Text = "Status: Enabled"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        updateHitboxes()
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        statusLabel.Text = "Status: Disabled"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        updateHitboxes()
    end
end)

-- Character respawn handling
player.CharacterAdded:Connect(function(character)
    defaultSizes = {}
    if hitboxEnabled then
        task.wait(0.5) -- Wait for character to load
        updateHitboxes()
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
        hitboxEnabled = false
        updateHitboxes()
        hitboxGui:Destroy()
    end)
end)

-- Animate opening
local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 300, 0, 200),
    Position = UDim2.new(0.5, -150, 0.5, -100)
})
openTween:Play() 