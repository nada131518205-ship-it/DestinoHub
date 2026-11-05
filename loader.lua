local HttpService = game:GetService("HttpService")
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local BASE = "https://destino-keys.SEUUSER.workers.dev"
local req = (syn and syn.request) or http_request or request

local function post(path, body)
	return req({
		Url = BASE .. path,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode(body),
	})
end

local function carregar()
	local r = post("/load", { hwid = HWID })
	if r.StatusCode == 200 then
		local fn = loadstring(r.Body)
		if fn then fn() end
		return true
	end
	return false
end

if not carregar() then
	local r = post("/redeem", { key = getgenv().Key or "", hwid = HWID })
	local ok = r.StatusCode == 200 and HttpService:JSONDecode(r.Body).ok
	if ok then carregar() else warn("key inválida ou já usada") end
end
