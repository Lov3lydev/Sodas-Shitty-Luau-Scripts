local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "ESPGui"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,400,0,300)
MainFrame.Position = UDim2.new(0.5,-200,0.5,-150)
MainFrame.BackgroundColor3 = Color3.fromRGB(35,35,35)
MainFrame.AnchorPoint = Vector2.new(0.5,0.5)
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,16)
MainFrame.Visible = true

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.Position = UDim2.new(0,0,0,0)
TopBar.BackgroundColor3 = Color3.fromRGB(50,50,50)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0,16)

local dragging = false
local dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
TopBar.InputBegan:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseButton1 then
		dragging=true
		dragStart=input.Position
		startPos=MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState==Enum.UserInputState.End then dragging=false end
		end)
	end
end)
TopBar.InputChanged:Connect(function(input)
	if input.UserInputType==Enum.UserInputType.MouseMovement then dragInput=input end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input==dragInput then update(input) end
end)

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,40,0,30)
CloseButton.Position = UDim2.new(1,-50,0,5)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.RobotoMono
CloseButton.TextSize = 16
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseButton.Parent = TopBar
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0,8)

local normalESPButton = Instance.new("TextButton")
normalESPButton.Size = UDim2.new(0,180,0,40)
normalESPButton.Position = UDim2.new(0,10,0,60)
normalESPButton.Text = "Normal ESP"
normalESPButton.BackgroundColor3 = Color3.fromRGB(60,120,220)
normalESPButton.TextColor3 = Color3.new(1,1,1)
normalESPButton.Font = Enum.Font.RobotoMono
normalESPButton.TextSize = 16
normalESPButton.Parent = MainFrame
Instance.new("UICorner", normalESPButton).CornerRadius = UDim.new(0,8)

local teamESPButton = Instance.new("TextButton")
teamESPButton.Size = UDim2.new(0,180,0,40)
teamESPButton.Position = UDim2.new(0,10,0,110)
teamESPButton.Text = "Team ESP"
teamESPButton.BackgroundColor3 = Color3.fromRGB(60,120,220)
teamESPButton.TextColor3 = Color3.new(1,1,1)
teamESPButton.Font = Enum.Font.RobotoMono
teamESPButton.TextSize = 16
teamESPButton.Parent = MainFrame
Instance.new("UICorner", teamESPButton).CornerRadius = UDim.new(0,8)

local distanceButton = Instance.new("TextButton")
distanceButton.Size = UDim2.new(0,180,0,40)
distanceButton.Position = UDim2.new(0,200,0,60)
distanceButton.Text = "Distance/User"
distanceButton.BackgroundColor3 = Color3.fromRGB(60,120,220)
distanceButton.TextColor3 = Color3.new(1,1,1)
distanceButton.Font = Enum.Font.RobotoMono
distanceButton.TextSize = 16
distanceButton.Parent = MainFrame
Instance.new("UICorner", distanceButton).CornerRadius = UDim.new(0,8)

local ColorSlider = Instance.new("Frame")
ColorSlider.Size = UDim2.new(0,360,0,10)
ColorSlider.Position = UDim2.new(0,20,0,200)
ColorSlider.BackgroundColor3 = Color3.new(1,1,1)
ColorSlider.Parent = MainFrame
Instance.new("UICorner", ColorSlider).CornerRadius = UDim.new(0,8)

local UISlider = Instance.new("TextButton")
UISlider.Size = UDim2.new(0,20,1,0)
UISlider.Position = UDim2.new(0,0,0,0)
UISlider.BackgroundColor3 = Color3.fromRGB(60,120,220)
UISlider.BorderSizePixel = 0
UISlider.Text = ""
UISlider.Parent = ColorSlider
Instance.new("UICorner", UISlider).CornerRadius = UDim.new(0,6)

local draggingSlider = false
UISlider.MouseButton1Down:Connect(function() draggingSlider=true end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 then draggingSlider=false end end)
local function getSliderColor()
	local pos = UISlider.Position.X.Offset/(ColorSlider.AbsoluteSize.X-UISlider.AbsoluteSize.X)
	return Color3.fromHSV(pos,1,1)
end

local normalESPEnabled=false
local teamESPEnabled=false
local distanceEnabled=false

local function removeAllHighlights()
	for _,p in pairs(Players:GetPlayers()) do
		if p.Character then
			for _,c in pairs(p.Character:GetDescendants()) do
				if (c:IsA("Highlight") or c:IsA("BillboardGui")) and (c.Name=="SodasHighlights" or c.Name=="SodasDistance") then
					c:Destroy()
				end
			end
		end
	end
end

local function toggleESP(buttonType)
	if buttonType=="normal" then
		normalESPEnabled = not normalESPEnabled
		if normalESPEnabled then teamESPEnabled=false else removeAllHighlights() end
	elseif buttonType=="team" then
		teamESPEnabled = not teamESPEnabled
		if teamESPEnabled then normalESPEnabled=false else removeAllHighlights() end
	end
end

normalESPButton.MouseButton1Click:Connect(function() toggleESP("normal") end)
teamESPButton.MouseButton1Click:Connect(function() toggleESP("team") end)
distanceButton.MouseButton1Click:Connect(function()
	distanceEnabled = not distanceEnabled
	if not distanceEnabled then removeAllHighlights() end
end)

RunService.RenderStepped:Connect(function()
	for _,p in pairs(Players:GetPlayers()) do
		if p~=LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			if normalESPEnabled or teamESPEnabled then
				for _,existing in pairs(p.Character:GetChildren()) do
					if existing:IsA("Highlight") and existing.Name=="SodasHighlights" then existing:Destroy() end
				end
				local h = Instance.new("Highlight")
				h.Name="SodasHighlights"
				h.Parent=p.Character
				h.Adornee=p.Character
				h.FillTransparency=0.6
				h.OutlineTransparency=0.6
				if normalESPEnabled then
					h.FillColor=getSliderColor()
					h.OutlineColor=getSliderColor()
				elseif teamESPEnabled then
					h.FillColor=p.TeamColor.Color
					h.OutlineColor=p.TeamColor.Color
				end
			end

			if distanceEnabled then
				local torso = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso")
				if torso then
					local label = torso:FindFirstChild("SodasDistance")
					if not label then
						local bill = Instance.new("BillboardGui")
						bill.Name="SodasDistance"
						bill.Size=UDim2.new(0,120,0,30)
						bill.Adornee=torso
						bill.AlwaysOnTop=true
						bill.Parent=torso
						local txt = Instance.new("TextLabel")
						txt.Size=UDim2.new(1,0,1,0)
						txt.BackgroundTransparency=1
						txt.TextColor3=Color3.new(1,1,1)
						txt.Font=Enum.Font.RobotoMono
						txt.TextSize=16
						txt.Parent=bill
					end
					torso.SodasDistance.TextLabel.Text=string.format("%s, %.1f",p.DisplayName,(LocalPlayer.Character.HumanoidRootPart.Position-p.Character.HumanoidRootPart.Position).Magnitude)
				end
			end
		end
	end
end)

local function removeAll()
	normalESPEnabled=false
	teamESPEnabled=false
	distanceEnabled=false
	removeAllHighlights()
	if ScreenGui then
		ScreenGui:Destroy()
	end
end

CloseButton.MouseButton1Click:Connect(removeAll)

UserInputService.InputBegan:Connect(function(input,gpe)
	if input.KeyCode==Enum.KeyCode.K and not gpe then
		MainFrame.Visible = not MainFrame.Visible
	elseif input.KeyCode==Enum.KeyCode.X then
		removeAll()
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if draggingSlider and input.UserInputType==Enum.UserInputType.MouseMovement then
		local newX = math.clamp(input.Position.X-ColorSlider.AbsolutePosition.X-UISlider.AbsoluteSize.X/2,0,ColorSlider.AbsoluteSize.X-UISlider.AbsoluteSize.X)
		UISlider.Position=UDim2.new(0,newX,0,0)
	end
end)
