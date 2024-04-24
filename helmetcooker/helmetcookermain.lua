if game.GameId == 4791585001 then
	local fileSystem = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/fileSystemUtil.lua'))()
	
	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	
	local LHFolder = fileSystem.loadStorage("Lookin_Hackable")
	local HelmetFile = fileSystem.loadFile(LHFolder,"helmet.txt")
	if game.PlaceId == 13815196156 then
		local mainMenuAPI = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/helmetcooker/mainMenuAPI.lua'))()
		HelmetFile:SetData("AF_Enabled",false)
		local newTab = mainMenuAPI.newMenu({
			"LH_CORE_TAB",
			"Lookin' Hackable",
			{Color3.fromRGB(33, 75, 255),Color3.fromRGB(167, 184, 230)},
			HelmetFile
		})
		newTab:Title("Auto-Farm V2")
		local cs = false
		newTab:PushButton("Start Auto-Farm",function()
			if cs == false then
				cs = true
				HelmetFile:SetData("AF_Enabled",true)
				task.wait(1)
				local args = {
					[1] = {
						["Difficulty"] = 5,
						["MinLevel"] = 0,
						["Name"] = "Decovenant",
						["CalarAllowed"] = false,
						["KaskaAllowed"] = false,
						["JoinMode"] = "Friends"
					}
				}
				ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Sessions"):WaitForChild("Create"):InvokeServer(unpack(args))
				task.wait(1)
				ReplicatedStorage.Remotes.Sessions:WaitForChild("Start"):FireServer()

			end
		end)
		newTab:Description("This will automatically create a match and start the autofarm.")
		newTab:InputBox("AF_levelCap","Limit Auto-Farm Level","100",true,function(text)
			print("set new max auto-farm level too "..text)
		end)
		newTab:InputBox("AF_tpSpeed","Teleport Delay","0.3",true,function(text)
			print("set new max tp-speed too "..text)
		end)
		newTab:Description("Highly recommended to keep this at 0.3. Increase based on wifi speed.")
		newTab:ToggleButton("AF_ziptieCivs","Ziptie Civilians",false,function(newState)
			print("ziptie civs is now "..newState == true and "true" or "false")
		end)
		newTab:ToggleButton("AF_ziptieHost","Ziptie Hostiles",false,function(newState)
			print("ziptie hostiles is now "..newState == true and "true" or "false")
		end)
		newTab:Line()
		newTab:Title("COOMING SOON")
	elseif game.PlaceId == 13943784614 then
		local autofarmEnabled = HelmetFile:GetOrSetData("AF_Enabled",false)
		if autofarmEnabled == true then
			local inGameMenuAPI = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/helmetcooker/inGameMenuAPI.lua'))()
			local prefix = "Auto-Farm V2 |"
			local plrLvl = Players.LocalPlayer:WaitForChild("Data"):WaitForChild("Level")
			inGameMenuAPI.sendMessage(`{prefix} LOADING...`,Color3.fromRGB(82, 166, 255))
			local Players = game:GetService("Players")

			local function MoveChar(cframe)
				local hrp = Players.LocalPlayer.Character.HumanoidRootPart
				hrp.CFrame = cframe
			end

			local preDt = HelmetFile:GetData("AF_tpSpeed","0.3")
			local delayTime = preDt ~= nil and preDt or 0.3
			local preLl = HelmetFile:GetOrSetData("AF_levelCap","100")
			local levelLimit = preLl ~= nil and preLl or 100
			local autoFarm = true

			if autoFarm == true then
				task.wait(8)
			end
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
					Part = workspace.Map.Objectives.Radar.Explosive1.Handle,
					Prompt = workspace.Map.Objectives.Radar.Explosive1.Handle.ProximityPrompt
				},
				{
					Part = workspace.Map.Objectives.Radar.Explosive2.Handle,
					Prompt = workspace.Map.Objectives.Radar.Explosive2.Handle.ProximityPrompt
				},
				{
					Part = workspace.Map.Objectives.EscapeZone,
					Prompt = false
				}
			}

			local continueWith = true
			for _,item in pairs(eventList) do
				if item.Part == nil or item.Prompt == nil then
					continueWith = false
					inGameMenuAPI.sendMessage(`{prefix} ERROR: COULDN'T FIND ALL POI LOCATIONS`,Color3.fromRGB(255, 0, 4))
					break
				end
			end

			if continueWith == true then
				inGameMenuAPI.sendMessage(`{prefix} STARTING`,Color3.fromRGB(82, 166, 255))
				if not Players.LocalPlayer.Character or not Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
					inGameMenuAPI.sendMessage(`{prefix} NOT SPAWNED; READYING UP`,Color3.fromRGB(82, 166, 255))
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("SetReady"):FireServer()
					task.wait(8)
					inGameMenuAPI.sendMessage(`{prefix} SKIPPING CUTSCENE`,Color3.fromRGB(82, 166, 255))
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Briefing"):WaitForChild("CutsceneSkipVote"):FireServer()
					task.wait(6)
				end
				for i = 1, #eventList, 1 do
					MoveChar(eventList[i].Part.CFrame)
					task.wait(delayTime)
					if eventList[i].Prompt ~= false and eventList[i].Prompt ~= nil then
						fireproximityprompt(eventList[i].Prompt)
					end
					task.wait(delayTime)
					inGameMenuAPI.sendMessage(`{prefix} TASK {i}/{#eventList} COMPLETED`,Color3.fromRGB(82, 166, 255))
				end
				inGameMenuAPI.sendMessage(`{prefix} COMPLETED`,Color3.fromRGB(82, 166, 255))
				if plrLvl.Value >= tonumber(levelLimit) then
					Players.LocalPlayer:Kick("REQUIREMENTS MET; KICKING PLAYER")
				end
				if autoFarm == true then
					inGameMenuAPI.sendMessage(`{prefix} REQUIREMENTS NOT MET; STARTING A NEW MATCH SOON`,Color3.fromRGB(82, 166, 255))
					task.wait(12)
					game:GetService("ReplicatedStorage").Remotes.Teleport.Replay:InvokeServer()
				end
			end
		end
	end
end
