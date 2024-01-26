-- Definindo as dimensões da janela
WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

-- Função usada para inicializar o jogo
function love.load()
    -- Definindo as configurações da janela do jogo
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- Captura as teclas pressionadas
function love.keypressed(key)
    -- Se a tecla pressionada foi a tecla de escape (ESC)
    if key == "escape" then
        -- Encerrando o jogo
        love.event.quit()
    end
end

-- Função para desenhar na tela
function love.draw()
    -- Desenhando um texto na tela
    love.graphics.printf("Hello Pong!", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")
end
