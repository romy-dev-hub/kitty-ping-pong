local game = {}

function game.load()
    -- Load game assets
    game.background = love.graphics.newImage("assets/background.png")
    game.paddleImg = love.graphics.newImage("assets/paddle.png")
    game.ballImg = love.graphics.newImage("assets/ball.png")
    
    -- Initialize game objects
    game.paddles = {
        left = {x = 50, y = 250},
        right = {x = 700, y = 250}
    }
    game.ball = {x = 400, y = 300}
    game.score = {left = 0, right = 0}
end

function game.update(dt)
    -- Add your game update logic here
end

function game.draw()
    love.graphics.draw(game.background, 0, 0)
    
    -- Draw paddles
    love.graphics.draw(game.paddleImg, game.paddles.left.x, game.paddles.left.y)
    love.graphics.draw(game.paddleImg, game.paddles.right.x, game.paddles.right.y)
    
    -- Draw ball
    love.graphics.draw(game.ballImg, game.ball.x, game.ball.y)
    
    -- Draw score
    love.graphics.print("Score: "..game.score.left, 50, 20)
    love.graphics.print("Score: "..game.score.right, 650, 20)
end

return game