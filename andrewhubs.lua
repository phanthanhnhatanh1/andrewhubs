local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer

local character
local humanoid
local root

local flying = false
local noclip = false
local invisible = false
local godMode = false

local flySpeed = 50
local guiOpen = false
local language = "English"

local savedTransparency = {}
local savedCanCollide = {}

local Text = {
	English = {
		title = "AndrewHub",
		fly = "Fly",
		noclip = "Noclip",
		invisible = "Invisible",
		god = "God Mode",
		heal = "Heal",
		on = "ON",
		off = "OFF",
		speed = "Speed",
		footer = "Made by Andrew"
	},

	Vietnamese = {
		title = "AndrewHub",
		fly = "Bay",
		noclip = "Xuyên Tường",
		invisible = "Tàng Hình",
		god = "Bất Tử",
		heal = "Hồi Máu",
		on = "BẬT",
		off = "TẮT",
		speed = "Tốc Độ",
		footer = "Được tạo bởi Andrew"
	}
}

local function T(key)
	return Text[language][key]
end

local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")
	root = char:WaitForChild("HumanoidRootPart")

	savedTransparency = {}
	savedCanCollide = {}

	if noclip then
		for _, object in ipairs(character:GetDescendants()) do
			if object:IsA("BasePart") then
				savedCanCollide[object] = object.CanCollide
				object.CanCollide = false
			end
		end
	end

	if invisible then
		for _, object in ipairs(character:GetDescendants()) do
			if object:IsA("BasePart") or object:IsA("Decal") then
				savedTransparency[object] = object.Transparency
				object.Transparency = 1
			end
		end
	end
end

player.CharacterAdded:Connect(setupCharacter)

if player.Character then
	setupCharacter(player.Character)
end

local gui = Instance.new("ScreenGui")
gui.Name = "AndrewAdminGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.fromOffset(58, 58)
openButton.Position = UDim2.new(0, 18, 0.5, -29)
openButton.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
openButton.Text = "A"
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.TextSize = 28
openButton.Font = Enum.Font.GothamBold
openButton.AutoButtonColor = false
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(75, 75, 95)
openStroke.Thickness = 1
openStroke.Parent = openButton

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(0, 0)
main.Position = UDim2.new(0.5, -210, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(17, 17, 23)
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(65, 65, 80)
mainStroke.Thickness = 1
mainStroke.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -110, 0, 50)
title.Position = UDim2.fromOffset(18, 5)
title.BackgroundTransparency = 1
title.Text = T("title")
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.fromOffset(38, 38)
closeButton.Position = UDim2.new(1, -48, 0, 9)
closeButton.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
closeButton.Text = "×"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextSize = 24
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 9)
closeCorner.Parent = closeButton

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -30, 1, -105)
content.Position = UDim2.fromOffset(15, 58)
content.BackgroundTransparency = 1
content.Parent = main

local function makeButton(name, text, position)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.fromOffset(185, 58)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
	button.Text = text
	button.TextColor3 = Color3.new(1, 1, 1)
	button.TextSize = 15
	button.Font = Enum.Font.GothamBold
	button.AutoButtonColor = false
	button.Parent = content

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(55, 55, 68)
	stroke.Thickness = 1
	stroke.Parent = button

	return button
end

local flyButton = makeButton(
	"FlyButton",
	"✈ " .. T("fly") .. ": " .. T("off"),
	UDim2.fromOffset(0, 0)
)

local noclipButton = makeButton(
	"NoclipButton",
	"👻 " .. T("noclip") .. ": " .. T("off"),
	UDim2.fromOffset(195, 0)
)

local invisibleButton = makeButton(
	"InvisibleButton",
	"👁️ " .. T("invisible") .. ": " .. T("off"),
	UDim2.fromOffset(0, 70)
)

local godButton = makeButton(
	"GodButton",
	"🛡️ " .. T("god") .. ": " .. T("off"),
	UDim2.fromOffset(195, 70)
)

local healButton = makeButton(
	"HealButton",
	"❤️ " .. T("heal"),
	UDim2.fromOffset(0, 140)
)

local speedButton = makeButton(
	"SpeedButton",
	"⚡ " .. T("speed") .. ": " .. flySpeed,
	UDim2.fromOffset(195, 140)
)

local speedDown = makeButton(
	"SpeedDown",
	"−",
	UDim2.fromOffset(0, 210)
)

local speedUp = makeButton(
	"SpeedUp",
	"+",
	UDim2.fromOffset(195, 210)
)

local languageButton = Instance.new("TextButton")
languageButton.Size = UDim2.fromOffset(185, 40)
languageButton.Position = UDim2.fromOffset(0, 285)
languageButton.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
languageButton.Text = "🇬🇧 English  /  🇻🇳 Tiếng Việt"
languageButton.TextColor3 = Color3.new(1, 1, 1)
languageButton.TextSize = 11
languageButton.Font = Enum.Font.GothamBold
languageButton.Parent = content

local languageCorner = Instance.new("UICorner")
languageCorner.CornerRadius = UDim.new(0, 10)
languageCorner.Parent = languageButton

local footer = Instance.new("TextLabel")
footer.Size = UDim2.fromOffset(185, 40)
footer.Position = UDim2.fromOffset(195, 285)
footer.BackgroundTransparency = 1
footer.Text = T("footer")
footer.TextColor3 = Color3.fromRGB(125, 125, 140)
footer.TextSize = 10
footer.Font = Enum.Font.Gotham
footer.TextWrapped = true
footer.Parent = content

local function updateButtons()
	flyButton.Text = "✈ " .. T("fly") .. ": " .. (flying and T("on") or T("off"))
	noclipButton.Text = "👻 " .. T("noclip") .. ": " .. (noclip and T("on") or T("off"))
	invisibleButton.Text = "👁️ " .. T("invisible") .. ": " .. (invisible and T("on") or T("off"))
	godButton.Text = "🛡️ " .. T("god") .. ": " .. (godMode and T("on") or T("off"))
	healButton.Text = "❤️ " .. T("heal")
	speedButton.Text = "⚡ " .. T("speed") .. ": " .. flySpeed
	footer.Text = T("footer")
	title.Text = T("title")
end

local function setNoclip(enabled)
	noclip = enabled

	if character then
		if enabled then
			for _, object in ipairs(character:GetDescendants()) do
				if object:IsA("BasePart") then
					if savedCanCollide[object] == nil then
						savedCanCollide[object] = object.CanCollide
					end

					object.CanCollide = false
				end
			end
		else
			for _, object in ipairs(character:GetDescendants()) do
				if object:IsA("BasePart") then
					if savedCanCollide[object] ~= nil then
						object.CanCollide = savedCanCollide[object]
					end
				end
			end
		end
	end

	updateButtons()
end

local function setInvisible(enabled)
	invisible = enabled

	if character then
		if enabled then
			for _, object in ipairs(character:GetDescendants()) do
				if object:IsA("BasePart") or object:IsA("Decal") then
					if savedTransparency[object] == nil then
						savedTransparency[object] = object.Transparency
					end

					object.Transparency = 1
				end
			end
		else
			for _, object in ipairs(character:GetDescendants()) do
				if object:IsA("BasePart") or object:IsA("Decal") then
					if savedTransparency[object] ~= nil then
						object.Transparency = savedTransparency[object]
					end
				end
			end
		end
	end

	updateButtons()
end

local function setGodMode(enabled)
	godMode = enabled

	if humanoid then
		if enabled then
			humanoid.MaxHealth = math.huge
			humanoid.Health = math.huge
		else
			humanoid.MaxHealth = 100

			if humanoid.Health > 100 then
				humanoid.Health = 100
			end
		end
	end

	updateButtons()
end

flyButton.MouseButton1Click:Connect(function()
	flying = not flying

	if not flying and root then
		root.AssemblyLinearVelocity = Vector3.zero
	end

	updateButtons()
end)

noclipButton.MouseButton1Click:Connect(function()
	setNoclip(not noclip)
end)

invisibleButton.MouseButton1Click:Connect(function()
	setInvisible(not invisible)
end)

godButton.MouseButton1Click:Connect(function()
	setGodMode(not godMode)
end)

healButton.MouseButton1Click:Connect(function()
	if humanoid then
		if godMode then
			humanoid.Health = math.huge
		else
			humanoid.Health = humanoid.MaxHealth
		end
	end
end)

speedDown.MouseButton1Click:Connect(function()
	flySpeed = math.max(10, flySpeed - 10)
	updateButtons()
end)

speedUp.MouseButton1Click:Connect(function()
	flySpeed = math.min(10000, flySpeed + 10)
	updateButtons()
end)

speedButton.MouseButton1Click:Connect(function()
	if flySpeed < 100 then
		flySpeed = 100
	elseif flySpeed < 500 then
		flySpeed = 500
	elseif flySpeed < 1000 then
		flySpeed = 1000
	elseif flySpeed < 5000 then
		flySpeed = 5000
	elseif flySpeed < 10000 then
		flySpeed = 10000
	else
		flySpeed = 10
	end

	updateButtons()
end)

languageButton.MouseButton1Click:Connect(function()
	if language == "English" then
		language = "Vietnamese"
	else
		language = "English"
	end

	updateButtons()
end)

local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPosition = main.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

local openSize = UDim2.fromOffset(410, 400)

local function openGUI()
	if guiOpen then
		return
	end

	guiOpen = true
	main.Visible = true
	main.Size = UDim2.fromOffset(0, 0)

	TweenService:Create(
		main,
		TweenInfo.new(
			0.35,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		),
		{
			Size = openSize
		}
	):Play()
end

local function closeGUI()
	if not guiOpen then
		return
	end

	guiOpen = false

	local tween = TweenService:Create(
		main,
		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.In
		),
		{
			Size = UDim2.fromOffset(0, 0)
		}
	)

	tween:Play()

	tween.Completed:Once(function()
		if not guiOpen then
			main.Visible = false
		end
	end)
end

openButton.MouseButton1Click:Connect(function()
	if guiOpen then
		closeGUI()
	else
		openGUI()
	end
end)

closeButton.MouseButton1Click:Connect(closeGUI)

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.F9 then
		if guiOpen then
			closeGUI()
		else
			openGUI()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if not flying then
		return
	end

	if not character or not humanoid or not root then
		return
	end

	local currentCamera = workspace.CurrentCamera
	local direction = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		direction += currentCamera.CFrame.LookVector
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		direction -= currentCamera.CFrame.LookVector
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		direction -= currentCamera.CFrame.RightVector
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		direction += currentCamera.CFrame.RightVector
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		direction += Vector3.yAxis
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		direction -= Vector3.yAxis
	end

	if direction.Magnitude > 0 then
		direction = direction.Unit
	end

	root.AssemblyLinearVelocity = direction * flySpeed
end)

RunService.Stepped:Connect(function()
	if noclip and character then
		for _, object in ipairs(character:GetDescendants()) do
			if object:IsA("BasePart") then
				object.CanCollide = false
			end
		end
	end

	if godMode and humanoid then
		humanoid.Health = humanoid.MaxHealth
	end
end)

updateButtons()
