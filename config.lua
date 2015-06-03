--global conf object stores different template configurations
conf = {
	--set app's orientation
	orientation = Stage.LANDSCAPE_LEFT,
	--default transition for scene manager
	transition = SceneManager.flipWithFade,
	--default easing used in template
	easing = easing.outBack,
	--defauly texture fitlering
	textureFilter = true,
	--scaling mode
	scaleMode = "stretch",
	--keep application awake
	keepAwake = true,
	--logical width of screen
	width = 800,
	--logical height of screen
	height = 1280,
	--fps of application
	fps = 60,
	--for absolute positioning
	dx = application:getLogicalTranslateX() / application:getLogicalScaleX(),
	dy = application:getLogicalTranslateY() / application:getLogicalScaleY(),
	--some commonly used fonts
	smallFont = TTFont.new("tahoma.ttf", 20),
	largeFont = TTFont.new("tahoma.ttf", 40),
}