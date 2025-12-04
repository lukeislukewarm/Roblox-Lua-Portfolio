-- portfolio script showing ai, patrol npc and gamepass tool giver in one file

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local pathfinding = game:GetService("PathfindingService")
local marketplace = game:GetService("MarketplaceService")
local storage = game:GetService("ServerStorage")

local gamepass_id = 1393914426
local tool_name = "PremiumTool"

local enemy_folder = workspace:FindFirstChild("HairdryerEnemies")
local patrol_folder = workspace:FindFirstChild("PatrolNPCs")

local function root(char)
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end

local enemy = {}
enemy.__index = enemy

function enemy.new(model)
	local self = setmetatable({}, enemy)
	self.model = model
	self.root = root(model)
	self.hum = model:FindFirstChildOfClass("Humanoid")
	self.min_dist = 10
	self.speed_reduce = 5
	self.teleport_range = 120
	self.spin_speed = 1
	self.fast_spin = 6
	self.target = nil
	self.active = true
	return self
end

function enemy:find_target()
	local best, dist = nil, math.huge
	for _,plr in pairs(players:GetPlayers()) do
		local r = root(plr.Character)
		if r then
			local d = (r.Position - self.root.Position).Magnitude
			if d < dist then best,dist = plr,d end
		end
	end
	self.target = best
end

function enemy:update(dt)
	if not self.target then self:find_target() return end

	local char = self.target.Character
	local r = root(char)
	if not r then return end

	local dist = (r.Position - self.root.Position).Magnitude

	if dist > self.teleport_range then
		self.root.CFrame = r.CFrame * CFrame.new(0,0,self.min_dist+2)
	end

	local pred = r.Position + (r.AssemblyLinearVelocity * 0.25)
	local dir = (pred - self.root.Position).Unit
	local hum = char:FindFirstChildOfClass("Humanoid")
	local speed = (hum and hum.WalkSpeed or 16) - self.speed_reduce
	self.root.AssemblyLinearVelocity = dir * speed

	local rot = (dist < 25) and self.fast_spin or self.spin_speed
	self.root.CFrame = self.root.CFrame * CFrame.Angles(0, math.rad(rot * dt*60), 0)

	if dist < self.min_dist then
		if hum then hum.Health = 0 end
		self.target = nil
	end
end

local patrol = {}
patrol.__index = patrol

function patrol.new(model)
	local self = setmetatable({}, patrol)
	self.model = model
	self.hum = model:FindFirstChildOfClass("Humanoid")
	self.root = root(model)
	self.points = {}
	self.index = 1

	local folder = model:FindFirstChild("Waypoints")
	if folder then
		for _,p in ipairs(folder:GetChildren()) do
			if p:IsA("BasePart") then table.insert(self.points, p.Position) end
		end
	end

	if #self.points == 0 then
		local o = self.root.Position
		local s = 20
		self.points = {o+Vector3.new(s,0,0), o+Vector3.new(s,0,s), o+Vector3.new(0,0,s), o}
	end

	return self
end

function patrol:next()
	self.index = self.index + 1
	if self.index > #self.points then self.index = 1 end
	return self.points[self.index]
end

function patrol:start()
	task.spawn(function()
		while self.model.Parent do
			local dest = self:next()
			local path = pathfinding:CreatePath()
			path:ComputeAsync(self.root.Position, dest)

			if path.Status == Enum.PathStatus.Success then
				for _,wp in ipairs(path:GetWaypoints()) do
					self.hum:MoveTo(wp.Position)
					self.hum.MoveToFinished:Wait()
				end
			end
			task.wait(0.3)
		end
	end)
end

local owns = {}

local function give(plr)
	local tool = storage:FindFirstChild(tool_name)
	if not tool then return end
	if plr.Backpack:FindFirstChild(tool_name) then return end
	tool:Clone().Parent = plr.Backpack
end

local function check(plr)
	if owns[plr.UserId] ~= nil then return owns[plr.UserId] end
	local ok,res = pcall(function()
		return marketplace:UserOwnsGamePassAsync(plr.UserId, gamepass_id)
	end)
	owns[plr.UserId] = res and ok
	return owns[plr.UserId]
end

players.PlayerAdded:Connect(function(plr)
	if check(plr) then give(plr) end
end)

marketplace.PromptGamePassPurchaseFinished:Connect(function(plr,id,buy)
	if id==gamepass_id and buy then give(plr) end
end)

local active_enemies = {}
local active_patrols = {}

if enemy_folder then
	for _,m in pairs(enemy_folder:GetChildren()) do
		local e = enemy.new(m)
		table.insert(active_enemies, e)
	end
end

if patrol_folder then
	for _,m in pairs(patrol_folder:GetChildren()) do
		local p = patrol.new(m)
		table.insert(active_patrols, p)
		p:start()
	end
end

runservice.Heartbeat:Connect(function(dt)
	for _,e in pairs(active_enemies) do e:update(dt) end
end)
