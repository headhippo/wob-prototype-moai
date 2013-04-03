-- set screen dimensions dynamically based on device
screenWidth = MOAIEnvironment.screenWidth
screenHeight = MOAIEnvironment.screenHeight

-- if host does not provide screen dimensions, use these defaults
if screenWidth == nil then screenWidth = 1280 end
if screenHeight == nil then screenHeight = 720 end

-- various screen dimensions for quick testing purposes

-- iphone 3 and older, 1.5 aspect ratio
--screenWidth = 480
--screenHeight = 320

-- iphone 4, 1.5 aspect ratio
--screenWidth = 960
--screenHeight = 640

-- iphone 5, 1.775 aspect ratio
--screenWidth = 1136
--screenHeight = 640

-- ipad 1 and 2, 1.333 aspect ratio
--screenWidth = 1024
--screenHeight = 768

-- ipad 3, 1.333 aspect ratio
--screenWidth = 2048
--screenHeight = 1536

-- htc one x, samsung galaxy s3, 1.777 aspect ratio (16:9)
--screenWidth = 1280
--screenHeight = 720

-- other
--screenWidth = 640
--screenHeight = 480

-- required for non mobile platforms
MOAISim.openWindow("W.O.B. Prototype", screenWidth, screenHeight)

-- set world dimensions
worldWidth = 1280
worldHeight = 720

viewport = MOAIViewport.new()

-- viewport size should be the highest resolution that fits within the screen, that also matches the aspect ratio of the world dimensions
viewportWidth = screenWidth
viewportHeight = screenHeight

worldAspectRatio = worldWidth / worldHeight
screenAspectRatio = screenWidth / screenHeight

if screenAspectRatio < worldAspectRatio then
	-- need to letterbox on top and bottom of viewport
	viewportHeight = viewportWidth / worldAspectRatio
	offset = (screenHeight - viewportHeight) / 2
	viewport:setSize(0, offset, viewportWidth, viewportHeight + offset)
elseif screenAspectRatio > worldAspectRatio then
	-- need to letterbox on left and right of viewport
	viewportWidth = viewportHeight * worldAspectRatio
	offset = (screenWidth - viewportWidth) / 2
	viewport:setSize(offset, 0, viewportWidth + offset, viewportHeight)
else
	viewport:setSize(viewportWidth, viewportHeight)
end

-- viewport will show world dimensions regardless of device resolution
viewport:setScale(worldWidth, worldHeight)

mainMenuLayer = MOAILayer2D.new()
mainMenuLayer:setViewport(viewport)

backgroundImage = MOAIGfxQuad2D.new()

-- MainMenuBackground.png is 2048 x 1152 with a perfect circle in the center (for detecting aspect ratio issues)
backgroundImage:setTexture("MainMenuBackground.png")

-- stretch the background image to cover the entire world dimensions
backgroundImage:setRect(-(worldWidth/2), -(worldHeight/2), (worldWidth/2), (worldHeight/2))

backgroundProp = MOAIProp2D.new()
backgroundProp:setDeck(backgroundImage)
backgroundProp:setLoc(0, 0)

mainMenuLayer:insertProp(backgroundProp)

renderTable = {mainMenuLayer}
MOAIRenderMgr.setRenderTable(renderTable)
