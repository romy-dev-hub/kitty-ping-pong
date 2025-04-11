local start = {}

function start.load()
    -- Menu elements
    start.logo = love.graphics.newImage("assets/logo.png")
    start.buttonImg = love.graphics.newImage("assets/button.png")
    start.font = love.graphics.newFont(32)
    
    -- Button positions
    start.buttons = {
        play = {x = 300, y = 400, w = 200, h = 50}
    }
end

function start.draw()
    -- Draw background
    love.graphics.setBackgroundColor(0.2, 0.4, 0.6)
    
    -- Draw logo
    love.graphics.draw(start.logo, 200, 100)
    
    -- Draw buttons
    for _, btn in pairs(start.buttons) do
        love.graphics.draw(start.buttonImg, btn.x, btn.y)
        love.graphics.setFont(start.font)
        love.graphics.printf("PLAY", btn.x, btn.y + 15, btn.w, "center")
    end
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