module("ResourceManager", package.seeall)

IMAGE_PATH = "assets/images/"
FONT_PATH = "assets/fonts/"
SOUND_PATH = "assets/sounds/"
MAP_PATH = "assets/maps/"

local cache = {}

function ResourceManager:get(name)
	if (not self:loaded(name)) then
		self:load(name)
	end
	
	return cache[name]
end

function ResourceManager:loaded(name)
	return cache[name] ~= nil
end

function ResourceManager:load(name)
	local resourceDefinition = ResourceDefinitions:get(name)
	
	if not resourceDefinition then
		print("ERROR: Missing resource definition for " .. name .. ".")
	else
		local resource
		
		if (resourceDefinition.type == RESOURCE_TYPE_IMAGE) then
			resource = self:loadImage(resourceDefinition)
		elseif (resourceDefinition.type == RESOURCE_TYPE_TILED_IMAGE) then
			resource = self:loadTiledImage(resourceDefinition)
		elseif (resourceDefinition.type == RESOURCE_TYPE_FONT) then
			resource = self:loadFont(resourceDefinition)
		elseif (resourceDefinition.type == RESOURCE_TYPE_SOUND) then
			resource = self:loadSound(resourceDefinition)
		elseif (resourceDefinition.type == RESOURCE_TYPE_MAP) then
			resource = self:loadMap(resourceDefinition)
		end
		
		cache[name] = resource
	end
end

function ResourceManager:loadImage(definition)
	local image
	local filePath = IMAGE_PATH .. definition.fileName
	
	if definition.coords then
		image = self:loadGfxQuad2D(filePath, definition.coords)
	else
		local halfWidth = definition.width / 2
		local halfHeight = definition.height / 2
		image = self:loadGfxQuad2D(filePath, {-halfWidth, -halfHeight, halfWidth, halfHeight})
	end
	
	return image
end

function ResourceManager:loadGfxQuad2D(filePath, coords)
	local image = MOAIGfxQuad2D.new()
	image:setTexture(filePath)
	image:setRect(unpack(coords))
	return image
end

function ResourceManager:loadTiledImage(definition)
	local tiledImage = MOAITileDeck2D.new()
	local filePath = IMAGE_PATH .. definition.fileName
	tiledImage:setTexture(filePath)
	tiledImage:setSize(unpack(definition.tileMapSize))
	
	if definition.width and definition.height then
		local halfWidth = definition.width / 2
		local halfHeight = definition.height / 2
		tiledImage:setRect(-halfWidth, -halfHeight, halfWidth, halfHeight)
	end
	
	return tiledImage
end

function ResourceManager:loadFont(definition)
	local font = MOAIFont.new()
	local filePath = FONT_PATH .. definition.fileName
	font:loadFromTTF(filePath, definition.glyphs, definition.fontSize, definition.dpi)
	return font
end

function ResourceManager:loadSound(definition)
	local sound = MOAIUntzSound.new()
	local filePath = SOUND_PATH .. definition.fileName
	sound:load(filePath)
	sound:setVolume(definition.volume)
	sound:setLooping(definition.loop)
	return sound
end

function ResourceManager:loadMap(definition)
	local map = dofile(MAP_PATH .. definition.mapName .. "/" .. definition.fileName)
	return map
end
