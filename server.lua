--[[
	FLUX FRAMEWORK: VERSION_0.1
	
	Description:
	Flux Framework is a simple system to run and connect module scripts. This allows for easy base scripts and attributes.
	This main script holds all the base functions for the framework as well as the initiation code. If you would like to
	learn more about Flux Framework and how you can use it, visit: https://devforum.roblox.com/t/flux/101182
	
	Authors:
	AdministratorGnar
	
	Contributors:
	AxisAngles
]]

-- SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- DEFINITIONS.
local Modules = ReplicatedStorage:WaitForChild("Modules")

-- VARIBLES.
local Flux = {}
local modules = {}

-- INTERNAL FUNCTIONS.
local function fluxInternalError(msg)
	warn("FLUX INTERNAL ERROR: "..msg)
end

local function recursiveGetModules(dir)
	for _, module in pairs(dir:GetChildren()) do
		if module:IsA("ModuleScript") then
			modules[module.Name] = module
		end
		recursiveGetModules(module)
	end
end

-- FLUX FUNCTIONS.
Flux.require = function(name)
	if modules[name] then
		return require(modules[name])
	else
		fluxInternalError("Requested module ("..name..") does not exist, "..debug.traceback())
	end
	return nil
end

Flux.forcerequire = function(module)
	return require(module)
end

-- INITIATE
_G.Flux = Flux
recursiveGetModules(script)
recursiveGetModules(Modules)
Flux.require("GameHandler")