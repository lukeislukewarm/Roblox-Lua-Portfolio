local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerStorage = game:GetService("ServerStorage")

-- Set these to match your game
local GAMEPASS_ID = 1393914426
local TOOL_NAME = "PremiumTool"

local ownershipCache = {}

local function getToolTemplate()
	local tool = ServerStorage:FindFirstChild(TOOL_NAME)
	if not tool or not tool:IsA("Tool") then
		warn("GamepassToolGiver: Tool '" .. TOOL_NAME .. "' not found in ServerStorage")
		return nil
	end
	return tool
end

local function playerOwnsGamepass(player)
	if ownershipCache[player.UserId] ~= nil then
		return ownershipCache[player.UserId]
	end

	local success, result = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, GAMEPASS_ID)
	end)

	if not success then
		warn("GamepassToolGiver: Failed to check gamepass ownership for", player, result)
		return false
	end

	ownershipCache[player.UserId] = result
	return result
end

local function giveTool(player)
	local backpack = player:FindFirstChildOfClass("Backpack")
	if not backpack then
		return
	end

	if backpack:FindFirstChild(TOOL_NAME) then
		return
	end
	if player.Character and player.Character:FindFirstChild(TOOL_NAME) then
		return
	end

	local template = getToolTemplate()
	if not template then
		return
	end

	local toolClone = template:Clone()
	toolClone.Parent = backpack
end

local function onPlayerAdded(player)
	if playerOwnsGamepass(player) then
		giveTool(player)
	end
end

local function onPromptFinished(player, purchasedPassId, wasPurchased)
	if purchasedPassId ~= GAMEPASS_ID then
		return
	end

	if not wasPurchased then
		return
	end

	ownershipCache[player.UserId] = true
	giveTool(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(onPlayerAdded, player)
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(onPromptFinished)