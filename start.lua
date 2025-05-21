local start = {}

function start.load()
    -- Menu elements
    start.font = love.graphics.newFont(32)
    
    -- Button positions
    start.buttons = {
        play = {x = 300, y = 400, w = 200, h = 50}
    }
end

function start.draw()
    -- Draw background
    love.graphics.setBackgroundColor(0.2, 0.4, 0.6)
    
    -- Draw button
    love.graphics.setColor(0.98, 0.52, 0.65)  -- Pink
    love.graphics.rectangle("fill", start.buttons.play.x, start.buttons.play.y, start.buttons.play.w, start.buttons.play.h, 5)
    love.graphics.setColor(1, 1, 1)  -- White text
    love.graphics.setFont(start.font)
    love.graphics.printf("PLAY", start.buttons.play.x, start.buttons.play.y + 15, start.buttons.play.w, "center")
end

function start.mousepressed(x, y)
    local btn = start.buttons.play
    if x > btn.x and x < btn.x + btn.w and
       y > btn.y and y < btn.y + btn.h then
        return "game"
    end
    return "menu"
end

return start