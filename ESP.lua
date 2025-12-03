local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local CurrentTheme = {
	Background = Color3.fromRGB(35,35,35),
	Button = Color3.fromRGB(60,120,220),
	ButtonHover = Color3.fromRGB(80,150,255),
	TextColor = Color3.fromRGB(255,255,255),
	Entry = Color3.fromRGB(50,50,50)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPGui"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,400,0,250)
MainFrame.Position = UDim2.new(0.5,-200,0.5,-125)
MainFrame.BackgroundColor3 = CurrentTheme.Background
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,16)
MainCorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.Position = UDim2.new(0,0,0,0)
TopBar.BackgroundColor3 = CurrentTheme.Entry
TopBar.Parent = MainFrame
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0,16)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0,200,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "ESP GUI"
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 18
Title.TextColor3 = CurrentTheme.TextColor
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,40,0,30)
CloseButton.Position = UDim2.new(1,-50,0,5)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.RobotoMono
CloseButton.TextSize = 16
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseButton.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,8)
CloseCorner.Parent = CloseButton

local normalESPButton = Instance.new("TextButton")
normalESPButton.Size = UDim2.new(0,180,0,40)
normalESPButton.Position = UDim2.new(0,10,0,60)
normalESPButton.Text = "Normal ESP"
normalESPButton.BackgroundColor3 = CurrentTheme.Button
normalESPButton.TextColor3 = CurrentTheme.TextColor
normalESPButton.Font = Enum.Font.RobotoMono
normalESPButton.TextSize = 16
normalESPButton.Parent = MainFrame
local nc = Instance.new("UICorner")
nc.CornerRadius = UDim.new(0,8)
nc.Parent = normalESPButton

local teamESPButton = Instance.new("TextButton")
teamESPButton.Size = UDim2.new(0,180,0,40)
teamESPButton.Position = UDim2.new(0,10,0,110)
teamESPButton.Text = "Team ESP"
teamESPButton.BackgroundColor3 = CurrentTheme.Button
teamESPButton.TextColor3 = CurrentTheme.TextColor
teamESPButton.Font = Enum.Font.RobotoMono
teamESPButton.TextSize = 16
teamESPButton.Parent = MainFrame
local tc = Instance.new("UICorner")
tc.CornerRadius = UDim.new(0,8)
tc.Parent = teamESPButton

local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0,380,0,30)
ColorLabel.Position = UDim2.new(0,10,0,170)
ColorLabel.Text = "Color"
ColorLabel.TextColor3 = CurrentTheme.TextColor
ColorLabel.BackgroundColor3 = CurrentTheme.Entry
ColorLabel.Font = Enum.Font.RobotoMono
ColorLabel.TextSize = 16
ColorLabel.Parent = MainFrame
local clCorner = Instance.new("UICorner")
clCorner.CornerRadius = UDim.new(0,8)
clCorner.Parent = ColorLabel

local ColorSlider = Instance.new("Frame")
ColorSlider.Size = UDim2.new(0,360,0,10)
ColorSlider.Position = UDim2.new(0,20,0,200)
ColorSlider.BackgroundColor3 = Color3.new(1,1,1)
ColorSlider.Parent = MainFrame
local csCorner = Instance.new("UICorner")
csCorner.CornerRadius = UDim.new(0,8)
csCorner.Parent = ColorSlider

local UISlider = Instance.new("TextButton")
UISlider.Size = UDim2.new(0,20,1,0)
UISlider.Position = UDim2.new(0,0,0,0)
UISlider.BackgroundColor3 = Color3.fromRGB(60,120,220)
UISlider.BorderSizePixel = 0
UISlider.Text = ""
UISlider.Parent = ColorSlider
local usCorner = Instance.new("UICorner")
usCorner.CornerRadius = UDim.new(0,6)
usCorner.Parent = UISlider

local draggingSlider = false
UISlider.MouseButton1Down:Connect(function()
	draggingSlider = true
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSlider = false
	end
end)

local function getSliderColor()
	local pos = UISlider.Position.X.Offset / (ColorSlider.AbsoluteSize.X - UISlider.AbsoluteSize.X)
	return Color3.fromHSV(pos,1,1)
end

local normalESPEnabled = false
local teamESPEnabled = false
local espHighlights = {}

local function toggleESP(teamBased)
	if teamBased then
		teamESPEnabled = not teamESPEnabled
		normalESPEnabled = false
	else
		normalESPEnabled = not normalESPEnabled
		teamESPEnabled = false
	end
	
	for _,h in pairs(espHighlights) do
		if h and h.Parent then h:Destroy() end
	end
	espHighlights = {}
end

normalESPButton.MouseButton1Click:Connect(function()
	toggleESP(false)
end)
teamESPButton.MouseButton1Click:Connect(function()
	toggleESP(true)
end)

RunService.RenderStepped:Connect(function()
	if normalESPEnabled or teamESPEnabled then
		for _,p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				local existing = espHighlights[p]
				if not existing then
					local h = Instance.new("Highlight")
					h.Parent = CoreGui
					h.Adornee = p.Character
					h.FillTransparency = 0.6
					h.OutlineTransparency = 0.6
					espHighlights[p] = h
				end
				if normalESPEnabled then
					espHighlights[p].FillColor = getSliderColor()
					espHighlights[p].OutlineColor = getSliderColor()
				elseif teamESPEnabled then
					espHighlights[p].FillColor = p.TeamColor.Color
					espHighlights[p].OutlineColor = p.TeamColor.Color
				end
			end
		end
	else
		for _,h in pairs(espHighlights) do
			if h and h.Parent then h:Destroy() end
		end
		espHighlights = {}
	end
end)

local function tweenOpen()
	MainFrame.Position = UDim2.new(0.5,-200,0.5,-150)
	MainFrame.Size = UDim2.new(0,0,0,0)
	MainFrame.Visible = true
	TweenService:Create(MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,400,0,250),Position=UDim2.new(0.5,-200,0.5,-125)}):Play()
end
local function tweenClose()
	local t = TweenService:Create(MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,-200,0.5,-150)})
	t:Play()
	t.Completed:Wait()
	MainFrame.Visible = false
end

CloseButton.MouseButton1Click:Connect(tweenClose)

UserInputService.InputBegan:Connect(function(input,gpe)
	if input.KeyCode == Enum.KeyCode.K and not gpe then
		if MainFrame.Visible then
			tweenClose()
		else
			tweenOpen()
		end
	end
end)

ColorSlider:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if UISlider.Position.X.Offset > ColorSlider.AbsoluteSize.X - UISlider.AbsoluteSize.X then
		UISlider.Position = UDim2.new(0,ColorSlider.AbsoluteSize.X - UISlider.AbsoluteSize.X,0,0)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
		local newX = math.clamp(input.Position.X - ColorSlider.AbsolutePosition.X - UISlider.AbsoluteSize.X/2,0,ColorSlider.AbsoluteSize.X - UISlider.AbsoluteSize.X)
		UISlider.Position = UDim2.new(0,newX,0,0)
	end
end)
