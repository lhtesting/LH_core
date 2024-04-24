local NewCMDPrompt = game:GetService("ReplicatedStorage"):WaitForChild("UI"):WaitForChild("EasterEgg"):WaitForChild("Frame"):Clone()
local psMsg = game:GetService("ReplicatedStorage").UI.EasterEgg:WaitForChild("Handler"):WaitForChild("Template"):Clone()
psMsg.Underdash:Destroy()
psMsg.Text = ""
local scrGui = Instance.new("ScreenGui")
scrGui.Parent = game:GetService("CoreGui")
local Players = game:GetService("Players")
NewCMDPrompt.Position = UDim2.new(0.5,0,0.5,0)
NewCMDPrompt.Parent = scrGui
game:GetService("ReplicatedStorage").UI.EasterEgg.Frame.TopBar.Right.Close.BackgroundTransparency = 0
game:GetService("ReplicatedStorage").UI.EasterEgg.Frame.TopBar.Right.Close.Activated:Connect(function()
	Players.LocalPlayer:Kick("Window Closed | Whatever was happening most likely finished.")
end)
local inGameMenuAPI = {}

function inGameMenuAPI.sendMessage(text,color)
	NewCMDPrompt.ScrollingFrame.CanvasPosition = Vector2.new(0, NewCMDPrompt.ScrollingFrame.AbsoluteCanvasSize.Y)
	local newMsg:TextButton = psMsg:Clone()
	newMsg.Text = text
	newMsg.TextColor3 = color
	newMsg.Visible = true
	newMsg.Parent = NewCMDPrompt.ScrollingFrame
end

return inGameMenuAPI
