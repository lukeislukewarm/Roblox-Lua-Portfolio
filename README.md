This repository contains a single Luau file created to demonstrate scripting ability for review purposes. To meet the review requirement, the file combines multiple game systems into one organized script instead of separating it into modules. The script is long enough to show structure, logic flow and API knowledge without unnecessary filler.

Main file: PortfolioScript.lua

Script contents and features

Chasing enemy AI A physics based enemy that automatically hunts players. The system uses CFrame and AssemblyLinearVelocity for movement and prediction, and picks targets dynamically during gameplay. Features include: finds closest player and updates target while active  predicts movement using velocity for smoother chase behavior spins faster when close to the player teleports if the target gets too far ahead kills the player on contact using Humanoid health The behaviour is written as a small class using a metatable table pattern. Each enemy is managed individually inside the Heartbeat update.
Patrol NPC using PathfindingService A non-player character system that follows paths around the map. NPCs use PathfindingService to move between waypoints and can fall back to a looped square patrol if waypoints are not provided. Features include: reads waypoint parts from a folder named Waypoints inside the NPC model generates paths and walks through waypoints with Humanoid:MoveTo continues patrolling as long as the model exists • simple retry behaviour if pathfinding fails This system demonstrates navigation logic and basic state handling in a reusable form.
Gamepass tool giver A server-side system that gives a tool to players who own a specific gamepass. Ownership checks are cached to reduce API calls and tools are granted instantly when purchased. Features include:  automatic tool grant on join when owned immediate tool grant when purchased in game checks both Backpack and Character to avoid duplicates requires a Tool with the same name inside ServerStorage to function This part demonstrates handling MarketplaceService, monetisation logic and inventory integration.


Purpose

This script is intended as a self-contained demonstration of Roblox development ability. It shows:
use of core Roblox services including Players, RunService, PathfindingService, MarketplaceService and ServerStorage
control of physics-based movement and CFrame manipulation
 implementatin of class-style code using metatables
NPC behaviour and pathfinding logic
safe and practical gamepass reward handling
 clean structure, readable flow, minimal but clear comments
The goal is to present real gameplay-ready systems in one file for review, reflecting how I approach structuring and writing server logic in production projects.
