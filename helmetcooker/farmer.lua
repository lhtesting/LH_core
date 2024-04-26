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
	local AF_ziptieNPC = HelmetFile:GetOrSetData("AF_ziptieNPC",false)
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
		if AF_ziptieNPC == true then
			inGameMenuAPI.sendMessage(`{prefix} REPLACING LOADOUT`,Color3.fromRGB(82, 166, 255))
			local agrm = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("AddGear")
			local rgrm = game:GetService("ReplicatedStorage").Remotes.Briefing.RemoveGear
			local cwrm = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("ChangeWeapon")
			local gearfolder = Players.LocalPlayer.MyData.Gear
			for _,item in gearfolder:GetChildren() do
				rgrm:FireServer(item.Name)
			end
			cwrm:FireServer("Rifle","Primary")
			cwrm:FireServer("Pistol","Secondary")
			for i=1,10,1 do
				agrm:FireServer("Zipties")
			end
		end
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

	local objUI = Players.LocalPlayer.PlayerGui:WaitForChild("HUD"):WaitForChild("Objectives")
	local lastObjCount = #objUI:WaitForChild("SubObjective"):WaitForChild("List"):GetChildren()
	

	if AF_ziptieNPC == true then
		local vectorList = {
			Vector3.new(-36, -29, -86),
			Vector3.new(-37, -33, -126),
			Vector3.new(19, -29, -86),
			Vector3.new(16, -33, -126),
			Vector3.new(17, -33, -127),
			Vector3.new(-37, -33, -127),
			Vector3.new(18, -33, -171),
			Vector3.new(-36, -33, -170),
			Vector3.new(11, -7, -41),
			Vector3.new(12, -7, -72),
			Vector3.new(-32, -7, -41),
			Vector3.new(-30, -7, -71),
			Vector3.new(-45, -4, 12),
			Vector3.new(-85, -4, -19),
			Vector3.new(-85, -4, -530),
			Vector3.new(-68, -3, -106),
			Vector3.new(-68, -3, -121),
			Vector3.new(-72, -3, -192),
			Vector3.new(-102, -4, -192),
			Vector3.new(-68, -3, -152),
			Vector3.new(-87, -4, -157),
			Vector3.new(-63, 41, -219),
			Vector3.new(-38, 41, -222),
			Vector3.new(-61, 41, -253),
			Vector3.new(-82, 41, -254),
			Vector3.new(-41, 21, -279),
			Vector3.new(-16, 21, -271),
			Vector3.new(-75, 33, -121),
			Vector3.new(-27, 33, -116),
			Vector3.new(-23, 33, -94),
			Vector3.new(-85, 33, -98)
		}
		for _,vector in pairs(vectorList) do
			MoveChar(CFrame.new(vector))
			task.wait(delayTime)
		end
		local civHostList = {}
		for _,npc in workspace:GetChildren() do
			if npc.Name == "Civilian" or npc.Name == "Hostile" then
				table.insert(civHostList,npc)
			end
		end
		MoveChar(workspace.Map.Objectives.EscapeZone.CFrame)
		task.wait(delayTime)
		for _,ziptieFound in Players.LocalPlayer.MyData.Gear:GetChildren() do
			if ziptieFound.Name == "Zipties" then
				ReplicatedStorage.Remotes.Gameplay.Inventory.EquipItem:FireServer("Zipties")
				local ziprqrm = Players.LocalPlayer.Character:WaitForChild("Zipties",5):WaitForChild("Use",5)
				for i=1,6,1 do
					for _,npc in pairs(civHostList) do
						ziprqrm:FireServer(npc)
						civHostList[npc] = nil
					end
				end
				table.sort(civHostList)
			end
		end
	end
	
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
