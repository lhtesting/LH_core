local fileSystem = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/fileSystemUtil.lua'))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LHFolder = fileSystem.loadStorage("Lookin_Hackable")
local Helmet_File = fileSystem.loadFile(LHFolder,"helmet.txt")
return function (HelmetFile)
	local inGameMenuAPI = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/helmetcooker/inGameMenuAPI.lua'))()
	local prefix = "Auto-Farm V2 |"
	local plrLvl = Players.LocalPlayer:WaitForChild("Data"):WaitForChild("Level")
	inGameMenuAPI.sendMessage(`{prefix} LOADING...`,Color3.fromRGB(82, 166, 255))

	local function MoveChar(cframe)
		local hrp = Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		hrp.CFrame = cframe
	end

	local preDt = HelmetFile:GetOrSetData("AF_tpSpeed","0.3")
	local delayTime = preDt
	local preLl = tonumber(HelmetFile:GetOrSetData("AF_levelCap","100"))
	preLl = preLl > 1 and preLl - 1 or 1
	local levelLimit = (((preLl*(preLl+1))/2)*500)
	local LEXP = Players.LocalPlayer.Data.EXP.Value
	local LLevel = Players.LocalPlayer.Data.Level.Value
	local lastXPCount = (LEXP) + (((LLevel*(LLevel+1))/2)*500)
	local XPGAINED = tonumber(HelmetFile:GetOrSetData("AF_XPGAIN","0"))
	local autoFarm = true
	inGameMenuAPI.sendMessage(`{prefix} LOADED, CHECKING...`,Color3.fromRGB(82, 166, 255))
	local eventList = {
		{
			Part = workspace.Map.Geometry.CameraRoom.KeycardSpawns.Keycard.Base,
			Prompt = workspace.Map.Geometry.CameraRoom.KeycardSpawns.Keycard.Base.GrabPrompt
		},
		{
			Part = workspace.Map.Objectives.ControlLever.Handle,
			Prompt = workspace.Map.Objectives.ControlLever.Handle.ProximityPrompt
		},
		{
			Part = workspace.Map.Objectives.Radio.Handle,
			Prompt = workspace.Map.Objectives.Radio.Handle.ProximityPrompt
		},
		{
			{
				Part = workspace.Map.Objectives.Radar.Explosive1.Handle,
				Prompt = workspace.Map.Objectives.Radar.Explosive1.Handle.ProximityPrompt
			},
			{
				Part = workspace.Map.Objectives.Radar.Explosive2.Handle,
				Prompt = workspace.Map.Objectives.Radar.Explosive2.Handle.ProximityPrompt
			}

		},
		{
			Part = workspace.Map.Objectives.EscapeZone,
			Prompt = false
		}
	}

	local continueWith = false
	repeat
		local nilPartFound = false
		for _,item in pairs(eventList) do
			if item.Part == nil or item.Prompt == nil then
				if item[1] ~= nil and type(item[1]) == "table" then
					for _,item2 in pairs(item) do
						if item2.Part == nil or item2.Prompt == nil then
							nilPartFound = true
							inGameMenuAPI.sendMessage(`{prefix} WARNING: COULDN'T FIND ALL POI LOCATIONS | RETRYING`,Color3.fromRGB(255, 206, 90))
							break
						end
					end
				else
					nilPartFound = true
					inGameMenuAPI.sendMessage(`{prefix} WARNING: COULDN'T FIND ALL POI LOCATIONS | RETRYING`,Color3.fromRGB(255, 206, 90))
					break
				end
			end
		end
		if nilPartFound == false then continueWith = true end
		task.wait(1)
	until continueWith == true
	inGameMenuAPI.sendMessage(`{prefix} ALL POI LOCATIONS LOADED`,Color3.fromRGB(82, 166, 255))
	inGameMenuAPI.sendMessage(`{prefix} STARTING`,Color3.fromRGB(82, 166, 255))
	if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		inGameMenuAPI.sendMessage(`{prefix} NOT SPAWNED; READYING UP`,Color3.fromRGB(82, 166, 255))
		repeat
			ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("SetReady"):FireServer()
			task.wait(0.1)
		until ReplicatedStorage.Values.MissionStartTimestamp.Value ~= 0
		inGameMenuAPI.sendMessage(`{prefix} SKIPPING CUTSCENE`,Color3.fromRGB(82, 166, 255))
		local chrLoad = false
		repeat
			ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("CutsceneSkipVote"):FireServer()
			if Players.LocalPlayer.Character then
				chrLoad = true
			end
			if workspace:FindFirstChild(Players.LocalPlayer.Name) then
				chrLoad = true
			end
			task.wait(0.1)
		until chrLoad == true
	end

	local objUI = Players.LocalPlayer.PlayerGui.HUD.Objectives
	local lastObjCount = #objUI:WaitForChild("SubObjective"):WaitForChild("List"):GetChildren()

	for i = 1, #eventList, 1 do
		if eventList[i].Part == nil or eventList[i].Prompt == nil then
			repeat
				for _,tsk in pairs(eventList[i]) do
					MoveChar(tsk.Part.CFrame)
					task.wait(delayTime)
					if tsk.Prompt ~= false and tsk.Prompt ~= nil then
						fireproximityprompt(tsk.Prompt)
					end
					task.wait(delayTime)
				end
			until #objUI:WaitForChild("SubObjective"):WaitForChild("List"):GetChildren() > lastObjCount
			lastObjCount = #objUI:WaitForChild("SubObjective"):WaitForChild("List"):GetChildren()
			task.wait(delayTime)
		else
			MoveChar(eventList[i].Part.CFrame)
			task.wait(delayTime)
			if eventList[i].Prompt ~= false and eventList[i].Prompt ~= nil then
				repeat
					fireproximityprompt(eventList[i].Prompt)
					task.wait()
				until #objUI:WaitForChild("SubObjective"):WaitForChild("List"):GetChildren() > lastObjCount
				lastObjCount = #objUI:WaitForChild("SubObjective"):WaitForChild("List"):GetChildren()
			end
		end
		task.wait(delayTime)
		inGameMenuAPI.sendMessage(`{prefix} TASK {i}/{#eventList} COMPLETED`,Color3.fromRGB(82, 166, 255))
	end
	inGameMenuAPI.sendMessage(`{prefix} COMPLETED`,Color3.fromRGB(82, 166, 255))
	inGameMenuAPI.sendMessage(`{prefix} WAITING FOR SCORE`,Color3.fromRGB(82, 166, 255))
	local winframe = nil
	local foundXP = false
	repeat
		winframe = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MissionComplete")
		task.wait()
	until winframe ~= nil
	for _,entry in winframe.Frame.ScrollingFrame:GetChildren() do
		if entry:IsA("TextButton") then
			if string.find(entry.Text,"TOTAL...") then
				foundXP = true
				local xpgain33 = tonumber(string.split(entry.Text,"TOTAL...")[2])
				inGameMenuAPI.sendMessage(`{prefix} GAINED IN MATCH: {xpgain33}`,Color3.fromRGB(82, 166, 255))
				XPGAINED += xpgain33
				HelmetFile:SetData("AF_XPGAIN",tostring(XPGAINED))
			end
		end
	end
	winframe.Frame.ScrollingFrame.ChildAdded:Connect(function()
		if foundXP == false then
			for _,entry in winframe.Frame.ScrollingFrame:GetChildren() do
				if entry:IsA("TextButton") then
					if string.find(entry.Text,"TOTAL...") then
						foundXP = true
						local xpgain33 = tonumber(string.split(entry.Text,"TOTAL...")[2])
						inGameMenuAPI.sendMessage(`{prefix} GAINED IN MATCH: {xpgain33}`,Color3.fromRGB(82, 166, 255))
						XPGAINED += xpgain33
						HelmetFile:SetData("AF_XPGAIN",tostring(XPGAINED))
					end
				end
			end
		end
	end)
	repeat task.wait() until foundXP == true
	inGameMenuAPI.sendMessage(`{prefix} GAINED IN TOTAL: {XPGAINED}`,Color3.fromRGB(82, 166, 255))
	local admdly = true
	if lastXPCount + XPGAINED >= levelLimit then
		inGameMenuAPI.sendMessage(`{prefix} {lastXPCount + XPGAINED} IS GREATER THAN {levelLimit}`,Color3.fromRGB(82, 166, 255))
		inGameMenuAPI.sendMessage(`{prefix} REQUIREMENTS MET; SENDING TO LOBBY`,Color3.fromRGB(82, 166, 255))
		if admdly == true then task.wait(2) end
		game:GetService("ReplicatedStorage").Remotes.Teleport.Return:InvokeServer()
	end
	if autoFarm == true then
		inGameMenuAPI.sendMessage(`{prefix} REQUIREMENTS NOT MET; STARTING A NEW MATCH SOON`,Color3.fromRGB(82, 166, 255))
		if admdly == true then task.wait(2) end
		game:GetService("ReplicatedStorage").Remotes.Teleport.Replay:InvokeServer()
	end
end
