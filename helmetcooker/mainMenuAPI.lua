local Players = game:GetService("Players")

local isLoaded = false
local placeholderTab
repeat task.wait(1) until game:IsLoaded()
local helmetUIArea = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Menu"):WaitForChild("MainMenu")
local ButtonsArea = helmetUIArea:WaitForChild("Buttons")
task.wait(1)
for _,item in helmetUIArea:GetChildren() do
	if item:IsA("RayValue") and item.Name == "HMAPIL" then
		isLoaded = true
		placeholderTab = helmetUIArea:WaitForChild("PlaceholderTab")
	end
end
if isLoaded == false then
	local LOADEDVALUE = Instance.new("RayValue")
	LOADEDVALUE.Name = "HMAPIL"
	LOADEDVALUE.Parent = helmetUIArea
	----
	for _,textElement in Players.LocalPlayer.PlayerGui:GetDescendants() do
		if textElement:IsA("TextLabel") or textElement:IsA("TextButton") or textElement:IsA("TextBox") then
			if textElement.Name == "PerkName" then continue end
			textElement.TextStrokeTransparency = 0
		end
	end
	----
	local newLine = ButtonsArea.Line:Clone()
	newLine.LayoutOrder = -#ButtonsArea:GetChildren()
	newLine.Parent = ButtonsArea
	ButtonsArea.ClipsDescendants = false
	----
	placeholderTab = helmetUIArea.Options:Clone()
	placeholderTab.Visible = false
	placeholderTab.Name = "PlaceholderTab"
	placeholderTab.Parent = helmetUIArea
	local generateScript = placeholderTab:FindFirstChildWhichIsA("LocalScript",true)
	local presetToggle = generateScript.BoolValue:Clone();presetToggle.Parent=generateScript.Parent;presetToggle.Name = "PresetToggle";presetToggle.Visible=false;presetToggle.Title=""
	local presetPush = generateScript.BoolValue:Clone();presetPush.Parent=generateScript.Parent;presetPush.Name = "PresetPush";presetPush.Visible=false;presetPush.Title=""
	local presetInput = generateScript.NumberValue:Clone();presetInput.Parent=generateScript.Parent;presetInput.Name = "PresetInput";presetInput.Visible=false;presetInput.Title=""
	local presetTitle = generateScript.BoolValue:Clone();presetTitle.Parent=generateScript.Parent;presetTitle.Name = "PresetTitle";presetTitle.Visible=false;presetTitle.Title=""
	local presetDesc = generateScript.BoolValue:Clone();presetDesc.Parent=generateScript.Parent;presetDesc.Name = "PresetDesc";presetDesc.Visible=false;presetDesc.Title=""
	local presetLine = generateScript.BoolValue:Clone();presetLine.Parent=generateScript.Parent;presetLine.Name = "PresetLine";presetLine.Visible=false
	generateScript:Destroy()
	presetPush.ToggleSwitch.Text = "CLICK"
	presetPush.ToggleSwitch.Name = "Button"
	presetTitle.ToggleSwitch:Destroy()
	presetTitle.Title.Size = UDim2.new(1, 0, 0.9, 0)
	presetTitle.Title.TextXAlignment = Enum.TextXAlignment.Center
	local line = Instance.new("Frame")
	line.Size = UDim2.fromScale(1,0.1)
	line.AnchorPoint = Vector2.new(0.5,1)
	line.Position = UDim2.fromScale(0.5,1)
	line.BorderSizePixel = 0
	line.BackgroundColor3 = Color3.new(1,1,1)
	line.Parent = presetTitle
	presetDesc.ToggleSwitch:Destroy()
	presetDesc.Title.Size = UDim2.new(1, 0, 0.5, 0)
	presetDesc.TextSize = 12
	presetLine:ClearAllChildren()
	local pline = Instance.new("Frame")
	pline.Size = UDim2.fromScale(1,0.1)
	pline.AnchorPoint = Vector2.new(0.5,0.5)
	pline.Position = UDim2.fromScale(0.5,0.5)
	pline.BorderSizePixel = 0
	pline.BackgroundColor3 = Color3.new(1,1,1)
	pline.Parent = presetLine
	----
end

local mainMenuAPI = {}
mainMenuAPI.__index = mainMenuAPI
function mainMenuAPI.newMenu(menuData)
	local menuID = menuData[1]
	local menuTitle = menuData[2]
	local TabColor,BackgroundColor = menuData[3][1],menuData[3][2]
	local dataFile = menuData[4]
	----
	local newTab = helmetUIArea.PlaceholderTab:Clone()
	newTab.Name = menuID
	newTab.TopBar.BackgroundColor3 = TabColor
	newTab.TopBar.Title.Text = string.upper(menuTitle)
	newTab.BackgroundColor3 = BackgroundColor
	local newButton = ButtonsArea.Options:Clone()
	newButton.Button.Enabled = false
	newButton.Name = menuID
	newButton.Button.Enabled = true
	newButton.Text = string.upper(menuTitle)
	newButton.Parent = ButtonsArea
	newButton.UIListLayout = -#ButtonsArea:GetChildren()
	for _,frame in newTab.ScrollingFrame:GetChildren() do if frame:IsA("Frame") then frame:Destroy() end end
	----
	local classTab = setmetatable({tab = newTab,button = newButton,file = dataFile},mainMenuAPI)
	classTab:Line()
	classTab:Title()
	classTab:Description()
	classTab:ToggleButton()
	classTab:PushButton()
	classTab:InputBox()
	return classTab
end

function mainMenuAPI:_newElementSetup(newElement)
	newElement.LayoutOrder = #self.tab.ScrollingFrame:GetChildren()+1
	newElement.Visible = true
	newElement.Parent = self.tab.ScrollingFrame
end

function mainMenuAPI:Line()
	local newElement = placeholderTab.ScrollingFrame.PresetLine:Clone()
	----
	self:_newElementSetup(newElement)
end

function mainMenuAPI:Title(Title)
	local newElement = placeholderTab.ScrollingFrame.PresetTitle:Clone()
	newElement.Title.Text = Title
	----
	self:_newElementSetup(newElement)
end

function mainMenuAPI:Description(Description)
	local newElement = placeholderTab.ScrollingFrame.PresetDesc:Clone()
	newElement.Title.Text = Description
	----
	self:_newElementSetup(newElement)
end

function mainMenuAPI:ToggleButton(dataID,Title,PresetState,func)
	local newElement = placeholderTab.ScrollingFrame.PresetToggle:Clone()
	newElement.Title.Text = Title
	local IsActive = self.file:GetOrSetData(dataID,PresetState)
	newElement.ToggleSwitch.Activated:Connect(function()
		IsActive = not IsActive
		self.file:SetData(dataID,IsActive)
		newElement.ToggleSwitch.Text = IsActive and "ON" or "OFF"
		newElement.ToggleSwitch.BackgroundColor3 = IsActive and Color3.fromRGB(230,230,230) or Color3.fromRGB(20,20,20)
		func(IsActive)
	end)
	----
	self:_newElementSetup(newElement)
end

function mainMenuAPI:PushButton(Title,func)
	local newElement = placeholderTab.ScrollingFrame.PresetPush:Clone()
	newElement.Button.Activated:Connect(func)
	----
	self:_newElementSetup(newElement)
end

function mainMenuAPI:InputBox(dataID,Title,PresetState,numberOnly,func)
	local newElement = placeholderTab.ScrollingFrame.PresetInput:Clone()
	newElement.Title.Text = Title
	newElement.TextBox.PlaceholderText = PresetState
	local Data = self.file:GetOrSetData(dataID,PresetState)
	newElement.TextBox.Text = Data == PresetState and "" or Data
	newElement.TextBox.FocusLost:Connect(function()
		if numberOnly == true and tonumber(newElement.TextBox.Text) == nil then
			newElement.TextBox.Text = PresetState
		end
		self.file:SetData(dataID,newElement.TextBox.Text)
		func(newElement.TextBox.Text)
	end)
	----
	self:_newElementSetup(newElement)
end

return mainMenuAPI
