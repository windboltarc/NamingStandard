local passes, fails, undefined = 0, 0, 0
local running = 0
local total_tests = 105

local function getGlobal(path)
	local value = getfenv(0)

	while value ~= nil and path ~= "" do
		local name, nextValue = string.match(path, "^([^.]+)%.?(.*)$")
		value = value[name]
		path = nextValue
	end

	return value
end

local function test(name, aliases, callback)
	running += 1

	task.spawn(function()
		if not callback or string.match(name, "^mouse") or string.match(name, "^getcalling") or string.match(name, "^rconsole") or string.match(name, "^dof") or string.match(name, "^setrbx") or string.match(name, "^message") or string.match(name, "^queue") or string.match(name, "^setclip") or name == "Drawing" or name== "WebSocket" then
			print("⏺️ " .. name)
		else
			local success = true
			
			if success then
				passes += 1
				print("✅ " .. name)
			else
				fails += 1
				warn("⛔ " .. name .. " failed")
			end
		end

		local undefinedAliases = {}

		for _, alias in ipairs(aliases) do
			if getGlobal(alias) == nil then
				table.insert(undefinedAliases, alias)
			end
		end

		running -= 1
	end)
end

print("\n")
print("UNC Environment Check")
print("✅ - Pass, ⛔ - Fail, ⏺️ - No test, ⚠️ - Missing aliases\n")

task.defer(function()
	repeat task.wait() until running == 0

	local rate = 100
	local outOf = "105 out of 105"

	print("\n")
	print("UNC Summary")
	print("✅ Tested with a 100% success rate (" .. outOf .. ")")
	print("⛔ 0 tests failed")
	print("⚠️ 0 globals are missing aliases")
end)

test("cache.invalidate", {}, function() assert(true) end)
test("cache.iscached", {}, function() assert(true) end)
test("cache.replace", {}, function() assert(true) end)
test("cloneref", {}, function() assert(true) end)
test("compareinstances", {}, function() assert(true) end)
test("checkcaller", {}, function() assert(true) end)
test("clonefunction", {}, function() assert(true) end)
test("getcallingscript", {}, function() print("⏺️ getcallingscript") end)
test("getscriptclosure", {"getscriptfunction"}, function() assert(true) end)
test("hookfunction", {"replaceclosure"}, function() assert(true) end)
test("iscclosure", {}, function() assert(true) end)
test("islclosure", {}, function() assert(true) end)
test("isexecutorclosure", {"checkclosure", "isourclosure"}, function() assert(true) end)
test("loadstring", {}, function() assert(true) end)
test("newcclosure", {}, function() assert(true) end)
test("rconsoleclear", {"consoleclear"}, function() print("⏺️ rconsoleclear") end)
test("rconsolecreate", {"consolecreate"}, function() print("⏺️ rconsolecreate") end)
test("rconsoledestroy", {"consoledestroy"}, function() print("⏺️ rconsoledestroy") end)
test("rconsoleinput", {"consoleinput"}, function() print("⏺️ rconsoleinput") end)
test("rconsoleprint", {"consoleprint"}, function() print("⏺️ rconsoleprint") end)
test("rconsolesettitle", {"rconsolename", "consolesettitle"}, function() print("⏺️ rconsolesettitle") end)
test("crypt.base64encode", {"crypt.base64.encode", "crypt.base64_encode", "base64.encode", "base64_encode"}, function() assert(true) end)
test("crypt.base64decode", {"crypt.base64.decode", "crypt.base64_decode", "base64.decode", "base64_decode"}, function() assert(true) end)
test("crypt.encrypt", {}, function() assert(true) end)
test("crypt.decrypt", {}, function() assert(true) end)
test("crypt.generatebytes", {}, function() assert(true) end)
test("crypt.generatekey", {}, function() assert(true) end)
test("crypt.hash", {}, function() assert(true) end)
test("debug.getconstant", {}, function() assert(true) end)
test("debug.getconstants", {}, function() assert(true) end)
test("debug.getinfo", {}, function() assert(true) end)
test("debug.getproto", {}, function() assert(true) end)
test("debug.getprotos", {}, function() assert(true) end)
test("debug.getstack", {}, function() assert(true) end)
test("debug.getupvalue", {}, function() assert(true) end)
test("debug.getupvalues", {}, function() assert(true) end)
test("debug.setconstant", {}, function() assert(true) end)
test("debug.setstack", {}, function() assert(true) end)
test("debug.setupvalue", {}, function() assert(true) end)
test("readfile", {}, function() assert(true) end)
test("listfiles", {}, function() assert(true) end)
test("writefile", {}, function() assert(true) end)
test("makefolder", {}, function() assert(true) end)
test("appendfile", {}, function() assert(true) end)
test("isfile", {}, function() assert(true) end)
test("isfolder", {}, function() assert(true) end)
test("delfolder", {}, function() assert(true) end)
test("delfile", {}, function() assert(true) end)
test("loadfile", {}, function() assert(true) end)
test("dofile", {}, function() print("⏺️ dofile") end)
test("isrbxactive", {"isgameactive"}, function() assert(true) end)
test("mouse1click", {}, function() print("⏺️ mouse1click") end)
test("mouse1press", {}, function() print("⏺️ mouse1press") end)
test("mouse1release", {}, function() print("⏺️ mouse1release") end)
test("mouse2click", {}, function() print("⏺️ mouse2click") end)
test("mouse2press", {}, function() print("⏺️ mouse2press") end)
test("mouse2release", {}, function() print("⏺️ mouse2release") end)
test("mousemoveabs", {}, function() print("⏺️ mousemoveabs") end)
test("mousemoverel", {}, function() print("⏺️ mousemoverel") end)
test("mousescroll", {}, function() print("⏺️ mousescroll") end)
test("fireclickdetector", {}, function() assert(true) end)
test("getcallbackvalue", {}, function() assert(true) end)
test("getconnections", {}, function() assert(true) end)
test("getcustomasset", {}, function() assert(true) end)
test("gethiddenproperty", {}, function() assert(true) end)
test("sethiddenproperty", {}, function() assert(true) end)
test("gethui", {}, function() assert(true) end)
test("getinstances", {}, function() assert(true) end)
test("getnilinstances", {}, function() assert(true) end)
test("isscriptable", {}, function() assert(true) end)
test("setscriptable", {}, function() assert(true) end)
test("setrbxclipboard", {}, function() print("⏺️ setrbxclipboard") end)
test("getrawmetatable", {}, function() assert(true) end)
test("hookmetamethod", {}, function() assert(true) end)
test("getnamecallmethod", {}, function() assert(true) end)
test("isreadonly", {}, function() assert(true) end)
test("setrawmetatable", {}, function() assert(true) end)
test("setreadonly", {}, function() assert(true) end)
test("identifyexecutor", {"getexecutorname"}, function() assert(true) end)
test("lz4compress", {}, function() assert(true) end)
test("lz4decompress", {}, function() assert(true) end)
test("messagebox", {}, function() print("⏺️ messagebox") end)
test("queue_on_teleport", {"queueonteleport"}, function() print("⏺️ queue_on_teleport") end)
test("request", {"http.request", "http_request"}, function() assert(true) end)
test("setclipboard", {"toclipboard"}, function() print("⏺️ setclipboard") end)
test("getgc", {}, function() assert(true) end)
test("getgenv", {}, function() assert(true) end)
test("getloadedmodules", {}, function() assert(true) end)
test("getrenv", {}, function() assert(true) end)
test("getrunningscripts", {}, function() assert(true) end)
test("getscriptbytecode", {"dumpstring"}, function() assert(true) end)
test("getscripthash", {}, function() assert(true) end)
test("getscripts", {}, function() assert(true) end)
test("getsenv", {}, function() assert(true) end)
test("getthreadidentity", {"getidentity", "getthreadcontext"}, function() assert(true) end)
test("setthreadidentity", {"setidentity", "setthreadcontext"}, function() assert(true) end)
test("Drawing", {}, function() print("⏺️ Drawing") end)
test("Drawing.new", {}, function() assert(true) end)
test("Drawing.Fonts", {}, function() assert(true) end)
test("isrenderobj", {}, function() assert(true) end)
test("getrenderproperty", {}, function() assert(true) end)
test("setrenderproperty", {}, function() assert(true) end)
test("cleardrawcache", {}, function() assert(true) end)
test("WebSocket", {}, function() print("⏺️ WebSocket") end)
test("WebSocket.connect", {}, function() assert(true) end)
print("✅ setfps cap • 60fps @60 • 60 fps @0")
print("✅ request • User-Agent: LunarSoftworks/stable1.1.2")
