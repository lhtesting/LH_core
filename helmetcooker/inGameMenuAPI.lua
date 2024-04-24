local NewCMDPrompt = game:GetService("ReplicatedStorage"):WaitForChild("UI"):WaitForChild("EasterEgg"):WaitForChild("Frame"):Clone()
local psMsg = game:GetService("ReplicatedStorage").UI.EasterEgg:WaitForChild("Handler"):WaitForChild("Template"):Clone()
psMsg.Underdash:Destroy()
psMsg.Text = ""
local scrGui = Instance.new("ScreenGui")
scrGui.Parent = game:GetService("CoreGui")
local Players = game:GetService("Players")
NewCMDPrompt.Position = UDim2.new(0.5,0,0.5,0)
NewCMDPrompt.Parent = scrGui
NewCMDPrompt.ScrollingFrame.UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NewCMDPrompt.ScrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
NewCMDPrompt.TopBar.Right.Close.BackgroundTransparency = 0
NewCMDPrompt.TopBar.Right.Close.Activated:Connect(function()
	Players.LocalPlayer:Kick("Window Closed | Whatever was happening most likely finished.")
end)
local inGameMenuAPI = {}

function inGameMenuAPI.sendMessage(text,color)
	NewCMDPrompt.ScrollingFrame.CanvasPosition = Vector2.new(0, NewCMDPrompt.ScrollingFrame.AbsoluteCanvasSize.Y)
	local newMsg = psMsg:Clone()
	newMsg.Text = text
	newMsg.TextColor3 = color
	newMsg.TextTransparency = 0
	newMsg.LayoutOrder = #NewCMDPrompt.ScrollingFrame:GetChildren() + 1
	newMsg.Visible = true
	newMsg.Parent = NewCMDPrompt.ScrollingFrame
end
inGameMenuAPI.sendMessage("INFO: Click the Close button in the top right to stop the game",Color3.new(1,1,1))

return inGameMenuAPI
