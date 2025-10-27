local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local CurrentTheme = {
    Background = Color3.fromRGB(35,35,35),
    Button = Color3.fromRGB(60,120,220),
    ButtonHover = Color3.fromRGB(80,150,255),
    TextColor = Color3.fromRGB(255,255,255),
    Entry = Color3.fromRGB(50,50,50),
    EntryHover = Color3.fromRGB(70,70,70)
}

local DisclaimScreen = Instance.new("ScreenGui")
DisclaimScreen.Name = "DisclaimerGui"
DisclaimScreen.Parent = CoreGui
DisclaimScreen.ResetOnSpawn = false

local DisclaimFrame = Instance.new("Frame")
DisclaimFrame.Size = UDim2.new(0,500,0,200)
DisclaimFrame.Position = UDim2.new(0.5,-250,0.5,-100)
DisclaimFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
DisclaimFrame.BorderSizePixel = 0
DisclaimFrame.Parent = DisclaimScreen
local DisclaimCorner = Instance.new("UICorner")
DisclaimCorner.CornerRadius = UDim.new(0,16)
DisclaimCorner.Parent = DisclaimFrame

local DisclaimLabel = Instance.new("TextLabel")
DisclaimLabel.Size = UDim2.new(1,-20,0.7,-10)
DisclaimLabel.Position = UDim2.new(0,10,0,10)
DisclaimLabel.BackgroundTransparency = 1
DisclaimLabel.Text = "I do not condone what is done with this script. Do not hold me accountable for your mistakes."
DisclaimLabel.TextWrapped = true
DisclaimLabel.Font = Enum.Font.RobotoMono
DisclaimLabel.TextSize = 18
DisclaimLabel.TextColor3 = Color3.fromRGB(255,255,255)
DisclaimLabel.Parent = DisclaimFrame

local OkButton = Instance.new("TextButton")
OkButton.Size = UDim2.new(0,120,0,40)
OkButton.Position = UDim2.new(0.5,-60,0.75,0)
OkButton.Text = "Okay!"
OkButton.Font = Enum.Font.RobotoMono
OkButton.TextSize = 18
OkButton.TextColor3 = Color3.fromRGB(255,255,255)
OkButton.BackgroundColor3 = Color3.fromRGB(50,150,50)
OkButton.BorderSizePixel = 0
OkButton.Parent = DisclaimFrame
local OkCorner = Instance.new("UICorner")
OkCorner.CornerRadius = UDim.new(0,12)
OkCorner.Parent = OkButton

local function loadMainGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SodasAnimateLogger"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0,760,0,720)
    MainFrame.Position = UDim2.new(0.5,-380,0.5,-360)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0,16)
    MainCorner.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1,0,0,50)
    TopBar.Position = UDim2.new(0,0,0,0)
    TopBar.BackgroundColor3 = CurrentTheme.Entry
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0,16)
    TopCorner.Parent = TopBar

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(0,300,0,30)
    SearchBox.Position = UDim2.new(0.5,-150,0.5,-15)
    SearchBox.PlaceholderText = "Search animations..."
    SearchBox.Text = ""
    SearchBox.ClearTextOnFocus = false
    SearchBox.Font = Enum.Font.RobotoMono
    SearchBox.TextSize = 16
    SearchBox.TextColor3 = CurrentTheme.TextColor
    SearchBox.BackgroundColor3 = CurrentTheme.Entry
    SearchBox.BorderSizePixel = 0
    SearchBox.Parent = TopBar
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0,8)
    SearchCorner.Parent = SearchBox

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0,220,1,0)
    Title.Position = UDim2.new(0,10,0,0)
    Title.BackgroundTransparency = 1
    Title.Text = "Sodas Animation Logger"
    Title.Font = Enum.Font.RobotoMono
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.TextColor3 = CurrentTheme.TextColor
    Title.Parent = TopBar

    local dragging = false
    local dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0,40,0,30)
    CloseButton.Position = UDim2.new(1,-50,0,10)
    CloseButton.Text = "X"
    CloseButton.Font = Enum.Font.RobotoMono
    CloseButton.TextSize = 18
    CloseButton.TextColor3 = Color3.fromRGB(255,255,255)
    CloseButton.BackgroundColor3 = Color3.fromRGB(150,50,50)
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = TopBar
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0,8)
    CloseCorner.Parent = CloseButton
    CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local RefreshButton = Instance.new("TextButton")
    RefreshButton.Size = UDim2.new(0,100,0,30)
    RefreshButton.Position = UDim2.new(1,-200,0,10)
    RefreshButton.Text = "Refresh"
    RefreshButton.Font = Enum.Font.RobotoMono
    RefreshButton.TextSize = 16
    RefreshButton.TextColor3 = CurrentTheme.TextColor
    RefreshButton.BackgroundColor3 = CurrentTheme.Button
    RefreshButton.BorderSizePixel = 0
    RefreshButton.Parent = TopBar
    local RefreshCorner = Instance.new("UICorner")
    RefreshCorner.CornerRadius = UDim.new(0,8)
    RefreshCorner.Parent = RefreshButton

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Size = UDim2.new(1,0,1,-50)
    ScrollFrame.Position = UDim2.new(0,0,0,50)
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.BorderSizePixel = 0
    ScrollFrame.ScrollBarThickness = 10
    ScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
    ScrollFrame.Parent = MainFrame
    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0,6)
    UIList.Parent = ScrollFrame

    local loggedAnimations = {}

    local function scanAnimations()
        loggedAnimations = {}
        for _,v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Animation") and v.AnimationId~="" then
                table.insert(loggedAnimations,{Name=v.Name,Id=v.AnimationId})
            end
        end
        for _,v in ipairs(ReplicatedStorage:GetDescendants()) do
            if v:IsA("Animation") and v.AnimationId~="" then
                table.insert(loggedAnimations,{Name=v.Name,Id=v.AnimationId})
            end
        end
    end

    local function displayAnimations()
        for _,v in ipairs(ScrollFrame:GetChildren()) do
            if v:IsA("Frame") then v:Destroy() end
        end
        ScrollFrame.CanvasPosition = Vector2.new(0,0)
        for _,anim in ipairs(loggedAnimations) do
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1,-20,0,50)
            frame.BackgroundColor3 = CurrentTheme.Entry
            frame.BorderSizePixel = 0
            frame.Parent = ScrollFrame
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0,8)
            corner.Parent = frame

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(0.5,0,1,0)
            nameLabel.Position = UDim2.new(0,5,0,0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = anim.Name
            nameLabel.Font = Enum.Font.RobotoMono
            nameLabel.TextSize = 16
            nameLabel.TextColor3 = CurrentTheme.TextColor
            nameLabel.Parent = frame

            local PlayButton = Instance.new("TextButton")
            PlayButton.Size = UDim2.new(0,60,0,30)
            PlayButton.Position = UDim2.new(0.55,0,0.1,0)
            PlayButton.Text = "Play"
            PlayButton.Font = Enum.Font.RobotoMono
            PlayButton.TextSize = 14
            PlayButton.TextColor3 = CurrentTheme.TextColor
            PlayButton.BackgroundColor3 = CurrentTheme.Button
            PlayButton.BorderSizePixel = 0
            PlayButton.Parent = frame
            local Pcorner = Instance.new("UICorner")
            Pcorner.CornerRadius = UDim.new(0,6)
            Pcorner.Parent = PlayButton

            local StopButton = Instance.new("TextButton")
            StopButton.Size = UDim2.new(0,60,0,30)
            StopButton.Position = UDim2.new(0.7,0,0.1,0)
            StopButton.Text = "Stop"
            StopButton.Font = Enum.Font.RobotoMono
            StopButton.TextSize = 14
            StopButton.TextColor3 = CurrentTheme.TextColor
            StopButton.BackgroundColor3 = Color3.fromRGB(180,60,60)
            StopButton.BorderSizePixel = 0
            StopButton.Parent = frame
            local Scorner = Instance.new("UICorner")
            Scorner.CornerRadius = UDim.new(0,6)
            Scorner.Parent = StopButton

            local CopyButton = Instance.new("TextButton")
            CopyButton.Size = UDim2.new(0,60,0,30)
            CopyButton.Position = UDim2.new(0.85,0,0.1,0)
            CopyButton.Text = "Copy"
            CopyButton.Font = Enum.Font.RobotoMono
            CopyButton.TextSize = 14
            CopyButton.TextColor3 = CurrentTheme.TextColor
            CopyButton.BackgroundColor3 = Color3.fromRGB(100,100,100)
            CopyButton.BorderSizePixel = 0
            CopyButton.Parent = frame
            local Ccorner = Instance.new("UICorner")
            Ccorner.CornerRadius = UDim.new(0,6)
            Ccorner.Parent = CopyButton

            frame.MouseEnter:Connect(function()
                TweenService:Create(frame,TweenInfo.new(0.2),{Size=UDim2.new(1,-20,0,60)}):Play()
            end)
            frame.MouseLeave:Connect(function()
                TweenService:Create(frame,TweenInfo.new(0.2),{Size=UDim2.new(1,-20,0,50)}):Play()
            end)

            local currentTrack = nil
            PlayButton.MouseButton1Click:Connect(function()
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        if currentTrack then currentTrack:Stop() end
                        local animObj = Instance.new("Animation")
                        animObj.AnimationId = anim.Id
                        currentTrack = humanoid:LoadAnimation(animObj)
                        currentTrack:Play()
                    end
                end
            end)
            StopButton.MouseButton1Click:Connect(function()
                if currentTrack then currentTrack:Stop() currentTrack=nil end
            end)
            CopyButton.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(anim.Id:gsub("rbxassetid://",""))
                end
            end)
        end
        ScrollFrame.CanvasSize = UDim2.new(0,0,0,UIList.AbsoluteContentSize.Y)
    end

    RefreshButton.MouseButton1Click:Connect(function()
        scanAnimations()
        displayAnimations()
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local query = SearchBox.Text:lower()
        for _,v in ipairs(ScrollFrame:GetChildren()) do
            if v:IsA("Frame") then
                local label = v:FindFirstChildWhichIsA("TextLabel")
                if label then
                    if label.Text:lower():find(query) then
                        v.Visible = true
                    else
                        v.Visible = false
                    end
                end
            end
        end
        ScrollFrame.CanvasPosition = Vector2.new(0,0)
    end)
end

OkButton.MouseButton1Click:Connect(function()
    DisclaimScreen:Destroy()
    loadMainGUI()
end)
