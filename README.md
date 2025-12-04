# Roblox-Lua-Portfolio
This is my portfolio
Roblox Lua Portfolio

This repository contains two advanced Roblox Lua systems that demonstrate gameplay programming, use of services, and clean server-side architecture.

1. Hairdryer Enemy AI
File: HairdryerEnemy.lua

A physics based AI enemy that actively chases a player. It matches speed, maintains distance, teleports to catch up if too far, and kills the player on contact through ragdoll behavior.

Features:
Locates closest player automatically
Speed matching system to keep tension
Maintains a standoff distance of around 10 studs
Teleports closer if the player outruns it
Ragdoll + instant kill mechanic
Rotation speeds up when near target for visual tension

Requirements:
Script placed inside the enemy model
Model must contain a Humanoid
Attachment named BlowAttachment for effects

2. Gamepass Tool Giver
File: GamepassToolGiver.lua

A server side system that grants tools to gamepass owners instantly on join or immediately upon purchase.

Features:
Detects ownership using MarketplaceService
Gives tool automatically on join if owned
Gives tool instantly after purchase confirmation
Ownership caching to reduce calls
Prevents duplicate tools

Setup steps:
1. Place script inside ServerScriptService
2. Put a Tool inside ServerStorage using the same name as TOOL_NAME
3. Change GAMEPASS_ID to your own id in the script

These projects demonstrate scripting ability in game services, monetization systems, replication-safe tool handling, and structured code suitable for production.

Suitable for portfolio and professional demonstration.
