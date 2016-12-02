JSON = assert(loadfile "JSON.lua")()

local fn = arg[1]
local f = io.open(fn, 'r')

-- Copyright 2011-2014, Gianluca Fiore © <forod.g@gmail.com>
--- Function equivalent to basename in POSIX systems
--@param str the path string
function basename(str)
	local name = string.gsub(str, "(.*/)(.*)", "%2")
	return name
end

function expand_line_into_video_document(line)
	local video_id = line:sub(7, -1)
	local doc = {}
	doc["_id"] = line
	doc["url"] = "https://vine.co/v/"..video_id
	doc["created_at"] = os.date("!%Y-%m-%dT%TZ")

	return doc
end

function expand_line_into_user_document(line)
	local user_id = line:sub(6, -1)
	local doc = {}

	doc["_id"] = line	
	doc["profile_url"] = "https://vine.co/u/"..user_id

	return doc
end

function expand_line_into_document(line)
	if string.find(line, "video:") then
		return expand_line_into_video_document(line)
	elseif string.find(line, "user:") then
		return expand_line_into_user_document(line)
	else
		error("cannot handle line "..line)
	end
end

local docs = {}

while true do
	local line = f:read()
	if line == nil then break end

	if not (string.find(line, "video:avatars") or string.find(line, "video:videos") or string.find(line, "video:thumbs")) then
		local ok, val = pcall(expand_line_into_document, line)

		if ok == true then
			table.insert(docs, val)
		end
	end
end

table.insert(docs, {_id="disco:"..basename(fn), done_at=os.date("!%Y-%m-%dT%TZ")})

print(JSON:encode({docs=docs}))
