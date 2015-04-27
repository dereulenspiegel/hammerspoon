-- === hs.openhab ===
--
-- Control your openhab controlled home
local openhab = {}

local http = require "hs.http"

local server = { baseurl = nil}

function printError(status, data)
	print("Got error from openhab: Status "..status)
	print("Response: "..data)
end

--- hs.openhab.new(url) -> table
--- Function
--- This creates a new table representing an openHAB server
---
--- Parameters:
---  * url - The URL of the openHAB server
---
--- Returns:
---  * A table representing the server
function openhab.new(url)
	s = server
	s.baseurl = url
	return s
end

--- hs.openhab:sendCommand(item, command)
--- Method
--- Send a command to an item
---
--- Parameters:
---  * item - The item name as a string
---  * command - The string representation of an openHAB command
function server:sendCommand(item, command)
	headers = {}
	headers["Content-Type"] = "text/plain"
	hs.http.asyncPost(self.baseurl.."/rest/items/"..item, command, headers, function(status, data, headers)
		if status ~= 201 then
			printError(status,data)
		end
	end)
end

--- hs.openab:getState(item [,callback]) -> [string]
--- Method
--- Retrieves the string representation of the current item state
---
--- Parameters:
---  * item - String containing the item name
---  * callback - callback which received the item status or nil
--- Returns:
---  * The string representation of the item state or nil, only of no
---    callback is specified
function server:getState(item, callback)
	if callback == nil then
		status, data, headers = http.get(self.baseurl.."/rest/items/"..item.."/state")
		if status == 200 then
			return data
		else
			printError(status,data)
			return nil
		end
	else
		hs.http.asyncGet(elf.baseurl.."/rest/items/"..item.."/state",nil, function(status, data, headers)
			if status == 200 then
				callback(data)
			else
				printError(status,data)
				callback(nil)
			end
		end)
	end
end

return openhab