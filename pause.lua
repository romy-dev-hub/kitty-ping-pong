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
    
    -- Draw text and buttons
    love.graphics.printf("PAUSED", 0, 200, 800, "center")
    love.graphics.setColor(0.98, 0.52, 0.65)  -- Pink
    love.graphics.rectangle("fill", pause.buttons.resume.x, pause.buttons.resume.y, pause.buttons.resume.w, pause.buttons.resume.h, 5)
    love.graphics.rectangle("fill", pause.buttons.menu.x, pause.buttons.menu.y, pause.buttons.menu.w, pause.buttons.menu.h, 5)
    love.graphics.setColor(1, 1, 1)  -- White text
    love.graphics.printf("Resume", pause.buttons.resume.x, pause.buttons.resume.y + 15, pause.buttons.resume.w, "center")
    love.graphics.printf("Main Menu", pause.buttons.menu.x, pause.buttons.menu.y + 15, pause.buttons.menu.w, "center")
end

function pause.mousepressed(x, y)
    if x > 300 and x < 500 then
        if y > 300 and y < 350 then return "game" end
        if y > 400 and y < 450 then return "menu" end
    end
    return "pause"
end

return pause