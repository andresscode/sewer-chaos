--Global Setup
display.setStatusBar ( display.HiddenStatusBar )
system.activate ( "multitouch" )
local physics

--Global Variables ( Game Setup )
local json = require "json"
local variable = { bestScore, soundOn, firstHowToPlay }
local prev = { bestScore, soundOn, firstHowToPlay }
local prevEncode
local prevDecode
local firstStart = true
local windowOnScreen = false

--Loading Data
local path = system.pathForFile ( "data.txt", system.DocumentsDirectory )
local file = io.open( path, "r" )
if file then
local content = file:read ( "*a" )
prevDecode = json.decode ( content )
variable.bestScore = prevDecode.bestScore
prev.bestScore = variable.bestScore
variable.soundOn = prevDecode.soundOn
if ( variable.soundOn == true ) then
audio.setVolume ( 1.0 )
else
audio.setVolume ( 0.0 )
end
variable.firstHowToPlay = prevDecode.firstHowToPlay
io.close( file )
end

--Exceptions for First Time
if ( variable.bestScore == nil ) then
prev.bestScore = 0
variable.bestScore = 0
end
if ( variable.soundOn == nil ) then
variable.soundOn = true
end
if ( variable.firstHowToPlay == nil ) then
variable.firstHowToPlay = true
end

--Saving Data
local function write (e)
	if ( e.type == "applicationExit" ) then
		if ( variable.bestScore > prev.bestScore ) then
		prev.bestScore = variable.bestScore
		end
		prev.soundOn = variable.soundOn
		prev.firstHowToPlay = variable.firstHowToPlay
	prevEncode = json.encode ( prev )
	file = io.open( path, "w+" )
	file:write ( prevEncode )
	io.close( file )
	end
end
Runtime:addEventListener ( "system", write )
--os.remove ( system.pathForFile ( "data.txt", system.DocumentsDirectory ) )

--Constants
local wScreen
local hScreen
local mRandom
local playerShape
local ballCollisionFilter
local floorCollisionFilter
local playerCollisionFilter
local staticObject 
local ballObject
local sensorObject
local playerObject

--Variables
local motionRight
local motionLeft
local speedX
local motionX
local playerLives
local gameplay
local gameover
local tableTimerId
local scoreStars
local ballDirected
local spellBallOnScreen
local spellOn
local throwSpell
local spellBallTimerOn
local spell
local shield
local invisible
local extraPoints
local faster
local scoreExtraPoints
local alert
local highscoreOn

--Timers
local spawnActivationTimer1
local spawnActivationTimer2
local spawnActivationTimer3
local spawnActivationTimer4
local spawnActivationTimer5
local spawnActivationTimer6
local spawnBallsTimer
local spellBallTimer
local shieldTimer
local invisibleTimer
local extraPointsTimer
local fasterTimer

--Groups
local group
local menuGroup
local infoGroup
local storeGroup
local howToPlayGroup

--Transitions
local transitionMenu
local transitionGameplay
local infoWindowTransitionIn
local infoWindowTransitionOut
local storeWindowTransitionIn
local storeWindowTransitionOut

--Display Objects
local background
local blackScreen
local playButton
local restartButton
local ball
local downFloor
local scoreWall
local glassTube
local player
local gameoverText
local scoreText
local totalScoreText
local playerLivesText
local pausedText
local numbers
local buttonLeft
local buttonRight
local scoreStarsText
local bestScoreText
local highscoreText
local crate
local spellText
local extrapointsText
local menuBackground
local menuTitle
local storeButton
local infoButton
local openfeintButton
local soundButtonOn
local soundButtonOff
local pauseButton
local menuButton
local resumeButton
local howToPlayButton
local whiteBackground
local creditsText
local facebookButton
local twitterButton
local videoButton
local closeButton
local howToPlayWindow
local rateAlert

--Sounds
local sounds

--Functions
local startScreen = {}
local startGameTransition = {}
local startGame = {}
local spawnBalls = {}
local groupMove = {}
local movement = {}
local moveRight = {}
local moveLeft = {}
local playerWrap = {}
local removeBalls = {}
local roundPlayerLives = {}
local playerDamage = {}
local removePlayer = {}
local spawnActivation = {}
local gameoverStatus = {}
local gameoverScreen = {}
local restartGame = {}
local pauseGame = {}
local unpauseGame = {}
local scoreStarsUpdate = {}
local gameoverScreen2 = {}
local changeLevel = {}
local spawnSpellBall = {}
local spellActivation = {}
local spellCancel = {}
local removeMenu = {}
local turningSound = {}
local backToMenu = {}
local restartGamePause = {}
local restartGamePuase2 = {}
local backToMenuPause = {}
local backToMenuPause2 = {}
local infoWindow = {}
local removeInfoWindowTransition = {}
local removeInfoWindow = {}
local openFacebook = {}
local openTwitter = {}
local openVideo = {}
local firstHowToPlayWindow = {}
local pauseHowToPlayWindow = {}
local removePauseHowToPlayWindow = {}
local ratingApp = {}
local inAppPurchases = {}
local storeWindow = {}
local removeStoreWindowTransition = {}
local removeStoreWindow = {}

--Main Function ( Setting Up Variables and Constants )
local function main ()
	--Physics Setup
	physics = require "physics"
	physics.start ()
	physics.setGravity ( 0, 5.8 )
	physics.setScale ( 80 )
	physics.setDrawMode ( "normal" )
	--Constants
	wScreen = display.contentWidth
	hScreen = display.contentHeight
	mRandom = math.random
	playerShape = { -6, 10, -6, 0, 6, 0, 6, 10 }
	ballCollisionFilter = { categoryBits = 1, maskBits = 6 }
	floorCollisionFilter = { categoryBits = 2, maskBits = 5 }
	playerCollisionFilter = { categoryBits = 4, maskBits = 3 }
	staticObject = { density = 2, friction = 0, bounce = 0.4, filter = floorCollisionFilter }
	ballObject = { density = 0.8, friction = 0, bounce = 0.87, radius = 5.5, filter = ballCollisionFilter }
	sensorObject = { density = 2, friction = 0.3, bounce = 0, filter = floorCollisionFilter, isSensor = true }
	playerObject = { density = 2, friction = 0.3, bounce = 0, filter = playerCollisionFilter, isSensor = true, shape = playerShape }
	--Variables
	motionRight = false
	motionLeft = false
	speedX = 3
	motionX = 0
	playerLives = 1
	gameplay = false
	gameover = false
	tableTimerId = 0
	scoreStars = 0
	spellBallOnScreen = false
	spellOn = false
	spellBallTimerOn = false
	shield = false
	invisible = false
	extraPoints = false
	scoreExtraPoints = 0
	--Timers ( Tables )
	spawnBallsTimer = {}
	--Sounds
	sounds = {}
	sounds.soundtrack = audio.loadStream ( "Soundtrack.wav" )
	sounds.water = audio.loadStream ( "WaterSound.wav" )
	sounds.crate = audio.loadSound ( "CrateSound.wav" )
	sounds.playerDamage = audio.loadSound ( "PlayerDamageSound.wav" )
	sounds.bounce1 = audio.loadSound ( "BounceSound1.wav" )
	sounds.bounce2 = audio.loadSound ( "BounceSound2.wav" )
	sounds.bounce3 = audio.loadSound ( "BounceSound3.wav" )
	sounds.gameover = audio.loadStream ( "GameoverSound.wav" )
	sounds.tap = audio.loadSound ( "TapSound.wav" )
	--Calling Start Screen
	startScreen ()
end

--Creating the Starting Screen
function startScreen ()
	--First Start Game 
	if ( firstStart == true ) then
	--Start Sounds
	audio.play ( sounds.soundtrack, { channel = 1, loops = -1 } )
	--Menu Screen
	menuGroup = display.newGroup ()
	menuBackground = display.newImage ( "MenuBackground.png" )
	menuBackground.anchorX = 0.5
	menuBackground.anchorY = 0.5
	menuBackground.x = wScreen * 0.5
	menuBackground.y = hScreen * 0.5
	menuGroup:insert ( menuBackground )
	menuBackground.isVisible = true
	menuTitle = display.newImage ( "MenuTitle.png" )
	menuTitle.anchorX = 0.5
	menuTitle.anchorY = 0
	menuTitle.x = wScreen * 0.5
	menuTitle.y = 10
	menuGroup:insert ( menuTitle )
	playButton = display.newImage ( "ButtonPlay.png" )
	playButton.anchorX = 0.5
	playButton.anchorY = 0.5
	playButton.x = wScreen * 0.5
	playButton.y = hScreen * 0.5 - 10
	playButton:addEventListener ( "tap", startGameTransition )
	menuGroup:insert ( playButton )
	storeButton = display.newImage ( "ButtonStore.png" )
	storeButton.anchorX = 0.5
	storeButton.anchorY = 0.5
	storeButton.x = wScreen * 0.5
	storeButton.y = hScreen * 0.5 + 60
	storeButton:addEventListener ( "tap", storeWindow )
	menuGroup:insert ( storeButton )
	infoButton = display.newImage ( "ButtonInfo.png" )
	infoButton.anchorX = 0
	infoButton.anchorY = 1
	infoButton.x = 10
	infoButton.y = hScreen - 10
	infoButton:addEventListener ( "tap", infoWindow )
	menuGroup:insert ( infoButton )
	openfeintButton = display.newImage ( "ButtonOpenfeint.png" )
	openfeintButton.anchorX = 0.5
	openfeintButton.anchorY = 1
	openfeintButton.x = wScreen * 0.5
	openfeintButton.y = hScreen - 10
	menuGroup:insert ( openfeintButton )
	--Sound Button On/Off
	soundButtonOn = display.newImage ( "ButtonMusicOn.png" )
	soundButtonOn.anchorX = 1
	soundButtonOn.anchorY = 1
	soundButtonOn.x = wScreen - 10
	soundButtonOn.y = hScreen - 10
	soundButtonOn:addEventListener ( "tap", turningSound )
	menuGroup:insert ( soundButtonOn )
	soundButtonOff = display.newImage ( "ButtonMusicOff.png" )
	soundButtonOff.anchorX = 1
	soundButtonOff.anchorY = 1
	soundButtonOff.x = wScreen - 10
	soundButtonOff.y = hScreen - 10
	soundButtonOff:addEventListener ( "tap", turningSound )
	menuGroup:insert ( soundButtonOff )
	if ( variable.soundOn == true ) then
	soundButtonOn.isVisible = true
	soundButtonOff.isVisible = false
	else
	soundButtonOn.isVisible = false
	soundButtonOff.isVisible = true
	end
	else
	startGameTransition ()
	end
end

--Tuning On/Off Sound
function turningSound ()
	if ( windowOnScreen == false ) then
	--Tap Sound
	audio.play ( sounds.tap )
	if ( variable.soundOn == true ) then
	variable.soundOn = false
	soundButtonOn.isVisible = false
	soundButtonOff.isVisible = true
	audio.setVolume ( 0.0 )
	else
	variable.soundOn = true
	soundButtonOn.isVisible = true
	soundButtonOff.isVisible = false
	audio.setVolume ( 1.0 )
	end
	end
	return true
end

--Opening the Info Window
function infoWindow ()
	if ( windowOnScreen == false ) then
	--Tap Sound
	audio.play ( sounds.tap )
	windowOnScreen = true
	blackScreen = display.newImage ( "BlackScreen.png" )
	blackScreen.anchorX = 0.5
	blackScreen.anchorY = 0.5
	blackScreen.x = wScreen * 0.5
	blackScreen.y = hScreen * 0.5
	infoGroup = display.newGroup ()
	infoGroup.x = -100
	whiteBackground = display.newImage ( "WhiteWindow.png" )
	whiteBackground.anchorX = 0.5
	whiteBackground.anchorY = 0.5
	whiteBackground.x = wScreen * 0.5
	whiteBackground.y = hScreen * 0.5
	infoGroup:insert ( whiteBackground )
	creditsText = display.newImage ( "TextCredits.png" )
	creditsText.anchorX = 0.5
	creditsText.anchorY = 0.5
	creditsText.x = wScreen * 0.5
	creditsText.y = hScreen * 0.5
	infoGroup:insert ( creditsText )
	facebookButton = display.newImage ( "ButtonFacebook.png" )
	facebookButton.anchorX = 0.5
	facebookButton.anchorY = 0
	facebookButton.x = wScreen * 0.5 + 140
	facebookButton.y = 20
	facebookButton:addEventListener ( "tap", openFacebook )
	infoGroup:insert ( facebookButton )
	twitterButton = display.newImage ( "ButtonTwitter.png" )
	twitterButton.anchorX = 0.5
	twitterButton.anchorY = 0
	twitterButton.x = wScreen * 0.5 + 140
	twitterButton.y = 80
	twitterButton:addEventListener ( "tap", openTwitter )
	infoGroup:insert ( twitterButton )
	videoButton = display.newImage ( "ButtonVideo.png" )
	videoButton.anchorX = 0.5
	videoButton.anchorY = 0
	videoButton.x = wScreen * 0.5 + 140
	videoButton.y = 140
	videoButton:addEventListener ( "tap", openVideo )
	infoGroup:insert ( videoButton )
	closeButton = display.newImage ( "ButtonClose.png" )
	closeButton.anchorX = 0.5
	closeButton.anchorY = 1
	closeButton.x = wScreen * 0.5 + 140
	closeButton.y = hScreen - 20
	closeButton:addEventListener ( "tap", removeInfoWindowTransition )
	infoGroup:insert ( closeButton )
	infoWindowTransitionIn = transition.from ( infoGroup, { time = 500, x = -wScreen, transition = easing.outExpo } )
	end
	return true
end

--Transistion Out Info Window
function removeInfoWindowTransition ()
	if ( windowOnScreen == true ) then
	--Tap Sound
	audio.play ( sounds.tap )
	infoWindowTransitionIn = nil
	--Removing Listeners
	closeButton:removeEventListener ( "tap", removeInfoWindowTransition )
	facebookButton:removeEventListener ( "tap", openFacebook )
	twitterButton:removeEventListener ( "tap", openTwitter )
	videoButton:removeEventListener ( "tap", openVideo )
	--Removing Black Screen
	blackScreen:removeSelf ()
	blackScreen = nil
	infoWindowTransitionOut = transition.to ( infoGroup, { time = 500, x = -wScreen, transition = easing.outExpo, onComplete = removeInfoWindow } )
	end
	return true
end

--Removing Info Window Objects
function removeInfoWindow ()
	windowOnScreen = false
	infoWindowTransitionOut = nil
	--Removing Display Objects
	infoGroup:removeSelf ()
	whiteBackground = nil
	creditsText = nil
	facebookButton = nil
	twitterButton = nil
	videoButton = nil
	closeButton = nil
	infoGroup = nil
end

--Opening the Store Window
function storeWindow ()
	if ( windowOnScreen == false ) then
	--Tap Sound
	audio.play ( sounds.tap )
	windowOnScreen = true
	blackScreen = display.newImage ( "BlackScreen.png" )
	blackScreen.anchorX = 0.5
	blackScreen.anchorY = 0.5
	blackScreen.x = wScreen * 0.5
	blackScreen.y = hScreen * 0.5
	storeGroup = display.newGroup ()
	storeGroup.y = -40
	whiteBackground = display.newImage ( "WhiteWindowStore.png" )
	whiteBackground.anchorX = 0.5
	whiteBackground.anchorY = 0.5
	whiteBackground.x = wScreen * 0.5
	whiteBackground.y = hScreen * 0.5
	storeGroup:insert ( whiteBackground )
	closeButton = display.newImage ( "ButtonClose.png" )
	closeButton.anchorX = 1
	closeButton.anchorY = 1
	closeButton.x = wScreen - 40
	closeButton.y = hScreen - 20
	closeButton:addEventListener ( "tap", removeStoreWindowTransition )
	storeGroup:insert ( closeButton )
	storeWindowTransitionIn = transition.from ( storeGroup, { time = 500, y = -hScreen, transition = easing.outExpo } )
	end
	return true
end

--Transistion Out Store Window
function removeStoreWindowTransition ()
	if ( windowOnScreen == true ) then
	--Tap Sound
	audio.play ( sounds.tap )
	storeWindowTransitionIn = nil
	--Removing Listeners
	closeButton:removeEventListener ( "tap", removeInfoWindowTransition )
	--Removing Black Screen
	blackScreen:removeSelf ()
	blackScreen = nil
	storeWindowTransitionOut = transition.to ( storeGroup, { time = 500, y = -hScreen, transition = easing.outExpo, onComplete = removeStoreWindow } )
	end
	return true
end

--Removing Store Window Objects
function removeStoreWindow ()
	windowOnScreen = false
	storeWindowTransitionOut = nil
	--Removing Display Objects
	storeGroup:removeSelf ()
	whiteBackground = nil
	closeButton = nil
	storeGroup = nil
end

--Facebook Web
function openFacebook ()
	if ( windowOnScreen == true ) then
	--Tap Sound
	audio.play ( sounds.tap )
	system.openURL( "http://www.facebook.com/angrybirds" )
	end
end

--Twitter Web
function openTwitter ()
	if ( windowOnScreen == true ) then
	--Tap Sound
	audio.play ( sounds.tap )
	system.openURL ( "http://twitter.com/#!/angrybirds" )
	end
end

--Youtube Video
function openVideo ()
	if ( windowOnScreen == true ) then
	--Tap Sound
	audio.play ( sounds.tap )
	system.openURL ( "http://www.youtube.com/watch?v=-eyig_V-_5o" )
	end
end

--Starting Transition
function startGameTransition ()
	if ( windowOnScreen == false ) then
	--Tap Sound
	audio.play ( sounds.tap )
	group = display.newGroup ()
	if ( firstStart == true ) then
	group.y = hScreen
	--Removing Button Listeners ( Menu )
	playButton:removeEventListener ( "tap", startGameTransition )
	soundButtonOn:removeEventListener ( "tap", turningSound )
	soundButtonOff:removeEventListener ( "tap", turningSound )
	infoButton:removeEventListener ( "tap", infoWindow )
	storeButton:removeEventListener ( "tap", storeWindow )
	end
	--Creating Gameplay Screen ( Down of Menu Screen )
	background = display.newImage ( "Background.png" )
	background.anchorX = 0.5
	background.anchorY = 0.5
	background.x = wScreen * 0.5
	background.y = hScreen * 0.5
	group:insert ( background )
	background.isVisible = true
	glassTube = display.newImage ( "GlassTube.png" )
	glassTube.anchorX = 0.5
	glassTube.anchorY = 0.5
	glassTube.x = -30
	glassTube.y = hScreen - 260
	glassTube.rotation = -41.5
	group:insert ( glassTube )
	downFloor = display.newRect ( 0, hScreen - 72, wScreen + 10, 1 )
	downFloor.anchorX = 0
	downFloor.anchorY = 0.5
	downFloor.isVisible = false
	downFloor:setFillColor ( 81, 82, 64 )
	downFloor.myName = "floor"
	physics.addBody ( downFloor, "static", staticObject )
	group:insert ( downFloor )
	scoreWall = display.newRect ( wScreen + 10 , 0, 1, hScreen )
	scoreWall.anchorX = 0.5
	scoreWall.anchorY = 0
	scoreWall.myName = "scoreWall"
	physics.addBody ( scoreWall, "static", sensorObject )
	group:insert ( scoreWall )
	player = display.newImage ( "MainChar.png" )
	player.myName = "player"
	player.anchorX = 0.5
	player.anchorY = 1
	player.x = wScreen * 0.5
	player.y = hScreen - 72
	player:addEventListener ( "collision", playerDamage )
	physics.addBody ( player, "kinematic", playerObject )
	group:insert ( player )
	if ( firstStart == true ) then
	--Changing Positions ( Menu and Gameplay Screens )
	transitionGameplay = transition.to ( group, { time = 1000, y = 0, onComplete = firstHowToPlayWindow } )
	transitionMenu = transition.to ( menuGroup, { time = 1000, y = -hScreen, onComplete = removeMenu } )
	firstStart = false
	else
	startGame ()
	end
	end
	return true
end

--Removing Menu Screen
function removeMenu ()
	transitionMenu = nil
	--Removing Menu Objects from Display
	menuGroup:removeSelf ()
	menuBackground = nil
	menuTitle = nil
	playButton = nil
	storeButton = nil
	infoButton = nil
	openfeintButton = nil
	soundButtonOn = nil
	soundButtonOff = nil
	menuGroup = nil
end

--Checking First Play to Show How To Play Window
function firstHowToPlayWindow ()
	transitionGameplay = nil
	if ( variable.firstHowToPlay == true ) then
	howToPlayGroup = display.newGroup ()
	blackScreen = display.newImage ( "BlackScreen.png" )
	blackScreen.anchorX = 0.5
	blackScreen.anchorY = 0.5
	blackScreen.x = wScreen * 0.5
	blackScreen.y = hScreen * 0.5
	howToPlayGroup:insert ( blackScreen )
	howToPlayWindow = display.newImage ( "WindowHowToPlay.png" )
	howToPlayWindow.anchorX = 0.5
	howToPlayWindow.anchorY = 0.5
	howToPlayWindow.x = wScreen * 0.5
	howToPlayWindow.y = hScreen * 0.5
	howToPlayGroup:insert ( howToPlayWindow )
	closeButton = display.newImage ( "ButtonCloseBlack.png" )
	closeButton.anchorX = 0.5
	closeButton.anchorY = 0.5
	closeButton.x = wScreen * 0.5 - 160
	closeButton.y = hScreen * 0.5 - 100
	closeButton:addEventListener ( "tap", startGame )
	howToPlayGroup:insert ( closeButton )
	else
	startGame ()
	end
end

--Starting Game ( Timers, Buttons, Scores, etc. )
function startGame ()
	if ( variable.firstHowToPlay == true ) then
	--Tap Sound
	audio.play ( sounds.tap )
	closeButton:removeEventListener ( "tap", startGame )
	howToPlayGroup:removeSelf ()
	blackScreen = nil
	howToPlayWindow = nil
	closeButton = nil
	howToPlayGroup = nil
	variable.firstHowToPlay = false
	end
	--Stopping Soundtrack and Playing Water Sound
	audio.stop ( 1 )
	audio.dispose ( sounds.soundtrack )
	--soundtrack = nil
	audio.play ( sounds.water, { channel = 2, loops = -1 } )
	--Turning On Gameplay
	gameplay = true
	--Movement Buttons
	buttonLeft = display.newImage ( "ButtonLeft.png" )
	buttonLeft.anchorX = 0
	buttonLeft.anchorY = 1
	buttonLeft.x = 10
	buttonLeft.y = hScreen - 10
	buttonLeft:addEventListener ( "touch", moveLeft )
	buttonRight = display.newImage ( "ButtonRight.png" )
	buttonRight.anchorX = 1
	buttonRight.anchorY = 1
	buttonRight.x = 470
	buttonRight.y = hScreen - 10
	buttonRight:addEventListener ( "touch", moveRight )
	--Pause Button
	pauseButton = display.newImage ( "ButtonPause.png" )
	pauseButton.anchorX = 1
	pauseButton.anchorY = 0
	pauseButton.x = wScreen - 10
	pauseButton.y = 10
	pauseButton:addEventListener ( "tap", pauseGame )
	--Score Stars
	scoreStarsText = display.newText ( "Score "..scoreStars, wScreen * 0.5, 10, native.systemFont, 20 )
	scoreStarsText.anchorX = 0
	scoreStarsText.anchorY = 0
	scoreStarsText.x = 0
	scoreStarsText.y = 0
	--Best Score
	bestScoreText = display.newText ( "Best "..variable.bestScore, wScreen * 0.5, 10, native.systemFont, 14 )
	bestScoreText.anchorX = 0
	bestScoreText.anchorY = 0
	bestScoreText.x = 0
	bestScoreText.y = 20
	--Player Lives
	playerLivesText = display.newText ( "Lives "..playerLives, 0, 0, system.nativeFont, 20 )
	playerLivesText.anchorX = 0.5
	playerLivesText.anchorY = 1
	playerLivesText.x = wScreen * 0.5
	playerLivesText.y = hScreen - 20
	--Starting Timers
	spawnActivationTimer1 = timer.performWithDelay ( 1000, spawnActivation, 0 )
	--Starting Runtime Listeners
	Runtime:addEventListener ( "enterFrame", movement )
	Runtime:addEventListener ( "enterFrame", groupMove )
	Runtime:addEventListener ( "enterFrame", playerWrap )
	Runtime:addEventListener ( "enterFrame", removePlayer )
	Runtime:addEventListener ( "enterFrame", gameoverStatus )
	Runtime:addEventListener ( "enterFrame", gameoverScreen )
	Runtime:addEventListener ( "enterFrame", scoreStarsUpdate )
	return true
end

--Incresing Ingame Level
function changeLevel ()
	if ( gameplay == true ) then
		if ( scoreStars == 10 ) then
		spawnActivationTimer2 = timer.performWithDelay ( 1000, spawnActivation, 0 )
		elseif ( scoreStars == 30 ) then
		spawnActivationTimer3 = timer.performWithDelay ( 1000, spawnActivation, 0 )
		elseif ( scoreStars == 50 ) then
		spawnActivationTimer4 = timer.performWithDelay ( 1000, spawnActivation, 0 )
		elseif ( scoreStars == 70 ) then
		spawnActivationTimer5 = timer.performWithDelay ( 1000, spawnActivation, 0 )
		elseif ( scoreStars == 90 ) then
		spawnActivationTimer6 = timer.performWithDelay ( 1000, spawnActivation, 0 )
		end
	end
end

--Activating the spawn level
function spawnActivation (e)
	--Activating Spawn Balls Timers
	tableTimerId = #spawnBallsTimer + 1
	spawnBallsTimer[tableTimerId] = timer.performWithDelay ( mRandom ( 0, 2000 ), spawnBalls, 1 )
end

--Spawing the Balls
function spawnBalls (e)
	if ( gameplay == true ) then
	ball = display.newImage ( "GreenBall.png" )
	ball.anchorX = 0.5
	ball.anchorY = 0.5
	ball.x = 15
	ball.y = hScreen - 260
	ball.myName = "ball"
	ball:addEventListener ( "collision", removeBalls )
	physics.addBody ( ball, ballObject )
		--Avoiding the Player stays close to the Ball Spawner
		ballDirected = mRandom ( 1, 5 )
		if ( ballDirected == 5 ) then
			if ( player.x >= 60 and player.x <= 84 ) then
			ball:setLinearVelocity ( 60, 0 )
			elseif ( player.x >= 85 and player.x <= 104 ) then
			ball:setLinearVelocity ( 90, 0 )
			else
			ball:setLinearVelocity ( mRandom ( 60, 220 ), 0 )
			end
		else
		ball:setLinearVelocity ( mRandom ( 60, 220 ), 0 )
		end
	group:insert ( ball )
	--Removing Timer from Table
	for k,v in pairs ( spawnBallsTimer ) do
    	if ( v == e.source ) then
   		table.remove ( spawnBallsTimer, k )
    	end
    end
    --Starting timer to spawn Spell Ball
	if ( scoreStars >= 0  and scoreStars <= 90 ) then
	throwSpell = mRandom ( 1, 10 )
	else
	throwSpell = mRandom ( 1, 30 )
	end
	if ( throwSpell == 1 and spellBallOnScreen == false and spellOn == false and spellBallTimerOn == false ) then
	spellBallTimerOn = true
	spellBallTimer = timer.performWithDelay ( mRandom ( 250, 750 ), spawnSpellBall, 1 )
	end
    end
    if ( gameplay == false ) then
    --Removing Timer from Table
	for k,v in pairs ( spawnBallsTimer ) do
    	if ( v == e.source ) then
   		table.remove ( spawnBallsTimer, k )
    	end
    end
	end
end

--Spawning Spell Balls
function spawnSpellBall ()
	if ( gameplay == true ) then
	spellBallTimerOn = false
	crate = display.newImage ( "Crate.png" )
	crate.anchorX = 0.5
	crate.anchorY = 1
	crate.x = 12
	crate.y = hScreen - 72
	crate.myName = "spellball"
	crate:addEventListener ( "collision", removeBalls )
	physics.addBody ( crate, { density = 0.8, friction = 0, bounce = 0, filter = ballCollisionFilter } )
	crate:setLinearVelocity ( 100, 0 )
	group:insert ( crate )
	spellBallOnScreen = true
	end
end

--Score Stars Text Update
function scoreStarsUpdate ()
	scoreStarsText.anchorX = 0
	scoreStarsText.anchorY = 0
	scoreStarsText.x = 0
	scoreStarsText.text = "Score "..scoreStars
	playerLivesText.text = "Lives "..playerLives
	if ( extraPoints == true ) then
	extrapointsText.text = scoreExtraPoints
	else
	scoreExtraPoints = 0
	end
end

--Selecting and Activating spells
function spellActivation ()
	if ( gameplay == true and spellOn == false ) then
	spellOn = true
	if ( scoreStars > 90 ) then
	spell = mRandom ( 1, 4 )
	else
	spell = mRandom ( 1, 3 )
	end
	--Shield
	if ( spell == 1 ) then
	spellText = display.newText ( "Shield", 0, 0, system.nativeFont, 24 )
	spellText.anchorX = 0.5
	spellText.anchorY = 0
	spellText.x = wScreen * 0.5
	spellText.y = 10
	shield = true
	shieldTimer = timer.performWithDelay ( 10000, spellCancel, 1 )
	--Invisible
	elseif ( spell == 2 ) then
	spellText = display.newText ( "Invisible", 0, 0, system.nativeFont, 24 )
	spellText.anchorX = 0.5
	spellText.anchorY = 0
	spellText.x = wScreen * 0.5
	spellText.y = 10
	invisible = true
	invisibleTimer = timer.performWithDelay ( 5000, spellCancel, 1 )
	--Faster
	elseif ( spell == 3 ) then
	spellText = display.newText ( "Faster", 0, 0, system.nativeFont, 24 )
	spellText.anchorX = 0.5
	spellText.anchorY = 0
	spellText.x = wScreen * 0.5
	spellText.y = 10
	faster = true
	fasterTimer = timer.performWithDelay ( 8000, spellCancel, 1 )
	speedX = 4
	--Extra Points
	elseif ( spell == 4 ) then
	spellText = display.newText ( "Extra Points", 0, 0, system.nativeFont, 24 )
	spellText.anchorX = 0.5
	spellText.anchorY = 0
	spellText.x = wScreen * 0.5
	spellText.y = 10
	extrapointsText = display.newText ( scoreExtraPoints, 0, 0, system.nativeFont, 20 )
	extrapointsText.anchorX = 0.5
	extrapointsText.anchorY = 0
	extrapointsText.x = wScreen * 0.5
	extrapointsText.y = 40
	extraPoints = true
	extraPointsTimer = timer.performWithDelay ( 8000, spellCancel, 1 )
	end
	end
end

--Spell Complete
function spellCancel ()
	if ( spellOn == true ) then
	--Shield
	if ( spell == 1 ) then
	spellText:removeSelf ()
	spellText = nil
	shield = false
	shieldTimer = nil
	--Invisible
	elseif ( spell == 2 ) then
	spellText:removeSelf ()
	spellText = nil
	invisible = false
	invisibleTimer = nil
	--Faster
	elseif ( spell == 3 ) then
	spellText:removeSelf ()
	spellText = nil
	faster = false
	fasterTimer = nil
	speedX = 3
	--Extra Points
	elseif ( spell == 4 ) then
	scoreStars = scoreStars + scoreExtraPoints
	spellText:removeSelf ()
	spellText = nil
	extrapointsText:removeSelf ()
	extrapointsText = nil
	extraPoints = false
	extraPointsTimer = nil
	end
	spellOn = false
	end
end

--Checking if Movement to Right is true
function moveRight (e)
	if ( gameplay == true ) then
		if ( e.phase == "began" ) then
		motionRight = true
		display.getCurrentStage():setFocus ( e.target, e.id )
		elseif ( e.phase == "ended" or e.phase == "cancelled" ) then
		motionRight = false
		display.getCurrentStage():setFocus ( e.target, nil )
		end
	end
	return true
end

--Checking if Movement to Left is true
function moveLeft (e)
	if ( gameplay == true ) then
		if ( e.phase == "began" ) then
		motionLeft = true
		display.getCurrentStage():setFocus ( e.target, e.id )
		elseif ( e.phase == "ended" or e.phase == "cancelled" ) then
		motionLeft = false
		display.getCurrentStage():setFocus ( e.target, nil )
		end
	end
	return true
end

--Movement Setup ( Fixing the double touch )
function movement ()
	if ( gameplay == true ) then
		if ( motionRight == true and motionLeft == false ) then
		motionX = speedX
		elseif ( motionRight == false and motionLeft == true ) then
		motionX = -speedX
		elseif ( motionRight == true and motionLeft == true ) then
		motionX = 0
		elseif ( motionRight == false and motionLeft == false ) then
		motionX = 0
		end
	end
end

--Group Movement ( Player )
function groupMove ()
	if ( gameplay == true ) then
	player.x = player.x + motionX
	end
end

--Wrap ( Group and Player )
function playerWrap ()
	if ( gameplay == true ) then
		--Player
		if ( player.x < 60 ) then
		player.x = 60
		elseif ( player.x > wScreen - 6 ) then
		player.x = wScreen - 6
		end
	end
end

--Player Damage
function playerDamage (e)
	if ( gameplay == true ) then
		if ( e.other.myName == "ball" and e.phase == "began" ) then
		if ( shield == false and invisible == false ) then
		audio.play ( sounds.playerDamage )
		playerLives = playerLives - 1
		elseif ( shield == true ) then
		audio.play ( sounds.playerDamage )
		spellText:removeSelf ()
		spellText = nil
		shield = false
		spellOn = false
		timer.cancel ( shieldTimer )
		shieldTimer = nil
		end
		end
	end
end

--Remove Player
function removePlayer ()
	if ( gameplay == true ) then
		if ( playerLives <= 0 ) then
		--Canceling Faster by Death
		if ( faster == true ) then
    	spellText:removeSelf ()
		spellText = nil
		faster = false
		spellOn = false
    	timer.cancel ( fasterTimer )
    	fasterTimer = nil
		end
		--Canceling Extra Points by Death
		if ( extraPoints == true ) then
    	spellText:removeSelf ()
		spellText = nil
		extrapointsText:removeSelf ()
		extrapointsText = nil
		extraPoints = false
		spellOn = false
    	timer.cancel ( extraPointsTimer )
    	extraPointsTimer = nil
		end
		--Removing Player
		player:removeEventListener ( "collision", playerDamage )
		player:removeSelf ()
		player = nil
		end
	end
end

--Removing Balls
function removeBalls (e)
	--Playing Bounce Sounds
	if ( e.other.myName == "floor" and e.phase == "began" ) then
	local selection = mRandom ( 1, 3 )
		if ( selection == 1 ) then
		audio.play ( sounds.bounce1 )
		elseif ( selection == 2 ) then
		audio.play ( sounds.bounce2 )
		else
		audio.play ( sounds.bounce3 )
		end
	end
	if ( e.other.myName == "scoreWall" and e.target.myName == "ball" ) then
	e.target:removeEventListener ( "collision", removeBalls )
	e.target:removeSelf ()
	e.target = nil
		--Counting Extrapoints
		if ( extraPoints == true ) then
		scoreExtraPoints = scoreExtraPoints + 1
		end
	scoreStars = scoreStars + 1
	changeLevel ()
	end
	if ( e.other.myName == "player" and e.target.myName == "ball" and invisible == false ) then
	e.target:removeEventListener ( "collision", removeBalls )
	e.target:removeSelf ()
	e.target = nil
	elseif ( e.other.myName == "player" and e.target.myName == "spellball" ) then
	audio.play ( sounds.crate )
	e.target:removeEventListener ( "collision", removeBalls )
	e.target:removeSelf ()
	e.target = nil
	spellBallOnScreen = false
	spellActivation ()
	end
	return true
end

--Checking Gameover and Gameplay Status
function gameoverStatus ()
	if ( playerLives <= 0 ) then
	gameplay = false
	gameover = true
	end
end

--Pausing the Game
function pauseGame (e)
	if ( gameplay == true and gameover == false ) then
	gameplay = false
	physics.pause ()
	--Pausing Water Sound
	audio.pause ( sounds.water )
	--Tap Sound
	audio.play ( sounds.tap )
	--Pausing Spell Timers
	if ( spellOn == true ) then
	if ( spell == 1 ) then
	timer.pause ( shieldTimer )
	elseif ( spell == 2 ) then
	timer.pause ( invisibleTimer )
	elseif ( spell == 3 ) then
	timer.pause ( fasterTimer )
	elseif ( spell == 4 ) then
	timer.pause ( extraPointsTimer )
	end
	end
	--Creating Pause Screen
	blackScreen = display.newImage ( "BlackScreen.png" )
	blackScreen.anchorX = 0.5
	blackScreen.anchorY = 0.5
	blackScreen.x = wScreen * 0.5
	blackScreen.y = hScreen * 0.5
	pausedText = display.newImage ( "ButtonPaused.png" )
	pausedText.anchorX = 0.5
	pausedText.anchorY = 0.5
	pausedText.x = wScreen * 0.5
	pausedText.y = hScreen * 0.5 - 40
	resumeButton = display.newImage ( "ButtonResume.png" )
	resumeButton.anchorX = 0.5
	resumeButton.anchorY = 1
	resumeButton.x = wScreen * 0.5
	resumeButton.y = hScreen - 100
	resumeButton:addEventListener ( "tap", unpauseGame )
	restartButton = display.newImage ( "ButtonReset.png" )
	restartButton.anchorX = 0.5
	restartButton.anchorY = 1
	restartButton.x = wScreen * 0.5 + 64
	restartButton.y = hScreen - 100
	restartButton:addEventListener ( "tap", restartGamePause )
	menuButton = display.newImage ( "ButtonMenu.png" )
	menuButton.anchorX = 0.5
	menuButton.anchorY = 1
	menuButton.x = wScreen * 0.5 - 64
	menuButton.y = hScreen - 100
	menuButton:addEventListener ( "tap", backToMenuPause )
	howToPlayButton = display.newImage ( "ButtonHowToPlay.png" )
	howToPlayButton.anchorX = 0.5
	howToPlayButton.anchorY = 1
	howToPlayButton.x = wScreen * 0.5 + 128
	howToPlayButton.y = hScreen - 100
	howToPlayButton:addEventListener ( "tap", pauseHowToPlayWindow )
	--Sound Button On/Off
	soundButtonOn = display.newImage ( "ButtonMusicOnYellow.png" )
	soundButtonOn.anchorX = 0.5
	soundButtonOn.anchorY = 1
	soundButtonOn.x = wScreen * 0.5 - 128
	soundButtonOn.y = hScreen - 100
	soundButtonOn:addEventListener ( "tap", turningSound )
	soundButtonOff = display.newImage ( "ButtonMusicOffYellow.png" )
	soundButtonOff.anchorX = 0.5
	soundButtonOff.anchorY = 1
	soundButtonOff.x = wScreen * 0.5 - 128
	soundButtonOff.y = hScreen - 100
	soundButtonOff:addEventListener ( "tap", turningSound )
	if ( variable.soundOn == true ) then
	soundButtonOn.isVisible = true
	soundButtonOff.isVisible = false
	else
	soundButtonOn.isVisible = false
	soundButtonOff.isVisible = true
	end
	end
	return true
end

--Unpausing the Game
function unpauseGame ()
	if ( gameplay == false and gameover == false ) then
	gameplay = true
	physics.start ()
	--Tap Sound
	audio.play ( sounds.tap )
	--Restarting Water Sound
	audio.resume ( sounds.water )
	--Restarting Spell Timers
	if ( spellOn == true ) then
	if ( spell == 1 ) then
	timer.resume ( shieldTimer )
	elseif ( spell == 2 ) then
	timer.resume ( invisibleTimer )
	elseif ( spell == 3 ) then
	timer.resume ( fasterTimer )
	elseif ( spell == 4 ) then
	timer.resume ( extraPointsTimer )
	end
	end
	--Removing Pause Screen
	pausedText:removeSelf ()
	pausedText = nil
	blackScreen:removeSelf ()
	blackScreen = nil
	resumeButton:removeEventListener ( "tap", unpauseGame )
	resumeButton:removeSelf ()
	resumeButton = nil
	restartButton:removeEventListener ( "tap", restartGamePause )
	restartButton:removeSelf ()
	restartButton = nil
	menuButton:removeEventListener ( "tap", backToMenuPause )
	menuButton:removeSelf ()
	menuButton = nil
	howToPlayButton:removeEventListener ( "tap", pauseHowToPlayWindow )
	howToPlayButton:removeSelf ()
	howToPlayButton = nil
	soundButtonOn:removeEventListener ( "tap", turningSound )
	soundButtonOn:removeSelf ()
	soundButtonOn = nil
	soundButtonOff:removeEventListener ( "tap", turningSound )
	soundButtonOff:removeSelf ()
	soundButtonOff = nil
	end
	return true
end

--How To Play Window from Pause Menu
function pauseHowToPlayWindow ()
	--Tap Sound
	audio.play ( sounds.tap )
	--Turning Invisible Pause Menu Objects
	pausedText.isVisible = false
	resumeButton.isVisible = false
	restartButton.isVisible = false
	menuButton.isVisible = false
	howToPlayButton.isVisible = false
	if ( variable.soundOn == true ) then
	soundButtonOn.isVisible = false
	else
	soundButtonOff.isVisible = false
	end
	--Creating How To Play Window
	howToPlayGroup = display.newGroup ()
	howToPlayWindow = display.newImage ( "WindowHowToPlay.png" )
	howToPlayWindow.anchorX = 0.5
	howToPlayWindow.anchorY = 0.5
	howToPlayWindow.x = wScreen * 0.5
	howToPlayWindow.y = hScreen * 0.5
	howToPlayGroup:insert ( howToPlayWindow )
	closeButton = display.newImage ( "ButtonCloseBlack.png" )
	closeButton.anchorX = 0.5
	closeButton.anchorY = 0.5
	closeButton.x = wScreen * 0.5 - 160
	closeButton.y = hScreen * 0.5 - 100
	closeButton:addEventListener ( "tap", removePauseHowToPlayWindow )
	howToPlayGroup:insert ( closeButton )
	return true
end

--Removing How to Play Window
function removePauseHowToPlayWindow ()
	--Tap Sound
	audio.play ( sounds.tap )
	--Turning Visible Pause Menu Objects
	pausedText.isVisible = true
	resumeButton.isVisible = true
	restartButton.isVisible = true
	menuButton.isVisible = true
	howToPlayButton.isVisible = true
	if ( variable.soundOn == true ) then
	soundButtonOn.isVisible = true
	else
	soundButtonOff.isVisible = true
	end
	--Removing How to Play Window
	closeButton:removeEventListener ( "tap", removePauseHowToPlayWindow )
	howToPlayGroup:removeSelf ()
	howToPlayWindow = nil
	closeButton = nil
	howToPlayGroup = nil
	return true
end

--Restarting Game from Pausing
function restartGamePause ()
	--Tap Sound
	audio.play ( sounds.tap )
	--Removing Pause Screen
	pausedText:removeSelf ()
	pausedText = nil
	blackScreen:removeSelf ()
	blackScreen = nil
	resumeButton:removeEventListener ( "tap", unpauseGame )
	resumeButton:removeSelf ()
	resumeButton = nil
	restartButton:removeEventListener ( "tap", restartGamePause )
	restartButton:removeSelf ()
	restartButton = nil
	menuButton:removeEventListener ( "tap", backToMenuPause )
	menuButton:removeSelf ()
	menuButton = nil
	howToPlayButton:removeEventListener ( "tap", pauseHowToPlayWindow )
	howToPlayButton:removeSelf ()
	howToPlayButton = nil
	soundButtonOn:removeEventListener ( "tap", turningSound )
	soundButtonOn:removeSelf ()
	soundButtonOn = nil
	soundButtonOff:removeEventListener ( "tap", turningSound )
	soundButtonOff:removeSelf ()
	soundButtonOff = nil
	--Stopping Water Sound
	audio.stop ( 2 )
	audio.dispose ( sounds.water )
	sounds.water = nil
	--Canceling Spell Timers
	if ( spellOn == true ) then
	if ( spell == 1 ) then
	timer.cancel ( shieldTimer )
	shieldTimer = nil
	elseif ( spell == 2 ) then
	timer.cancel ( invisibleTimer )
	invisibleTimer = nil
	elseif ( spell == 3 ) then
	timer.cancel ( fasterTimer )
	fasterTimer = nil
	elseif ( spell == 4 ) then
	timer.cancel ( extraPointsTimer )
	extraPointsTimer = nil
	extrapointsText:removeSelf ()
	extrapointsText = nil
	end
	spellText:removeSelf ()
	spellText = nil
	end
	--Canceling Timers ( Acitivation Timers Nill-Out )
	timer.cancel ( spawnActivationTimer1 )
	spawnActivationTimer1 = nil
	if ( scoreStars >= 10 and scoreStars < 30 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	elseif ( scoreStars >= 30 and scoreStars < 50 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	elseif ( scoreStars >= 50 and scoreStars < 70 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	elseif ( scoreStars >= 70 and scoreStars < 90 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	timer.cancel ( spawnActivationTimer5 )
	spawnActivationTimer5 = nil
	elseif ( scoreStars >= 90 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	timer.cancel ( spawnActivationTimer5 )
	spawnActivationTimer5 = nil
	timer.cancel ( spawnActivationTimer6 )
	spawnActivationTimer6 = nil
	end
	for i = 1, #spawnBallsTimer do
    timer.cancel (spawnBallsTimer[i])
    spawnBallsTimer[i] = nil
    end
    if ( spellBallTimerOn == true ) then
    timer.cancel ( spellBallTimer )
    spellBallTimer = nil
    end
	--Removing Runtime Listeners
	Runtime:removeEventListener ( "enterFrame", movement )
	Runtime:removeEventListener ( "enterFrame", groupMove )
	Runtime:removeEventListener ( "enterFrame", playerWrap )
	Runtime:removeEventListener ( "enterFrame", removePlayer )
	Runtime:removeEventListener ( "enterFrame", gameoverStatus )
	Runtime:removeEventListener ( "enterFrame", gameoverScreen )
	Runtime:removeEventListener ( "enterFrame", scoreStarsUpdate )
	--Removing Round Score Buttons ( Ungroup Objects )
	buttonLeft:removeEventListener ( "touch", moveLeft )
	buttonLeft:removeSelf ()
	buttonLeft = nil
	buttonRight:removeEventListener ( "touch", moveRight )
	buttonRight:removeSelf ()
	buttonRight = nil
	scoreStarsText:removeSelf ()
	scorestarsText = nil
	bestScoreText:removeSelf ()
	bestScoreText = nil
	playerLivesText:removeSelf ()
	playerLivesText = nil
	pauseButton:removeEventListener ( "tap", pauseGame )
	pauseButton:removeSelf ()
	pauseButton = nil
	restartGamePause2 ()
end

--Restarting Game from Pausing ( Continuation )
function restartGamePause2 ()
	--Removing Display Objects and Group
	group:removeSelf ()
	background = nil
	glassTube = nil
	ball = nil
	downFloor = nil
	scoreWall = nil
	crate = nil
	group = nil
	--Physics
	physics = nil
	--Constants
	wScreen = nil
	hScreen = nil
	mRandom = nil
	playerShape = nil
	ballCollisionFilter = nil
	floorCollisionFilter = nil
	playerCollisionFilter = nil
	staticObject = nil
	ballObject = nil
	sensorObject = nil
	playerObject = nil
	--Variables
	motionRight = nil
	motionLeft = nil
	speedX = nil
	motionX = nil
	playerLives = nil
	gameplay = nil
	gameover = nil
	scoreStars = nil
	ballDirected = nil
	spellBallOnScreen = nil
	spellOn = nil
	throwSpell = nil
	spellBallTimerOn = nil
	spell = nil
	shield = nil
	invisible = nil
	extraPoints = nil
	faster = nil
	scoreExtraPoints = nil
	--Timers
	spawnBallsTimer = nil
	--Sounds and Table
	audio.dispose ( sounds.crate )
	sounds.crate = nil
	audio.dispose ( sounds.playerDamage )
	sounds.playerDamage = nil
	audio.dispose ( sounds.bounce1 )
	sounds.bounce1 = nil
	audio.dispose ( sounds.bounce2 )
	sounds.bounce2 = nil
	audio.dispose ( sounds.bounce3 )
	sounds.bounce3 = nil
	audio.dispose ( sounds.gameover )
	sounds.gameover = nil
	audio.dispose ( sounds.tap )
	sounds.tap = nil
	sounds = nil
	--Calling Main Function to Restart
	main ()
end

--Backing to Menu from Pause
function backToMenuPause ()
	--Tap Sound
	audio.play ( sounds.tap )
	firstStart = true
	--Removing Pause Screen
	pausedText:removeSelf ()
	pausedText = nil
	blackScreen:removeSelf ()
	blackScreen = nil
	resumeButton:removeEventListener ( "tap", unpauseGame )
	resumeButton:removeSelf ()
	resumeButton = nil
	restartButton:removeEventListener ( "tap", restartGamePause )
	restartButton:removeSelf ()
	restartButton = nil
	menuButton:removeEventListener ( "tap", backToMenuPause )
	menuButton:removeSelf ()
	menuButton = nil
	howToPlayButton:removeEventListener ( "tap", pauseHowToPlayWindow )
	howToPlayButton:removeSelf ()
	howToPlayButton = nil
	soundButtonOn:removeEventListener ( "tap", turningSound )
	soundButtonOn:removeSelf ()
	soundButtonOn = nil
	soundButtonOff:removeEventListener ( "tap", turningSound )
	soundButtonOff:removeSelf ()
	soundButtonOff = nil
	--Stopping Water Sound
	audio.stop ( 2 )
	audio.dispose ( sounds.water )
	sounds.water = nil
	--Canceling Spell Timers
	if ( spellOn == true ) then
	if ( spell == 1 ) then
	timer.cancel ( shieldTimer )
	shieldTimer = nil
	elseif ( spell == 2 ) then
	timer.cancel ( invisibleTimer )
	invisibleTimer = nil
	elseif ( spell == 3 ) then
	timer.cancel ( fasterTimer )
	fasterTimer = nil
	elseif ( spell == 4 ) then
	timer.cancel ( extraPointsTimer )
	extraPointsTimer = nil
	extrapointsText:removeSelf ()
	extrapointsText = nil
	end
	spellText:removeSelf ()
	spellText = nil
	end
	--Canceling Timers ( Acitivation Timers Nill-Out )
	timer.cancel ( spawnActivationTimer1 )
	spawnActivationTimer1 = nil
	if ( scoreStars >= 10 and scoreStars < 30 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	elseif ( scoreStars >= 30 and scoreStars < 50 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	elseif ( scoreStars >= 50 and scoreStars < 70 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	elseif ( scoreStars >= 70 and scoreStars < 90 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	timer.cancel ( spawnActivationTimer5 )
	spawnActivationTimer5 = nil
	elseif ( scoreStars >= 90 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	timer.cancel ( spawnActivationTimer5 )
	spawnActivationTimer5 = nil
	timer.cancel ( spawnActivationTimer6 )
	spawnActivationTimer6 = nil
	end
	for i = 1, #spawnBallsTimer do
    timer.cancel (spawnBallsTimer[i])
    spawnBallsTimer[i] = nil
    end
    if ( spellBallTimerOn == true ) then
    timer.cancel ( spellBallTimer )
    spellBallTimer = nil
    end
	--Removing Runtime Listeners
	Runtime:removeEventListener ( "enterFrame", movement )
	Runtime:removeEventListener ( "enterFrame", groupMove )
	Runtime:removeEventListener ( "enterFrame", playerWrap )
	Runtime:removeEventListener ( "enterFrame", removePlayer )
	Runtime:removeEventListener ( "enterFrame", gameoverStatus )
	Runtime:removeEventListener ( "enterFrame", gameoverScreen )
	Runtime:removeEventListener ( "enterFrame", scoreStarsUpdate )
	--Removing Round Score Buttons ( Ungroup Objects )
	buttonLeft:removeEventListener ( "touch", moveLeft )
	buttonLeft:removeSelf ()
	buttonLeft = nil
	buttonRight:removeEventListener ( "touch", moveRight )
	buttonRight:removeSelf ()
	buttonRight = nil
	scoreStarsText:removeSelf ()
	scorestarsText = nil
	bestScoreText:removeSelf ()
	bestScoreText = nil
	playerLivesText:removeSelf ()
	playerLivesText = nil
	pauseButton:removeEventListener ( "tap", pauseGame )
	pauseButton:removeSelf ()
	pauseButton = nil
	backToMenuPause2 ()
end

--Backing to Menu from Pause ( Continuation )
function backToMenuPause2 ()
	--Removing Display Objects and Group
	group:removeSelf ()
	background = nil
	glassTube = nil
	ball = nil
	downFloor = nil
	scoreWall = nil
	crate = nil
	group = nil
	--Physics
	physics = nil
	--Constants
	wScreen = nil
	hScreen = nil
	mRandom = nil
	playerShape = nil
	ballCollisionFilter = nil
	floorCollisionFilter = nil
	playerCollisionFilter = nil
	staticObject = nil
	ballObject = nil
	sensorObject = nil
	playerObject = nil
	--Variables
	motionRight = nil
	motionLeft = nil
	speedX = nil
	motionX = nil
	playerLives = nil
	gameplay = nil
	gameover = nil
	scoreStars = nil
	ballDirected = nil
	spellBallOnScreen = nil
	spellOn = nil
	throwSpell = nil
	spellBallTimerOn = nil
	spell = nil
	shield = nil
	invisible = nil
	faster = nil
	extraPoints = nil
	scoreExtraPoints = nil
	--Timers
	spawnBallsTimer = nil
	--Sounds and Table
	audio.dispose ( sounds.crate )
	sounds.crate = nil
	audio.dispose ( sounds.playerDamage )
	sounds.playerDamage = nil
	audio.dispose ( sounds.bounce1 )
	sounds.bounce1 = nil
	audio.dispose ( sounds.bounce2 )
	sounds.bounce2 = nil
	audio.dispose ( sounds.bounce3 )
	sounds.bounce3 = nil
	audio.dispose ( sounds.gameover )
	sounds.gameover = nil
	audio.dispose ( sounds.tap )
	sounds.tap = nil
	sounds = nil
	--Calling Main Function to Restart
	main ()
end

--Rating App Alert
function ratingApp (e)
	if ( e.index == 2 ) then
	system.openURL ( "http://apple.com" )
	elseif ( e.index == 1 ) then
	rateAlert = nil
	end
end

--Creating Gameover Screen
function gameoverScreen ()
	if ( gameplay == false and gameover == true ) then
	--Stopping Water Sound
	audio.stop ( 2 )
	audio.dispose ( sounds.water )
	sounds.water = nil
	--Playing Gameover Sound ( Calling Gameover Screen )
	audio.play ( sounds.gameover, { channel = 3, loops = 0 } )
	--Canceling Timers ( Acitivation Timers Nill-Out )
	timer.cancel ( spawnActivationTimer1 )
	spawnActivationTimer1 = nil
	if ( scoreStars >= 10 and scoreStars < 30 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	elseif ( scoreStars >= 30 and scoreStars < 50 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	elseif ( scoreStars >= 50 and scoreStars < 70 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	elseif ( scoreStars >= 70 and scoreStars < 90 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	timer.cancel ( spawnActivationTimer5 )
	spawnActivationTimer5 = nil
	elseif ( scoreStars >= 90 ) then
	timer.cancel ( spawnActivationTimer2 )
	spawnActivationTimer2 = nil
	timer.cancel ( spawnActivationTimer3 )
	spawnActivationTimer3 = nil
	timer.cancel ( spawnActivationTimer4 )
	spawnActivationTimer4 = nil
	timer.cancel ( spawnActivationTimer5 )
	spawnActivationTimer5 = nil
	timer.cancel ( spawnActivationTimer6 )
	spawnActivationTimer6 = nil
	end
	for i = 1, #spawnBallsTimer do
    timer.cancel (spawnBallsTimer[i])
    spawnBallsTimer[i] = nil
    end
    if ( spellBallTimerOn == true ) then
    timer.cancel ( spellBallTimer )
    spellBallTimer = nil
    end
	--Removing Runtime Listeners
	Runtime:removeEventListener ( "enterFrame", movement )
	Runtime:removeEventListener ( "enterFrame", groupMove )
	Runtime:removeEventListener ( "enterFrame", playerWrap )
	Runtime:removeEventListener ( "enterFrame", removePlayer )
	Runtime:removeEventListener ( "enterFrame", gameoverStatus )
	Runtime:removeEventListener ( "enterFrame", gameoverScreen )
	Runtime:removeEventListener ( "enterFrame", scoreStarsUpdate )
	--Removing Round Score Buttons ( Ungroup Objects )
	buttonLeft:removeEventListener ( "touch", moveLeft )
	buttonLeft:removeSelf ()
	buttonLeft = nil
	buttonRight:removeEventListener ( "touch", moveRight )
	buttonRight:removeSelf ()
	buttonRight = nil
	scoreStarsText:removeSelf ()
	scorestarsText = nil
	bestScoreText:removeSelf ()
	bestScoreText = nil
	playerLivesText:removeSelf ()
	playerLivesText = nil
	pauseButton:removeEventListener ( "tap", pauseGame )
	pauseButton:removeSelf ()
	pauseButton = nil
	--Calling Gameover Screen 2
	gameoverScreen2 ()
	end
end

--Completing Gameover Screen Function
function gameoverScreen2 ()
	if ( gameplay == false and gameover == true ) then
	--Creating Gameover Screen
	blackScreen = display.newImage ( "BlackScreen.png" )
	blackScreen.anchorX = 0.5
	blackScreen.anchorY = 0.5
	blackScreen.x = wScreen * 0.5
	blackScreen.y = hScreen * 0.5
	gameoverText = display.newImage ( "TextGameOver.png" )
	gameoverText.anchorX = 0.5
	gameoverText.anchorY = 0
	gameoverText.x = wScreen * 0.5
	gameoverText.y = hScreen - 300
	scoreText = display.newImage ( "TextScore.png" )
	scoreText.anchorX = 0.5
	scoreText.anchorY = 0
	scoreText.x = wScreen * 0.5
	scoreText.y = hScreen - 222
	totalScoreText = display.newText ( scoreStars, 0, 0, native.systemFont, 110 )
	totalScoreText.anchorX = 0.5
	totalScoreText.anchorY = 0
	totalScoreText.x = wScreen * 0.5
	totalScoreText.y = hScreen - 190
	restartButton = display.newImage ( "ButtonReset.png" )
	restartButton.anchorX = 0.5
	restartButton.anchorY = 1
	restartButton.x = wScreen * 0.5 + 37
	restartButton.y = hScreen - 20
	restartButton:addEventListener ( "tap", restartGame )
	menuButton = display.newImage ( "ButtonMenu.png" )
	menuButton.anchorX = 0.5
	menuButton.anchorY = 1
	menuButton.x = wScreen * 0.5 - 37
	menuButton.y = hScreen - 20
	menuButton:addEventListener ( "tap", backToMenu )
	--Creating Rate Alert
	alert = mRandom ( 1, 10 )
	if ( alert == 1 ) then
	rateAlert = native.showAlert ( "Rate Us!", "Are you having fun? Give us 5 stars.", {"Later", "Yes"}, ratingApp )
	end
	--Changing Best Score Value
	if ( scoreStars > variable.bestScore ) then
	variable.bestScore = scoreStars
	highscoreText = display.newImage ( "HighscoreText.png" )
	highscoreText.anchorX = 0.5
	highscoreText.anchorY = 0.5
	highscoreText.x = wScreen - 80
	highscoreText.y = hScreen * 0.5 + 30
	highscoreOn = true
	end
	end
end

--Restarting Game
function restartGame ()
	--Removing Gameover Screen
	blackScreen:removeSelf ()
	blackScreen = nil
	gameoverText:removeSelf ()
	gameoverText = nil
	scoreText:removeSelf ()
	scoreText = nil
	totalScoreText:removeSelf ()
	totalScoreText = nil
	if ( highscoreOn == true ) then
	highscoreText:removeSelf ()
	highscoreText = nil
	highscoreOn = false
	end
	restartButton:removeEventListener ( "tap", restartGame )
	restartButton:removeSelf ()
	restartButton = nil
	menuButton:removeSelf ()
	menuButton = nil
	--Removing Display Objects and Group
	group:removeSelf ()
	background = nil
	glassTube = nil
	ball = nil
	downFloor = nil
	scoreWall = nil
	crate = nil
	group = nil
	--Physics
	physics = nil
	--Constants
	wScreen = nil
	hScreen = nil
	mRandom = nil
	playerShape = nil
	ballCollisionFilter = nil
	floorCollisionFilter = nil
	playerCollisionFilter = nil
	staticObject = nil
	ballObject = nil
	sensorObject = nil
	playerObject = nil
	--Variables
	motionRight = nil
	motionLeft = nil
	speedX = nil
	motionX = nil
	playerLives = nil
	gameplay = nil
	gameover = nil
	scoreStars = nil
	ballDirected = nil
	spellBallOnScreen = nil
	spellOn = nil
	throwSpell = nil
	spellBallTimerOn = nil
	spell = nil
	shield = nil
	invisible = nil
	faster  = nil
	extraPoints = nil
	scoreExtraPoints = nil
	alert = nil
	highscoreOn = nil
	--Timers
	spawnBallsTimer = nil
	--Sounds and Table
	audio.dispose ( sounds.crate )
	sounds.crate = nil
	audio.dispose ( sounds.playerDamage )
	sounds.playerDamage = nil
	audio.dispose ( sounds.bounce1 )
	sounds.bounce1 = nil
	audio.dispose ( sounds.bounce2 )
	sounds.bounce2 = nil
	audio.dispose ( sounds.bounce3 )
	sounds.bounce3 = nil
	audio.stop ( 3 )
	audio.dispose ( sounds.gameover )
	sounds.gameover = nil
	audio.dispose ( sounds.tap )
	sounds.tap = nil
	sounds = nil
	--Calling Main Function to Restart
	main ()
end

--Getting Back to Menu ( Restarting Variables and More )
function backToMenu ()
	firstStart = true
	--Removing Gameover Screen
	blackScreen:removeSelf ()
	blackScreen = nil
	gameoverText:removeSelf ()
	gameoverText = nil
	scoreText:removeSelf ()
	scoreText = nil
	totalScoreText:removeSelf ()
	totalScoreText = nil
	if ( highscoreOn == true ) then
	highscoreText:removeSelf ()
	highscoreText = nil
	highscoreOn = false
	end
	restartButton:removeEventListener ( "tap", restartGame )
	restartButton:removeSelf ()
	restartButton = nil
	menuButton:removeEventListener ( "tap", backToMenu )
	menuButton:removeSelf ()
	menuButton = nil
	--Removing Display Objects and Group
	group:removeSelf ()
	background = nil
	glassTube = nil
	ball = nil
	downFloor = nil
	scoreWall = nil
	crate = nil
	group = nil
	--Constants
	wScreen = nil
	hScreen = nil
	mRandom = nil
	playerShape = nil
	ballCollisionFilter = nil
	floorCollisionFilter = nil
	playerCollisionFilter = nil
	staticObject = nil
	ballObject = nil
	sensorObject = nil
	playerObject = nil
	--Variables
	motionRight = nil
	motionLeft = nil
	speedX = nil
	motionX = nil
	playerLives = nil
	gameplay = nil
	gameover = nil
	scoreStars = nil
	ballDirected = nil
	spellBallOnScreen = nil
	spellOn = nil
	throwSpell = nil
	spellBallTimerOn = nil
	spell = nil
	shield = nil
	invisible = nil
	faster = nil
	extraPoints = nil
	scoreExtraPoints = nil
	alert = nil
	highscoreOn = nil
	--Timers
	spawnBallsTimer = nil
	--Sounds and Table
	audio.dispose ( sounds.crate )
	sounds.crate = nil
	audio.dispose ( sounds.playerDamage )
	sounds.playerDamage = nil
	audio.dispose ( sounds.bounce1 )
	sounds.bounce1 = nil
	audio.dispose ( sounds.bounce2 )
	sounds.bounce2 = nil
	audio.dispose ( sounds.bounce3 )
	sounds.bounce3 = nil
	audio.stop ( 3 )
	audio.dispose ( sounds.gameover )
	sounds.gameover = nil
	audio.dispose ( sounds.tap )
	sounds.tap = nil
	sounds = nil
	--Calling Main Function to Restart
	main ()
end

main ()

--Pausing Game On Suspend
local function pauseOnSuspend (e)
	if gameplay then
		if ( gameplay == true and e.type == "applicationSuspend" ) then
		pauseGame ()
		end
	end
end
Runtime:addEventListener ( "system", pauseOnSuspend )

--Tracking FPS and Memory Usage
local fps = require("fps")
local performance = fps.PerformanceOutput.new()
performance.group.xScale = 0.8
performance.group.yScale = 0.8
performance.group.x = wScreen - 100
performance.group.y = hScreen - 100
performance.group.isVisible = false