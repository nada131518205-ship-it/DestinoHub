local HttpService = game:GetService("HttpService")
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local BASE = "https://destino-keys.nada131518205.workers.dev" -- confira se é o seu endereço real
local req = (syn and syn.request) or http_request or request

local function post(path, body)
	local r = req({
		Url = BASE .. path,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode(body),
	})
	print("[" .. path .. "]", r.StatusCode, tostring(r.Body):sub(1, 150))
	return r
end

local r = post("/load", { hwid = HWID })
if r.StatusCode == 200 then
	loadstring(r.Body)()
elseif r.StatusCode == 403 then
	local rr = post("/redeem", { key = getgenv().Key, hwid = HWID })
	if rr.StatusCode == 200 and HttpService:JSONDecode(rr.Body).ok then
		local r2 = post("/load", { hwid = HWID })
		if r2.StatusCode == 200 then loadstring(r2.Body)() end
	end
end
