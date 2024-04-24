--[[ HOW TO USE

----fileSystemUtil.loadStorage(Folder Name, Optional Path)
This retrieves the path of the folder name given.
Has an optional path parameter if your folder is nested in another
Creates a new folder if it cannot find one already

----fileSystemUtil.loadFile(Path, File Name)
This retrieves the file in the given path with the file name as a metatable
Creates a new file if it cannot find one already with blank json data

----fileSystemUtil:SetData(Index,Value)
Will add a new value in the JSON data on the {self:file}
Creates a new value if not already found in the file

----fileSystemUtil:GetData(Index)
Returns the data from the given Index in {self:file}
Returns nil if no data can be found

----fileSystemUtil:GetOrSetData(Index,Value)
Returns the data from the given Index in {self:file}
If it cannot find data, it will create new data with the Value
Returns new data if data is not found

----EXAMPLE

local myFolder = fileSystem.loadStorage("myFolder")
local myFile = fileSystem.loadFile(myFolder,"myFile.txt")

local cookies = myFile:GetData("Cookies")
print(cookies and cookies or "Value is nil")

myFile:SetData("Cookies",10)
cookies = myFile:GetData("Cookies")
print(cookies)

local bread = myFile:GetOrSetData("Bread",5)
print(bread)

]]--

local HttpService = game:GetService("HttpService")
local fileSystemUtil = {}
fileSystemUtil.__index = fileSystemUtil
function fileSystemUtil.loadStorage(folderName,path)
	local foundFolder = nil
	for _,folder in pairs(listfiles(path and path or "")) do
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
	local fileMeta = setmetatable({path = foundFile},fileSystemUtil)
	return fileMeta
end
function fileSystemUtil:SetData(id,data)
	local loadedData = HttpService:JSONDecode(readfile(self.path))
	loadedData[id] = data
	writefile(self.path,HttpService:JSONEncode(loadedData))
end
function fileSystemUtil:GetData(id)
	local loadedData = HttpService:JSONDecode(readfile(self.path))
	for index,value in pairs(loadedData) do
		if index == id then
			return value
		end
	end
	return nil
end

function fileSystemUtil:GetOrSetData(id,data)
	local currentData  = self:GetData(id)
	if currentData then return currentData end
	self:SetData(id,data)
	return self:GetData(id)
end
return fileSystemUtil
