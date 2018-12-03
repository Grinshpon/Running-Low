love.window.setTitle("Running Low")
love.graphics.setDefaultFilter("nearest", "nearest") --essentially removes interpolations so pixel graphics remain crisp when upscaled
love.mouse.setCursor(love.mouse.newCursor("Images/g_cursor.png",9,9))

game = require ".game" --main game logic, below is title/options menus plus main loop

paused = nil
gameStarted = nil
optionsMenu = {resolution=3}
titleScreen = {}
gameOverScreen = {}
keyInputTable = {}
timeSurvived = 0
--putting definitions in init function allows you to call love.load() to effectively restart game without closing it
function init()
    timeSurvived = 0
    paused = false
    gameStarted = false --one time use variable

    optionsMenu = {resolution=optionsMenu.resolution,sound=true, menu={
	    {"Resolution",sub={
		{"800x800",function() optionsMenu.setResolution(1) end},
		{"1280x1280",function() optionsMenu.setResolution(2) end},
		{"1920x1920",function() optionsMenu.setResolution(3) end},
		{"Fullscreen",function() optionsMenu.setResolution(4) end},
		length = 3,
		selected = 3
	    }},
	    {"Sound: On/Off",function() optionsMenu.sound = not optionsMenu.sound end},
	    --{"Controls","WASD: Movement\nLeft Mouse: Shoot\nRight Mouse: Melee"},
	    {"Back", function() optionsMenu.showOptions = false; titleScreen.menu.cursor.pos=1; if paused then paused = false end end},
	    {"Quit", function() love.event.quit() end}, --SHOULD NOT BE RESTART, THAT WAS FOR TESTING PURPOSES (THIS MESSAGE IS FOR ME)
	    length = 4
	},setResolution=function(x)
	    optionsMenu.resolution =x
	    optionsMenu.isResolutionChanged = true
	end,
	showOptions=false,
	isResolutionChanged = true
    } --resolution: 1 = 800x800, 2 = 1280x1280, 3 = 1920x1920, 4 = fullscreen

    titleScreen = {title = nil,titleShowing = true, menu={
	{"Start",function() titleScreen.titleShowing = false; gameStarted = true end,"Continue"},
	{"Options",function() optionsMenu.showOptions = true; titleScreen.menu.cursor.pos=1 end},
	{"Quit",function() love.event.quit() end},
	length=3, --yeah I know I hardcoded the length and I'm a bad person for it. Fight me. Also the length only goes up to the options, not including the length var or the cursor object. I know I'm dumb
	cursor={pos=1,img=nil}
    }}

    gameOverScreen = {
	{"Restart?",function() love.load() end},
	length = 1,
	text="You Have Been Shut Down",
	isGameOver = false
    }

    keyInputTable = {
	["escape"]=function()
	    if not titleScreen.titleShowing then
		paused = not paused
	    end
	    if paused then
		optionsMenu.showOptions = true
	    else
		optionsMenu.showOptions = false
	    end
	    titleScreen.menu.cursor.pos = 1
	end,
	["s"]= function()
	    if optionsMenu.showOptions then
		if titleScreen.menu.cursor.pos < optionsMenu.menu.length then
		    titleScreen.menu.cursor.pos = titleScreen.menu.cursor.pos + 1
		end
	    elseif titleScreen.titleShowing then
	       if titleScreen.menu.cursor.pos < titleScreen.menu.length then
		   titleScreen.menu.cursor.pos = titleScreen.menu.cursor.pos + 1
	       elseif titleScreen.menu.cursor.pos > titleScreen.menu.length then
		   titleScreen.menu.cursor.pos = 1
	       end
	    end
	end,
	["w"]= function()
	    if optionsMenu.showOptions then
		if titleScreen.menu.cursor.pos > 1 then
		    titleScreen.menu.cursor.pos = titleScreen.menu.cursor.pos -1
		end
	    elseif titleScreen.titleShowing then
		if titleScreen.menu.cursor.pos > 1 then
		    titleScreen.menu.cursor.pos = titleScreen.menu.cursor.pos -1
		end
	    end
	end,
	["a"]= function()
	    if optionsMenu.showOptions then
		if titleScreen.menu.cursor.pos == 1 then
		    if optionsMenu.menu[1].sub.selected > 1 then
			optionsMenu.menu[1].sub.selected = optionsMenu.menu[1].sub.selected -1
		    end
		end
	    end
	end,
	["d"]= function()
	    if optionsMenu.showOptions then
		if titleScreen.menu.cursor.pos == 1 then
		    if optionsMenu.menu[1].sub.selected < optionsMenu.menu[1].sub.length then
			optionsMenu.menu[1].sub.selected = optionsMenu.menu[1].sub.selected +1
		    end
		end
	    end
	end,
	["return"]=function()
	    if optionsMenu.showOptions then
		--if titleScreen.menu.cursor.pos % 2 == 0 or titleScreen.menu.cursor.pos == 5 then
		if titleScreen.menu.cursor.pos ~= 1 then
		    optionsMenu.menu[titleScreen.menu.cursor.pos][2]()
		--elseif titleScreen.menu.cursor.pos == 1 then
		else
		    optionsMenu.menu[1].sub[optionsMenu.menu[1].sub.selected][2]()
		end
	    elseif titleScreen.titleShowing then
		titleScreen.menu[titleScreen.menu.cursor.pos][2]()
	    elseif gameOverScreen.isGameOver then
		gameOverScreen[1][2]()
	    end
	end,
	["space"]= function()
	    keyInputTable["return"]()
	end
    }
end

function love.load()
    init()
    love.graphics.setNewFont("Font/uni05_53.ttf",65)
    titleScreen.title = love.graphics.newImage("Images/g_title.png")
    titleScreen.menu.cursor.img = love.graphics.newImage("Images/g_select.png")
    game.start()
end

function love.update(dt)
   if optionsMenu.isResolutionChanged then
       if optionsMenu.resolution == 1 then
	   love.window.setMode(800,800,{resizable=false})
	   love.graphics.setNewFont("Font/uni05_53.ttf",65*(800/1920))
       elseif optionsMenu.resolution == 2 then
	   love.window.setMode(1280,1280,{resizable=false})
	   love.graphics.setNewFont("Font/uni05_53.ttf",65*(1280/1920))
       elseif optionsMenu.resolution == 3 then
	   love.window.setMode(1920,1920,{resizable=false})
	   love.graphics.setNewFont("Font/uni05_53.ttf",65)
       else
	   love.window.setMode(1920,1920,{fullscreen=true})
	   love.graphics.setNewFont("Font/uni05_53.ttf",65)
       end
       optionsMenu.isResolutionChanged = not optionsMenu.isResolutionChanged
   end
   if not paused and gameStarted then
       game.update(dt,paused)
       timeSurvived = timeSurvived+dt
   end
   if game.over then
       paused = true
       gameOverScreen.isGameOver = true
   end
end

function love.keypressed(key)
    for i,v in pairs(keyInputTable) do
	if key == i then
	    v()
	end
    end
end

function love.mousepressed(x,y,button,istouch,presses)
    game.mousePress(x,y,button)
end

function love.draw()
    --print(tostring(paused))--DEBUG
    local mW,mH,rH = love.graphics.getWidth()/2,love.graphics.getHeight()/3,love.graphics.getHeight()
    if titleScreen.titleShowing and not optionsMenu.showOptions then
	local tSW = titleScreen.title:getWidth()*(rH/1920)
	love.graphics.draw(titleScreen.title,mW-tSW/2,0,0,rH/1920,rH/1920) --TITLE SCREEN

	for i=1,titleScreen.menu.length,1 do
	    love.graphics.print(titleScreen.menu[i][1],mW-200,mH+(i-1)*100)
	    love.graphics.draw(titleScreen.menu.cursor.img, mW-315, mH+(titleScreen.menu.cursor.pos-1)*100,0,4*(rH/1920),4*(rH/1920))
	end
    elseif optionsMenu.showOptions then
	for i=1, optionsMenu.menu.length,1 do
	    love.graphics.print(optionsMenu.menu[i][1],mW-200,mH+(i-1)*100)
	    if i == 1 then
		love.graphics.print("< "..optionsMenu.menu[1].sub[optionsMenu.menu[1].sub.selected][1].." >",mW*1.2,mH)
	    end
	    love.graphics.draw(titleScreen.menu.cursor.img, mW-315, mH+(titleScreen.menu.cursor.pos-1)*100,0,4*(rH/1920),4*(rH/1920))
	end
    elseif gameOverScreen.isGameOver then
	love.graphics.print("You Survived For "..math.floor(timeSurvived).." Seconds",mW-200,mH)
	love.graphics.print(gameOverScreen[1][1],mW-200,mH+100)
	love.graphics.draw(titleScreen.menu.cursor.img, mW-315, mH+100,0,4*(rH/1920),4*(rH/1920))
	titleScreen.menu.cursor.pos=1
    end
    if not paused and gameStarted then
	game.draw()
    end
end
