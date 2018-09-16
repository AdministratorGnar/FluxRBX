--[[
	FLUX FRAMEWORK: VERSION_0.2
	
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
local Players = game:GetService("Players")

-- DEFINITIONS
local Gui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Modules = ReplicatedStorage:WaitForChild("Modules")

-- SETTINGS
local elementPrefix = "#"
local classPrefix = "$"

-- VARIBLES
local Flux = {}
local modules = {}
local classes = {}
local elements = {}
Flux.Loaded = false

-- INTERNAL FUNCTIONS
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

local function recursiveGetElements(dir)
	for _, element in pairs(dir:GetChildren()) do
		-- Add this element to it's class table.
		if not classes[element.ClassName] then
			classes[element.ClassName] = {}
		end
		table.insert(classes[element.ClassName], 1, element)
		
		-- If this is a tagged object then add to rhe elements table.
		if element.Name:sub(1, string.len(elementPrefix)) == elementPrefix then
			elements[element.Name:sub(string.len(elementPrefix)+1)] = element
		end
		recursiveGetElements(element)
	end
end

-- FLUX FUNCTIONS
Flux.element = function(name)
	if name:sub(1, string.len(classPrefix)) == classPrefix then
		if classes[name:sub(string.len(classPrefix)+1)] then
			return classes[name:sub(string.len(classPrefix)+1)]
		end
		return {}
	elseif elements[name] then
		return elements[name]
	else
		fluxInternalError("Requested element ("..name..") does not exist, "..debug.traceback())
	end
	return nil
end

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

-- CONNECTIONS
Gui.ChildAdded:connect(recursiveGetElements)

-- INITIATE
_G.Flux = Flux
recursiveGetModules(script)
recursiveGetModules(Modules)
Flux.require("ClientHandler")
_G.Flux.Loaded = true