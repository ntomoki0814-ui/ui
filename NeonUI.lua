-- NeonUI Library - A unique neon-themed UI library for Roblox
-- Created with distinctive visual styling and smooth animations
-- Mobile-optimized version

local NeonUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- Configuration
local Config = {
    Colors = {
        Primary = Color3.fromRGB(0, 255, 255),      -- Cyan
        Secondary = Color3.fromRGB(255, 0, 255),    -- Magenta
        Background = Color3.fromRGB(15, 15, 25),    -- Dark blue
        Surface = Color3.fromRGB(25, 25, 40),       -- Lighter dark
        Text = Color3.fromRGB(255, 255, 255),       -- White
        TextSecondary = Color3.fromRGB(180, 180, 200), -- Light gray
        Success = Color3.fromRGB(0, 255, 100),      -- Green
        Warning = Color3.fromRGB(255, 200, 0),      -- Yellow
        Error = Color3.fromRGB(255, 50, 100)        -- Red
    },
    Animations = {
        Fast = 0.2,
        Medium = 0.4,
        Slow = 0.6
    },
    -- Adjusted mobile sizes to be proportionally smaller, not just width
    Mobile = {
        WindowWidth = 400,
        WindowHeight = 520,  -- Reduced from 550
        MinButtonHeight = 50,
        TouchAreaSize = 44,
        SliderHeight = 70
    }
}

-- Added mobile detection
local function IsMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

-- Utility Functions
local function CreateGlow(parent, color, size)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Parent = parent
    glow.BackgroundTransparency = 1
    glow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    glow.ImageColor3 = color or Config.Colors.Primary
    glow.ImageTransparency = 0.7
    glow.Size = UDim2.new(1, size or 20, 1, size or 20)
    glow.Position = UDim2.new(0, -(size or 20)/2, 0, -(size or 20)/2)
    glow.ZIndex = parent.ZIndex - 1
    return glow
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Config.Colors.Primary
    stroke.Thickness = thickness or 2
    stroke.Parent = parent
    return stroke
end

local function AnimateHover(element, hoverColor, normalColor)
    local connection1, connection2
    
    connection1 = element.MouseEnter:Connect(function()
        TweenService:Create(element, TweenInfo.new(Config.Animations.Fast), {
            BackgroundColor3 = hoverColor
        }):Play()
    end)
    
    connection2 = element.MouseLeave:Connect(function()
        TweenService:Create(element, TweenInfo.new(Config.Animations.Fast), {
            BackgroundColor3 = normalColor
        }):Play()
    end)
    
    return {connection1, connection2}
end

-- Main Library Functions
function NeonUI:CreateWindow(title, subtitle)
    local window = {}
    
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NeonUI_" .. title
    screenGui.Parent = PlayerGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Adjusted sizing to be proportionally smaller from original, not just mobile width
    local isMobile = IsMobile()
    local windowWidth = isMobile and Config.Mobile.WindowWidth or 450
    local windowHeight = isMobile and Config.Mobile.WindowHeight or 480  -- Reduced desktop height slightly too
    
    -- Fixed initial positioning to ensure window stays within screen bounds
    local screenSize = workspace.CurrentCamera.ViewportSize
    local maxX = screenSize.X - windowWidth - 20  -- 20px margin from edge
    local maxY = screenSize.Y - windowHeight - 20  -- 20px margin from edge
    
    local startX = math.min(screenSize.X * 0.5 - windowWidth/2, maxX)
    local startY = math.min(screenSize.Y * 0.5 - windowHeight/2, maxY)
    
    -- Ensure minimum positioning (not off-screen on the left/top)
    startX = math.max(20, startX)
    startY = math.max(20, startY)
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Config.Colors.Background
    mainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    mainFrame.Position = UDim2.new(0, startX, 0, startY)  -- Use calculated safe position
    mainFrame.BorderSizePixel = 0
    
    CreateCorner(mainFrame, 12)
    CreateStroke(mainFrame, Config.Colors.Primary, 2)
    CreateGlow(mainFrame, Config.Colors.Primary, 30)
    
    -- Mobile-friendly title bar with minimize button
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = Config.Colors.Surface
    titleBar.Size = UDim2.new(1, 0, 0, isMobile and 60 or 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BorderSizePixel = 0
    
    CreateCorner(titleBar, 12)
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Parent = titleBar
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -100, 0.6, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.Text = title or "NeonUI Window"
    titleText.TextColor3 = Config.Colors.Text
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Subtitle Text
    local subtitleText = Instance.new("TextLabel")
    subtitleText.Name = "Subtitle"
    subtitleText.Parent = titleBar
    subtitleText.BackgroundTransparency = 1
    subtitleText.Size = UDim2.new(1, -100, 0.4, 0)
    subtitleText.Position = UDim2.new(0, 10, 0.6, 0)
    subtitleText.Text = subtitle or "Powered by NeonUI"
    subtitleText.TextColor3 = Config.Colors.TextSecondary
    subtitleText.TextScaled = true
    subtitleText.Font = Enum.Font.Gotham
    subtitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Updated minimize button colors to match neon theme
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = titleBar
    minimizeButton.BackgroundColor3 = Config.Colors.Secondary  -- Changed to magenta neon color
    minimizeButton.Size = UDim2.new(0, isMobile and 40 or 30, 0, isMobile and 40 or 30)
    minimizeButton.Position = UDim2.new(1, isMobile and -90 or -80, 0, 10)
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = Config.Colors.Text
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.BorderSizePixel = 0
    
    CreateCorner(minimizeButton, 6)
    CreateStroke(minimizeButton, Config.Colors.Secondary, 2)  -- Added neon stroke
    AnimateHover(minimizeButton, Color3.fromRGB(200, 0, 200), Config.Colors.Secondary)  -- Darker magenta on hover
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleBar
    closeButton.BackgroundColor3 = Config.Colors.Primary  -- Changed to cyan neon color
    closeButton.Size = UDim2.new(0, isMobile and 40 or 30, 0, isMobile and 40 or 30)
    closeButton.Position = UDim2.new(1, isMobile and -45 or -40, 0, 10)
    closeButton.Text = "×"
    closeButton.TextColor3 = Config.Colors.Text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    
    CreateCorner(closeButton, 6)
    CreateStroke(closeButton, Config.Colors.Primary, 2)  -- Added neon stroke
    AnimateHover(closeButton, Color3.fromRGB(0, 200, 200), Config.Colors.Primary)  -- Darker cyan on hover
    
    -- Added minimize/maximize functionality
    local isMinimized = false
    local originalSize = mainFrame.Size
    
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        
        if isMinimized then
            -- Hide tab scroll frame and content when minimized
            tabScrollFrame.Visible = false
            contentFrame.Visible = false
            
            TweenService:Create(mainFrame, TweenInfo.new(Config.Animations.Medium), {
                Size = UDim2.new(0, windowWidth, 0, titleBar.Size.Y.Offset)
            }):Play()
            minimizeButton.Text = "+"
        else
            -- Show tab scroll frame and content when maximized
            tabScrollFrame.Visible = true
            contentFrame.Visible = true
            
            TweenService:Create(mainFrame, TweenInfo.new(Config.Animations.Medium), {
                Size = originalSize
            }):Play()
            minimizeButton.Text = "−"
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Added tab container frame
    local tabScrollFrame = Instance.new("ScrollingFrame")
    tabScrollFrame.Name = "TabScrollFrame"
    tabScrollFrame.Parent = mainFrame
    tabScrollFrame.BackgroundColor3 = Config.Colors.Surface
    tabScrollFrame.Size = UDim2.new(1, 0, 0, isMobile and 50 or 40)
    tabScrollFrame.Position = UDim2.new(0, 0, 0, titleBar.Size.Y.Offset)
    tabScrollFrame.ScrollingDirection = Enum.ScrollingDirection.X
    tabScrollFrame.ScrollBarThickness = isMobile and 12 or 6
    tabScrollFrame.ScrollBarImageColor3 = Config.Colors.Primary
    tabScrollFrame.BorderSizePixel = 0
    tabScrollFrame.CanvasSize = UDim2.new(0, 0, 1, 0)
    tabScrollFrame.ScrollingEnabled = true  -- Explicitly enable scrolling
    tabScrollFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable  -- Better mobile scrolling behavior
    tabScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.X  -- Automatic canvas sizing
    
    -- Improved mobile scrolling properties
    if isMobile then
        tabScrollFrame.ScrollBarImageTransparency = 0.2
        tabScrollFrame.TopImage = ""
        tabScrollFrame.BottomImage = ""
        tabScrollFrame.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
        -- Enable touch scrolling
        tabScrollFrame.TouchPan = true
    end
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = tabScrollFrame
    tabContainer.BackgroundTransparency = 1
    tabContainer.Size = UDim2.new(0, 0, 1, 0)
    tabContainer.Position = UDim2.new(0, 0, 0, 0)
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    
    -- Improved canvas size update with better scrolling behavior
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        local contentWidth = tabLayout.AbsoluteContentSize.X + 10  -- Add padding
        tabContainer.Size = UDim2.new(0, contentWidth, 1, 0)
        tabScrollFrame.CanvasSize = UDim2.new(0, contentWidth, 0, 0)
        
        -- Force scrolling update
        wait()
        tabScrollFrame.ScrollingEnabled = contentWidth > tabScrollFrame.AbsoluteSize.X
        
        -- Ensure scrollbar is visible when needed
        if contentWidth > tabScrollFrame.AbsoluteSize.X then
            tabScrollFrame.ScrollBarImageTransparency = isMobile and 0.2 or 0.4
        else
            tabScrollFrame.ScrollBarImageTransparency = 1
        end
    end)
    
    -- Modified content frame position to use tabScrollFrame instead of tabContainer
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content"
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.Size = UDim2.new(1, -20, 1, -(titleBar.Size.Y.Offset + tabScrollFrame.Size.Y.Offset + 20))
    contentFrame.Position = UDim2.new(0, 10, 0, titleBar.Size.Y.Offset + tabScrollFrame.Size.Y.Offset + 10)
    contentFrame.ScrollBarThickness = isMobile and 10 or 6
    contentFrame.ScrollBarImageColor3 = Config.Colors.Primary
    contentFrame.BorderSizePixel = 0
    
    -- Enhanced dragging for mobile with touch support
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function startDrag(input)
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
    
    local function updateDrag(input)
        if dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
    
    local function endDrag()
        dragging = false
    end
    
    -- Mouse support
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            startDrag(input)
        end
    end)
    
    -- Touch support
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            startDrag(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            updateDrag(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            endDrag()
        end
    end)
    
    -- Updated window properties to use tabScrollFrame
    window.ContentFrame = contentFrame
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.TabScrollFrame = tabScrollFrame
    window.Tabs = {}
    window.CurrentTab = nil
    window.IsMinimized = function() return isMinimized end
    
    return window
end

function NeonUI:CreateButton(parent, text, callback)
    local isMobile = IsMobile()
    local buttonHeight = isMobile and Config.Mobile.MinButtonHeight or 40
    
    local button = Instance.new("TextButton")
    button.Name = "NeonButton"
    button.Parent = parent
    button.BackgroundColor3 = Config.Colors.Surface
    button.Size = UDim2.new(1, -20, 0, buttonHeight)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.Text = text or "Button"
    button.TextColor3 = Config.Colors.Text
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    
    CreateCorner(button, 8)
    CreateStroke(button, Config.Colors.Primary, 2)
    
    -- Hover animation
    AnimateHover(button, Config.Colors.Primary, Config.Colors.Surface)
    
    -- Click animation
    button.MouseButton1Click:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -25, 0, buttonHeight - 5)
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -20, 0, buttonHeight)
        }):Play()
        
        if callback then
            callback()
        end
    end)
    
    return button
end

function NeonUI:CreateToggle(parent, text, defaultState, callback)
    local isMobile = IsMobile()
    local toggleHeight = isMobile and 60 or 50
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Parent = parent
    toggleFrame.BackgroundColor3 = Config.Colors.Surface
    toggleFrame.Size = UDim2.new(1, -20, 0, toggleHeight)
    toggleFrame.Position = UDim2.new(0, 10, 0, 0)
    toggleFrame.BorderSizePixel = 0
    
    CreateCorner(toggleFrame, 8)
    CreateStroke(toggleFrame, Config.Colors.Primary, 2)
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "ToggleText"
    toggleText.Parent = toggleFrame
    toggleText.BackgroundTransparency = 1
    toggleText.Size = UDim2.new(0.6, 0, 1, 0)
    toggleText.Position = UDim2.new(0, 15, 0, 0)
    toggleText.Text = text or "Toggle"
    toggleText.TextColor3 = Config.Colors.Text
    toggleText.TextScaled = true
    toggleText.Font = Enum.Font.Gotham
    toggleText.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Parent = toggleFrame
    toggleButton.BackgroundColor3 = defaultState and Config.Colors.Success or Config.Colors.Error
    toggleButton.Size = UDim2.new(0, isMobile and 80 or 60, 0, isMobile and 40 or 30)
    toggleButton.Position = UDim2.new(1, isMobile and -90 or -70, 0.5, isMobile and -20 or -15)
    toggleButton.Text = defaultState and "ON" or "OFF"
    toggleButton.TextColor3 = Config.Colors.Text
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.BorderSizePixel = 0
    
    CreateCorner(toggleButton, 15)
    
    local isToggled = defaultState or false
    
    toggleButton.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        
        TweenService:Create(toggleButton, TweenInfo.new(Config.Animations.Fast), {
            BackgroundColor3 = isToggled and Config.Colors.Success or Config.Colors.Error
        }):Play()
        
        toggleButton.Text = isToggled and "ON" or "OFF"
        
        if callback then
            callback(isToggled)
        end
    end)
    
    return toggleFrame, isToggled
end

-- Completely rewritten CreateSlider for mobile touch support
function NeonUI:CreateSlider(parent, text, min, max, default, callback)
    local isMobile = IsMobile()
    local sliderHeight = isMobile and Config.Mobile.SliderHeight or 60
    
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Parent = parent
    sliderFrame.BackgroundColor3 = Config.Colors.Surface
    sliderFrame.Size = UDim2.new(1, -20, 0, sliderHeight)
    sliderFrame.Position = UDim2.new(0, 10, 0, 0)
    sliderFrame.BorderSizePixel = 0
    
    CreateCorner(sliderFrame, 8)
    CreateStroke(sliderFrame, Config.Colors.Primary, 2)
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Name = "SliderText"
    sliderText.Parent = sliderFrame
    sliderText.BackgroundTransparency = 1
    sliderText.Size = UDim2.new(0.6, 0, 0.4, 0)
    sliderText.Position = UDim2.new(0, 15, 0, 5)
    sliderText.Text = text or "Slider"
    sliderText.TextColor3 = Config.Colors.Text
    sliderText.TextScaled = true
    sliderText.Font = Enum.Font.Gotham
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueText = Instance.new("TextLabel")
    valueText.Name = "ValueText"
    valueText.Parent = sliderFrame
    valueText.BackgroundTransparency = 1
    valueText.Size = UDim2.new(0.3, 0, 0.4, 0)
    valueText.Position = UDim2.new(0.7, 0, 0, 5)
    valueText.Text = tostring(default or min or 0)
    valueText.TextColor3 = Config.Colors.Primary
    valueText.TextScaled = true
    valueText.Font = Enum.Font.GothamBold
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Parent = sliderFrame
    sliderBar.BackgroundColor3 = Config.Colors.Background
    sliderBar.Size = UDim2.new(0.9, 0, 0, isMobile and 12 or 6)
    sliderBar.Position = UDim2.new(0.05, 0, 0.65, 0)
    sliderBar.BorderSizePixel = 0
    
    CreateCorner(sliderBar, isMobile and 6 or 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Parent = sliderBar
    sliderFill.BackgroundColor3 = Config.Colors.Primary
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BorderSizePixel = 0
    
    CreateCorner(sliderFill, isMobile and 6 or 3)
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "SliderKnob"
    sliderKnob.Parent = sliderBar
    sliderKnob.BackgroundColor3 = Config.Colors.Primary
    local knobSize = isMobile and 24 or 16
    sliderKnob.Size = UDim2.new(0, knobSize, 0, knobSize)
    sliderKnob.Position = UDim2.new(0, -knobSize/2, 0.5, -knobSize/2)
    sliderKnob.BorderSizePixel = 0
    
    CreateCorner(sliderKnob, knobSize/2)
    CreateGlow(sliderKnob, Config.Colors.Primary, 10)
    
    local minVal = min or 0
    local maxVal = max or 100
    local currentVal = default or minVal
    
    local function updateSlider(value)
        currentVal = math.clamp(value, minVal, maxVal)
        local percentage = (currentVal - minVal) / (maxVal - minVal)
        
        TweenService:Create(sliderFill, TweenInfo.new(Config.Animations.Fast), {
            Size = UDim2.new(percentage, 0, 1, 0)
        }):Play()
        
        TweenService:Create(sliderKnob, TweenInfo.new(Config.Animations.Fast), {
            Position = UDim2.new(percentage, -knobSize/2, 0.5, -knobSize/2)
        }):Play()
        
        valueText.Text = tostring(math.floor(currentVal))
        
        if callback then
            callback(currentVal)
        end
    end
    
    updateSlider(currentVal)
    
    local dragging = false
    
    local function handleInput(input)
        local percentage = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local value = minVal + (maxVal - minVal) * percentage
        updateSlider(value)
    end
    
    -- Enhanced input handling for both mouse and touch
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            handleInput(input)
        end
    end)
    
    sliderKnob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleInput(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    return sliderFrame, currentVal
end

function NeonUI:CreateTextBox(parent, placeholder, callback)
    local isMobile = IsMobile()
    local textBoxHeight = isMobile and Config.Mobile.MinButtonHeight or 40
    
    local textBox = Instance.new("TextBox")
    textBox.Name = "NeonTextBox"
    textBox.Parent = parent
    textBox.BackgroundColor3 = Config.Colors.Surface
    textBox.Size = UDim2.new(1, -20, 0, textBoxHeight)
    textBox.Position = UDim2.new(0, 10, 0, 0)
    textBox.PlaceholderText = placeholder or "Enter text..."
    textBox.PlaceholderColor3 = Config.Colors.TextSecondary
    textBox.Text = ""
    textBox.TextColor3 = Config.Colors.Text
    textBox.TextScaled = true
    textBox.Font = Enum.Font.Gotham
    textBox.BorderSizePixel = 0
    textBox.ClearButtonOnFocus = false
    
    CreateCorner(textBox, 8)
    CreateStroke(textBox, Config.Colors.Primary, 2)
    
    textBox.FocusLost:Connect(function(enterPressed)
        if callback then
            callback(textBox.Text, enterPressed)
        end
    end)
    
    return textBox
end

function NeonUI:CreateLabel(parent, text, color)
    local isMobile = IsMobile()
    local labelHeight = isMobile and 40 or 30
    
    local label = Instance.new("TextLabel")
    label.Name = "NeonLabel"
    label.Parent = parent
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -20, 0, labelHeight)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text or "Label"
    label.TextColor3 = color or Config.Colors.Text
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return label
end

function NeonUI:CreateSection(parent, title)
    local isMobile = IsMobile()
    local sectionHeight = isMobile and 50 or 40
    
    local section = Instance.new("Frame")
    section.Name = "Section"
    section.Parent = parent
    section.BackgroundTransparency = 1
    section.Size = UDim2.new(1, 0, 0, sectionHeight)
    section.Position = UDim2.new(0, 0, 0, 0)
    
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Parent = section
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Size = UDim2.new(1, -20, 1, 0)
    sectionTitle.Position = UDim2.new(0, 10, 0, 0)
    sectionTitle.Text = title or "Section"
    sectionTitle.TextColor3 = Config.Colors.Primary
    sectionTitle.TextScaled = true
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Parent = section
    divider.BackgroundColor3 = Config.Colors.Primary
    divider.Size = UDim2.new(1, -20, 0, 2)
    divider.Position = UDim2.new(0, 10, 1, -5)
    divider.BorderSizePixel = 0
    
    CreateCorner(divider, 1)
    
    return section
end

-- Auto-layout system
function NeonUI:AutoLayout(parent)
    local layout = Instance.new("UIListLayout")
    layout.Parent = parent
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    
    return layout
end

-- Updated CreateTab function for mobile-friendly tab buttons
function NeonUI:CreateTab(window, tabName)
    if not window.TabContainer then
        error("Window does not support tabs")
    end
    
    local isMobile = IsMobile()
    local tabWidth = isMobile and 120 or 100
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. tabName
    tabButton.Parent = window.TabContainer
    tabButton.BackgroundColor3 = Config.Colors.Background
    tabButton.Size = UDim2.new(0, tabWidth, 1, 0)
    tabButton.Text = tabName
    tabButton.TextColor3 = Config.Colors.TextSecondary
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.Gotham
    tabButton.BorderSizePixel = 0
    
    CreateCorner(tabButton, 6)
    CreateStroke(tabButton, Config.Colors.Primary, 1)
    
    -- Enhanced mobile touch support for tab buttons
    if isMobile then
        tabButton.AutoButtonColor = false  -- Disable default button behavior for better touch control
    end
    
    -- Create tab content frame
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = "TabContent_" .. tabName
    tabContent.Parent = window.ContentFrame
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = isMobile and 10 or 6
    tabContent.ScrollBarImageColor3 = Config.Colors.Primary
    tabContent.BorderSizePixel = 0
    tabContent.Visible = false
    
    -- Add auto-layout to tab content
    self:AutoLayout(tabContent)
    
    -- Store tab information
    local tab = {
        Button = tabButton,
        Content = tabContent,
        Name = tabName,
        Active = false
    }
    
    window.Tabs[tabName] = tab
    
    -- Enhanced tab click functionality with improved auto-scroll
    local function switchToTab()
        self:SwitchTab(window, tabName)
        
        -- Improved auto-scroll to show active tab
        if window.TabScrollFrame and window.TabScrollFrame.ScrollingEnabled then
            wait(0.1)  -- Small delay to ensure layout is updated
            
            local tabAbsolutePos = tabButton.AbsolutePosition.X
            local scrollFrameAbsolutePos = window.TabScrollFrame.AbsolutePosition.X
            local tabRelativePos = tabAbsolutePos - scrollFrameAbsolutePos
            local scrollFrameWidth = window.TabScrollFrame.AbsoluteSize.X
            local tabWidth = tabButton.AbsoluteSize.X
            
            -- Calculate optimal scroll position
            local currentCanvasPos = window.TabScrollFrame.CanvasPosition.X
            local targetScroll = currentCanvasPos
            
            -- If tab is cut off on the right
            if tabRelativePos + tabWidth > scrollFrameWidth then
                targetScroll = currentCanvasPos + (tabRelativePos + tabWidth - scrollFrameWidth) + 20
            end
            
            -- If tab is cut off on the left
            if tabRelativePos < 0 then
                targetScroll = currentCanvasPos + tabRelativePos - 20
            end
            
            -- Clamp scroll position
            local maxScroll = math.max(0, window.TabScrollFrame.CanvasSize.X.Offset - scrollFrameWidth)
            targetScroll = math.max(0, math.min(targetScroll, maxScroll))
            
            -- Smooth scroll animation
            TweenService:Create(window.TabScrollFrame, TweenInfo.new(Config.Animations.Medium, Enum.EasingStyle.Quad), {
                CanvasPosition = Vector2.new(targetScroll, 0)
            }):Play()
        end
    end
    
    tabButton.MouseButton1Click:Connect(switchToTab)
    
    -- Enhanced touch support for mobile devices
    if isMobile then
        tabButton.TouchTap:Connect(switchToTab)
        -- Additional touch handling for better responsiveness
        tabButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                switchToTab()
            end
        end)
    end
    
    -- If this is the first tab, make it active
    if not window.CurrentTab then
        self:SwitchTab(window, tabName)
    end
    
    return tabContent
end

-- Added SwitchTab function to handle tab switching
function NeonUI:SwitchTab(window, tabName)
    if not window.Tabs[tabName] then
        return
    end
    
    -- Hide all tabs and reset button colors
    for name, tab in pairs(window.Tabs) do
        tab.Content.Visible = false
        tab.Active = false
        TweenService:Create(tab.Button, TweenInfo.new(Config.Animations.Fast), {
            BackgroundColor3 = Config.Colors.Background,
            TextColor3 = Config.Colors.TextSecondary
        }):Play()
    end
    
    -- Show selected tab and highlight button
    local selectedTab = window.Tabs[tabName]
    selectedTab.Content.Visible = true
    selectedTab.Active = true
    window.CurrentTab = tabName
    
    TweenService:Create(selectedTab.Button, TweenInfo.new(Config.Animations.Fast), {
        BackgroundColor3 = Config.Colors.Primary,
        TextColor3 = Config.Colors.Text
    }):Play()
end

-- Added Config to exports for external access
NeonUI.Config = Config

return NeonUI
