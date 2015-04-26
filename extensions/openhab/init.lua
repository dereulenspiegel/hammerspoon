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

function openhab.new(url)
	s = server
	s.baseurl = url
	return s
end

function server:sendCommand(item, command)
	headers = {}
	headers["Content-Type"] = "text/plain"
	status, data, headers = http.post(self.baseurl.."/rest/items/"..item, command, headers)

	if status ~= 201 then
		printError(status,data)
	end
end

function server:getState(item)
	status, data, headers = http.get(self.baseurl.."/rest/items/"..item.."/state")
	if status == 200 then
		return data
	else
		printError(status,data)
		return nil
	end
end

return openhab