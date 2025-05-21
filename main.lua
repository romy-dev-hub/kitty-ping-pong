local start = require("start")
local game = require("game")
local pause = require("pause")

function love.load()
    -- Set the window title and dimensions
    love.window.setTitle("Kitty Ping Pong 🐱")
    love.window.setMode(800, 600)
    window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    -- Game state
    gameOver = false
    score = 0
    lives = 3
    ball_base_speed = 200
    max_speed = 500

    -- Generate synthetic sounds
    function generateBeep(frequency, duration)
        local sampleRate = 44100
        local samples = math.floor(duration * sampleRate)
        local soundData = love.sound.newSoundData(samples, sampleRate, 16, 1)
        
        for i = 0, samples - 1 do
            local t = i / sampleRate
            soundData:setSample(i, math.sin(t * frequency * math.pi * 2))
        end
        
        return love.audio.newSource(soundData)
    end

    sounds = {
        hit = generateBeep(523.25, 0.1),  -- C5 note
        lose = generateBeep(220.00, 0.3)   -- A3 note
    }

    -- Initialize game objects
    resetGame()

    -- Fonts
    scoreFont = love.graphics.newFont(20)
    gameOverFont = love.graphics.newFont(30)

    -- Initialize game states
    currentState = "menu"
    start.load()
    game.load()
    pause.load()
end

function resetGame()
    ball = {
        x = 400,
        y = 300,
        radius = 15,
        speed = ball_base_speed,
        dx = 0,
        dy = 0
    }

    paddle_width = 20
    paddle_height = 100
    paddle_speed = 400

    hand1 = {
        x = 50,
        y = window_height - paddle_height - 10,
        width = paddle_width,
        height = paddle_height,
    }

    hand2 = {
        x = window_width - paddle_width - 50,
        y = window_height - paddle_height - 10,
        width = paddle_width,
        height = paddle_height,
    }

    -- Ensure ball starts with vertical movement
    repeat
        ball.dx = love.math.random(-1, 1)
        ball.dy = love.math.random(-1, 1)
    until math.abs(ball.dy) > 0  -- Force vertical movement
    normalizeDirection()
end

function love.update(dt)
    if gameOver then return end

    -- Ball movement
    ball.x = ball.x + ball.dx * ball.speed * dt
    ball.y = ball.y + ball.dy * ball.speed * dt

    -- Wall collisions
    if ball.x - ball.radius < 0 or ball.x + ball.radius > window_width then
        ball.dx = -ball.dx
    end
    if ball.y - ball.radius < 0 then
        ball.dy = -ball.dy
    end

    -- Paddle collisions
    for _, hand in ipairs({hand1, hand2}) do
        if CheckCollision(ball, hand) then
            sounds.hit:play()
            ball.dy = -ball.dy
            ball.y = hand.y - ball.radius
            score = score + 1
            ball.speed = math.min(ball.speed + 10, max_speed)
            
            -- Add directional influence
            if (hand == hand1 and love.keyboard.isDown("d")) or 
               (hand == hand2 and love.keyboard.isDown("right")) then
                ball.dx = math.abs(ball.dx)
            elseif (hand == hand1 and love.keyboard.isDown("a")) or 
                   (hand == hand2 and love.keyboard.isDown("left")) then
                ball.dx = -math.abs(ball.dx)
            end
        end
    end

    -- Left paddle controls (fixed movement bounds)
    if love.keyboard.isDown("a") then
        hand1.x = math.max(10, hand1.x - paddle_speed * dt)
    elseif love.keyboard.isDown("d") then
        hand1.x = math.min(window_width - paddle_width - 10, hand1.x + paddle_speed * dt)
    end

    -- Right paddle controls
    if love.keyboard.isDown("left") then
        hand2.x = math.max(10, hand2.x - paddle_speed * dt)
    elseif love.keyboard.isDown("right") then
        hand2.x = math.min(window_width - paddle_width - 10, hand2.x + paddle_speed * dt)
    end

    -- Bottom collision
    if ball.y + ball.radius > window_height then
        sounds.lose:play()
        lives = lives - 1
        if lives <= 0 then
            gameOver = true
        else
            resetBall()
        end
    end

    if currentState == "game" then
        game.update(dt)
    end
end

function love.draw()
    -- Draw background
    love.graphics.setBackgroundColor(0.96, 0.89, 0.87)  -- Light pink

    -- Draw paddles (cat paws)
    love.graphics.setColor(1, 1, 1)  -- Reset color to white for images
    love.graphics.draw(paddleImg, hand1.x, hand1.y)
    love.graphics.draw(paddleImg, hand2.x, hand2.y)

    -- Draw ball (yarn)
    if not gameOver then
       love.graphics.setColor(1, 1, 1)  -- Reset color
       love.graphics.draw(ballImg, ball.x - ball.radius, ball.y - ball.radius)  -- Adjust for center
    end

    -- Draw UI
    love.graphics.setColor(0.29, 0.29, 0.29)  -- Dark gray
    love.graphics.setFont(scoreFont)
    love.graphics.print("Score: "..score, 10, 10)
    love.graphics.print("Lives: "..lives, window_width - 100, 10)

    -- Draw game over screen
    if gameOver then
        love.graphics.setFont(gameOverFont)
        love.graphics.setColor(0.86, 0.20, 0.18)  -- Red
        local text = "Game Over! Final Score: "..score.."\nPress R to restart"
        love.graphics.printf(text, 0, window_height/2 - 50, window_width, "center")
    end

    if currentState == "menu" then
        start.draw()
    elseif currentState == "game" then
        game.draw()
    elseif currentState == "pause" then
        pause.draw()
    end
end

function CheckCollision(ball, hand)
    return ball.x + ball.radius > hand.x
        and ball.x - ball.radius < hand.x + hand.width
        and ball.y + ball.radius > hand.y
        and ball.y - ball.radius < hand.y + hand.height
end

function normalizeDirection()
    if ball.dx == 0 and ball.dy == 0 then
        ball.dx = love.math.random(-1, 1)
        ball.dy = love.math.random(-1, 1)
    end
    local length = math.sqrt(ball.dx^2 + ball.dy^2)
    ball.dx = ball.dx / length
    ball.dy = ball.dy / length
end

function resetBall()
    ball.x = window_width/2
    ball.y = window_height/2
    ball.speed = ball_base_speed
    ball.dx = love.math.random(-1, 1)
    ball.dy = love.math.random(-1, 1)
    normalizeDirection()
end

function love.keypressed(key)
    if key == "r" and gameOver then
        gameOver = false
        score = 0
        lives = 3
        resetGame()
    end

    if key == "escape" then
        if currentState == "game" then
            currentState = "pause"
        elseif currentState == "pause" then
            currentState = "game"
        end
    end
end

function love.mousepressed(x, y)
    if currentState == "menu" then
        currentState = start.mousepressed(x, y)
    elseif currentState == "pause" then
        currentState = pause.mousepressed(x, y)
    end
end