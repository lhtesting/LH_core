if game.GameId == 4791585001 then
	local fileSystem = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/fileSystemUtil.lua'))()

	local Players = game:GetService("Players")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	local LHFolder = fileSystem.loadStorage("Lookin_Hackable")
	local HelmetFile = fileSystem.loadFile(LHFolder,"helmet.txt")
	if game.PlaceId == 13815196156 then
		local mainMenuAPI = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/helmetcooker/mainMenuAPI.lua'))()
		HelmetFile:SetData("AF_Enabled",false)
		HelmetFile:SetData("AF_XPGAIN","0")
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
		newTab:Description("Highly recommended to keep this at 0.3. Increase if you're having problems completing.")
		newTab:ToggleButton("AF_ziptieNPC","Ziptie NPCs",false,function(newState)
			print("ziptie civs is now "..newState == true and "true" or "false")
		end)
		newTab:Description("Increases XP gain, turning this on wipes your loadout!")
		newTab:Line()
		newTab:Title("COOMING SOON")
	elseif game.PlaceId == 13943784614 then
		local autofarmEnabled = HelmetFile:GetOrSetData("AF_Enabled",false)
		if autofarmEnabled == true then
			local func = loadstring(game:HttpGet('https://raw.githubusercontent.com/lhtesting/LH_core/main/helmetcooker/farmer.lua'))()
			func(HelmetFile)
		end
	end
end
