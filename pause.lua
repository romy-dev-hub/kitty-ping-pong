local pause = {}

function pause.load()
    pause.font = love.graphics.newFont(32)
    pause.buttons = {
        resume = {x = 300, y = 300, w = 200, h = 50},
        menu = {x = 300, y = 400, w = 200, h = 50}
    }
end

function pause.draw()
    -- Dark overlay
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, 800, 600)
    love.graphics.setColor(1, 1, 1)
    
    -- Draw buttons
    love.graphics.printf("PAUSED", 0, 200, 800, "center")
    love.graphics.printf("Resume", 300, 315, 200, "center")
    love.graphics.printf("Main Menu", 300, 415, 200, "center")
end

function pause.mousepressed(x, y)
    if x > 300 and x < 500 then
        if y > 300 and y < 350 then return "game" end
        if y > 400 and y < 450 then return "menu" end
    end
    return "pause"
end

return pause