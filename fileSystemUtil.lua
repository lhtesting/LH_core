local HttpService = game:GetService("HttpService")
local fileSystemUtil = {}
fileSystemUtil.__index = fileSystemUtil
function fileSystemUtil.loadStorage(folderName)
	local foundFolder = nil
	for _,folder in pairs(listfiles("")) do
		if folder == folderName then
			foundFolder  = folder
			break
		end
	end
	warn("Couldn't find Folder; Creating new folder with the name: "..folderName)
	makefolder(folderName)
	foundFolder = folderName
	return foundFolder
end
function fileSystemUtil.loadFile(path,fileName)
	local foundFile = nil
	for _,file in pairs(listfiles(path)) do
		if string.find(file,fileName) then
			foundFile  = file
			return foundFile
		end
	end
	warn("Couldn't find File; Creating new File with the name: "..fileName)
	writefile(`{path}/{fileName}`,HttpService:JSONEncode({}))
	foundFile = `{path}/{fileName}`
	local cachedFile = setmetatable({path = foundFile},fileSystemUtil)
	cachedFile:GetData()
	cachedFile:SetData()
	return cachedFile
end
function fileSystemUtil:SetData(id,data)
	local loadedData = HttpService:JSONDecode(readfile(self.path))
	loadedData[id] = data
	writefile(self.path,HttpService:JSONEncode(loadedData))
end
function fileSystemUtil:GetData(id,data)
	local loadedData = HttpService:JSONDecode(readfile(self.path))
	for index,value in pairs(data) do
		if index == id then
			return data
		end
	end
	return nil
end
return fileSystemUtil
