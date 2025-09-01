-- NeonUI Library - A unique neon-themed UI library for Roblox
-- Created with distinctive visual styling and smooth animations

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
    }
}

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
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Config.Colors.Background
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BorderSizePixel = 0
    
    CreateCorner(mainFrame, 12)
    CreateStroke(mainFrame, Config.Colors.Primary, 2)
    CreateGlow(mainFrame, Config.Colors.Primary, 30)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Parent = mainFrame
    titleBar.BackgroundColor3 = Config.Colors.Surface
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BorderSizePixel = 0
    
    CreateCorner(titleBar, 12)
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Parent = titleBar
    titleText.BackgroundTransparency = 1
    titleText.Size = UDim2.new(1, -20, 0.6, 0)
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
    subtitleText.Size = UDim2.new(1, -20, 0.4, 0)
    subtitleText.Position = UDim2.new(0, 10, 0.6, 0)
    subtitleText.Text = subtitle or "Powered by NeonUI"
    subtitleText.TextColor3 = Config.Colors.TextSecondary
    subtitleText.TextScaled = true
    subtitleText.Font = Enum.Font.Gotham
    subtitleText.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = titleBar
    closeButton.BackgroundColor3 = Config.Colors.Error
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.Text = "×"
    closeButton.TextColor3 = Config.Colors.Text
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    
    CreateCorner(closeButton, 6)
    AnimateHover(closeButton, Config.Colors.Error, Config.Colors.Error)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Added tab container frame
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.BackgroundColor3 = Config.Colors.Surface
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 50)
    tabContainer.BorderSizePixel = 0
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 2)
    
    -- Modified content frame position and size to accommodate tabs
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content"
    contentFrame.Parent = mainFrame
    contentFrame.BackgroundTransparency = 1
    contentFrame.Size = UDim2.new(1, -20, 1, -110)
    contentFrame.Position = UDim2.new(0, 10, 0, 100)
    contentFrame.ScrollBarThickness = 6
    contentFrame.ScrollBarImageColor3 = Config.Colors.Primary
    contentFrame.BorderSizePixel = 0
    
    -- Make window draggable
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
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Added tab system properties and methods
    window.ContentFrame = contentFrame
    window.ScreenGui = screenGui
    window.MainFrame = mainFrame
    window.TabContainer = tabContainer
    window.Tabs = {}
    window.CurrentTab = nil
    
    return window
end

function NeonUI:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Name = "NeonButton"
    button.Parent = parent
    button.BackgroundColor3 = Config.Colors.Surface
    button.Size = UDim2.new(1, -20, 0, 40)
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
            Size = UDim2.new(1, -25, 0, 35)
        }):Play()
        
        wait(0.1)
        
        TweenService:Create(button, TweenInfo.new(0.1), {
            Size = UDim2.new(1, -20, 0, 40)
        }):Play()
        
        if callback then
            callback()
        end
    end)
    
    return button
end

function NeonUI:CreateToggle(parent, text, defaultState, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "ToggleFrame"
    toggleFrame.Parent = parent
    toggleFrame.BackgroundColor3 = Config.Colors.Surface
    toggleFrame.Size = UDim2.new(1, -20, 0, 50)
    toggleFrame.Position = UDim2.new(0, 10, 0, 0)
    toggleFrame.BorderSizePixel = 0
    
    CreateCorner(toggleFrame, 8)
    CreateStroke(toggleFrame, Config.Colors.Primary, 2)
    
    local toggleText = Instance.new("TextLabel")
    toggleText.Name = "ToggleText"
    toggleText.Parent = toggleFrame
    toggleText.BackgroundTransparency = 1
    toggleText.Size = UDim2.new(0.7, 0, 1, 0)
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
    toggleButton.Size = UDim2.new(0, 60, 0, 30)
    toggleButton.Position = UDim2.new(1, -70, 0.5, -15)
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

function NeonUI:CreateSlider(parent, text, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = "SliderFrame"
    sliderFrame.Parent = parent
    sliderFrame.BackgroundColor3 = Config.Colors.Surface
    sliderFrame.Size = UDim2.new(1, -20, 0, 60)
    sliderFrame.Position = UDim2.new(0, 10, 0, 0)
    sliderFrame.BorderSizePixel = 0
    
    CreateCorner(sliderFrame, 8)
    CreateStroke(sliderFrame, Config.Colors.Primary, 2)
    
    local sliderText = Instance.new("TextLabel")
    sliderText.Name = "SliderText"
    sliderText.Parent = sliderFrame
    sliderText.BackgroundTransparency = 1
    sliderText.Size = UDim2.new(0.6, 0, 0.5, 0)
    sliderText.Position = UDim2.new(0, 15, 0, 0)
    sliderText.Text = text or "Slider"
    sliderText.TextColor3 = Config.Colors.Text
    sliderText.TextScaled = true
    sliderText.Font = Enum.Font.Gotham
    sliderText.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueText = Instance.new("TextLabel")
    valueText.Name = "ValueText"
    valueText.Parent = sliderFrame
    valueText.BackgroundTransparency = 1
    valueText.Size = UDim2.new(0.3, 0, 0.5, 0)
    valueText.Position = UDim2.new(0.7, 0, 0, 0)
    valueText.Text = tostring(default or min or 0)
    valueText.TextColor3 = Config.Colors.Primary
    valueText.TextScaled = true
    valueText.Font = Enum.Font.GothamBold
    valueText.TextXAlignment = Enum.TextXAlignment.Right
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "SliderBar"
    sliderBar.Parent = sliderFrame
    sliderBar.BackgroundColor3 = Config.Colors.Background
    sliderBar.Size = UDim2.new(0.9, 0, 0, 6)
    sliderBar.Position = UDim2.new(0.05, 0, 0.7, 0)
    sliderBar.BorderSizePixel = 0
    
    CreateCorner(sliderBar, 3)
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Name = "SliderFill"
    sliderFill.Parent = sliderBar
    sliderFill.BackgroundColor3 = Config.Colors.Primary
    sliderFill.Size = UDim2.new(0, 0, 1, 0)
    sliderFill.Position = UDim2.new(0, 0, 0, 0)
    sliderFill.BorderSizePixel = 0
    
    CreateCorner(sliderFill, 3)
    
    local sliderKnob = Instance.new("Frame")
    sliderKnob.Name = "SliderKnob"
    sliderKnob.Parent = sliderBar
    sliderKnob.BackgroundColor3 = Config.Colors.Primary
    sliderKnob.Size = UDim2.new(0, 16, 0, 16)
    sliderKnob.Position = UDim2.new(0, -8, 0, -5)
    sliderKnob.BorderSizePixel = 0
    
    CreateCorner(sliderKnob, 8)
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
            Position = UDim2.new(percentage, -8, 0, -5)
        }):Play()
        
        valueText.Text = tostring(math.floor(currentVal))
        
        if callback then
            callback(currentVal)
        end
    end
    
    updateSlider(currentVal)
    
    local dragging = false
    
    sliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local percentage = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = minVal + (maxVal - minVal) * percentage
            updateSlider(value)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local percentage = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = minVal + (maxVal - minVal) * percentage
            updateSlider(value)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return sliderFrame, currentVal
end

function NeonUI:CreateTextBox(parent, placeholder, callback)
    local textBox = Instance.new("TextBox")
    textBox.Name = "NeonTextBox"
    textBox.Parent = parent
    textBox.BackgroundColor3 = Config.Colors.Surface
    textBox.Size = UDim2.new(1, -20, 0, 40)
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
    local label = Instance.new("TextLabel")
    label.Name = "NeonLabel"
    label.Parent = parent
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text or "Label"
    label.TextColor3 = color or Config.Colors.Text
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return label
end

function NeonUI:CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Name = "Section"
    section.Parent = parent
    section.BackgroundTransparency = 1
    section.Size = UDim2.new(1, 0, 0, 40)
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

-- Added CreateTab function for tab functionality
function NeonUI:CreateTab(window, tabName)
    if not window.TabContainer then
        error("Window does not support tabs")
    end
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = "Tab_" .. tabName
    tabButton.Parent = window.TabContainer
    tabButton.BackgroundColor3 = Config.Colors.Background
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.Text = tabName
    tabButton.TextColor3 = Config.Colors.TextSecondary
    tabButton.TextScaled = true
    tabButton.Font = Enum.Font.Gotham
    tabButton.BorderSizePixel = 0
    
    CreateCorner(tabButton, 6)
    CreateStroke(tabButton, Config.Colors.Primary, 1)
    
    -- Create tab content frame
    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = "TabContent_" .. tabName
    tabContent.Parent = window.ContentFrame
    tabContent.BackgroundTransparency = 1
    tabContent.Size = UDim2.new(1, 0, 1, 0)
    tabContent.Position = UDim2.new(0, 0, 0, 0)
    tabContent.ScrollBarThickness = 6
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
    
    -- Tab click functionality
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchTab(window, tabName)
    end)
    
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

return NeonUI
