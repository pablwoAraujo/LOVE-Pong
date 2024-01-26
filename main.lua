-- Biblioteca para criar uma resolução virtual, em vez do tamanho da janela
-- https://github.com/Ulydev/push
push = require "push"

-- Definindo as dimensões da janela
WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

-- Definindo as dimensões da janela virtual
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Função usada para inicializar o jogo
function love.load()
    -- Define a resolução virtual, que será renderizada dentro das dimensões da janela real
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
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
    -- Começando a renderizar na resolução virtual
    push:apply('start')

    -- Desenhando um texto na tela
    love.graphics.printf("Hello Pong!", 0, WINDOW_HEIGHT / 2, WINDOW_WIDTH, "center")

    -- Finalizando a renderização na resolução virtual
    push:apply('end')
end
