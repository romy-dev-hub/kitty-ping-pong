local game = {}

function game.load()
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
    -- Draw background
    love.graphics.setBackgroundColor(0.96, 0.89, 0.87)  -- Light pink

    -- Draw paddles
    love.graphics.setColor(0.98, 0.52, 0.65)  -- Pink
    love.graphics.rectangle("fill", game.paddles.left.x, game.paddles.left.y, 20, 100, 5)
    love.graphics.rectangle("fill", game.paddles.right.x, game.paddles.right.y, 20, 100, 5)

    -- Draw ball
    love.graphics.setColor(0.98, 0.88, 0.19)  -- Yellow
    love.graphics.circle("fill", game.ball.x, game.ball.y, 15)

    -- Draw score
    love.graphics.setColor(0.29, 0.29, 0.29)  -- Dark gray
    love.graphics.print("Score: " .. game.score.left, 50, 20)
    love.graphics.print("Score: " .. game.score.right, 650, 20)
end

return game