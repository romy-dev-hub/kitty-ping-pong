function love.load()
    -- Set the window dimensions
    love.window.setMode(800, 600)
    window_width = love.graphics.getWidth()
    window_height = love.graphics.getHeight()

    ball = {
        x = 400, -- Start in the middle of the screen (width / 2)
        y = 300, -- Start in the middle of the screen (height / 2)
        radius = 15,
        speed = 200, 
        dx = love.math.random(-1, 1),
        dy = love.math.random(-1, 1)
    }

    paddle_width = 20
    paddle_height = 100
    paddle_speed = 400
    paddle_angle = 0

    -- left hand
    hand1 = {
        x = 50,
        y = window_height - paddle_height - 10,
        width = paddle_width,
        height = paddle_height,
    }

    -- right hand 
    hand2 = {
        x = window_width - paddle_width - 50,
        y = window_height - paddle_height - 10,
        width = paddle_width,
        height = paddle_height,
    }

    -- Normalize direction to avoid very slow diagonal movement
    normalizeDirection()

    
end

local gameOver = false

function love.update(dt)

    if gameOver then 
    
      return
    end

  -- bruh this ball doesn't want to lose HHHHHHHHHHHHHHHHHHHHHHHHHH

    -- Update the ball's position
    ball.x = ball.x + ball.dx * ball.speed * dt
    ball.y = ball.y + ball.dy * ball.speed * dt

    -- Check for collisions with window boundaries and reverse direction if necessary
    if ball.x - ball.radius < 0 or ball.x + ball.radius > love.graphics.getWidth() then
        ball.dx = -ball.dx
    end
    if ball.y - ball.radius < 0 or ball.y + ball.radius > love.graphics.getHeight() then
        ball.dy = -ball.dy
    end

    -- check the hands collision with the ball 
    --left hand
    if ball.x + ball.radius > hand1.x and ball.x - ball.radius < hand1.x + hand1.width 
       and ball.y + ball.radius > hand1.y and ball.y - ball.radius < hand1.y + hand1.height then
        ball.dy = - ball.dy
        ball.y = hand1.y - ball.radius
    end
    --right hand 
    if ball.x + ball.radius > hand2.x and ball.x - ball.radius < hand2.x + hand2.width 
       and ball.y + ball.radius > hand2.y and ball.y - ball.radius < hand1.y + hand2.height then
        ball.dy = - ball.dy
        ball.y = hand2.y - ball.radius
    end

    --left hand mouvement 
    if love.keyboard.isDown("a")then
        hand1.x =  math.max(0, hand1.x - paddle_speed * dt)
      else if love.keyboard.isDown("d")then
        hand1.x = math.min(window_width - paddle_width,  hand1.x + paddle_speed * dt)
      end
    end

    --right hand mouvement 
    if love.keyboard.isDown("left")then
        hand2.x = math.max(0, hand2.x - paddle_speed * dt)
      else if love.keyboard.isDown("right")then
        hand2.x = math.min(window_width - paddle_width , hand2.x + paddle_speed * dt)
      end
    end

    -- Game over condition
    if ball.y + ball.radius > window_height then
        gameOver = true
        ball.dx = 0
        ball.dy = 0
    end
 

end

function love.draw()

   
    love.graphics.rectangle("fill", hand1.x, hand1.y, hand1.width, hand1.height)
    love.graphics.rectangle("fill", hand2.x, hand2.y, hand2.width, hand2.height)

    if not gameOver then 
        love.graphics.circle("fill", ball.x, ball.y, ball.radius)
    else
        -- Set text properties
        love.graphics.setColor(1, 0, 0) -- Red color
        love.graphics.setFont(love.graphics.newFont(30))
        
        -- Calculate centered position
        local text = "You lost! Press R to replay"
        local text_width = love.graphics.getFont():getWidth(text)
        local text_height = love.graphics.getFont():getHeight()
        
        -- Draw centered text
        love.graphics.printf(
            text,
            (window_width - text_width) / 2,
            (window_height - text_height) / 2,
            window_width,
            "center"
        )
        
        -- Reset color to white
        love.graphics.setColor(1, 1, 1)
    end
    
end

function normalizeDirection()
    local length = math.sqrt(ball.dx^2 + ball.dy^2)
    if length == 0 then
        -- Avoid division by 0; if both dx and dy are 0, assign new random values
        ball.dx = love.math.random(-1, 1)
        ball.dy = love.math.random(-1, 1)
        length = math.sqrt(ball.dx^2 + ball.dy^2)
    end
    ball.dx = ball.dx / length
    ball.dy = ball.dy / length
end

function love.keypressed(key)
    if key == "r" and gameOver then 
        -- Reset game state
        gameOver = false
        -- Reset ball
        ball.x = 400
        ball.y = 300
        ball.dx = love.math.random(-1, 1)
        ball.dy = love.math.random(-1, 1)
        normalizeDirection()
        -- Reset paddles
        hand1.x = 50
        hand2.x = window_width - paddle_width - 50
    end
end