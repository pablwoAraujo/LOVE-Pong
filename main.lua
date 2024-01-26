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
    -- Usando o filtro para evitar o desfoque no texto
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Objeto com a nova fonte e tamanho
    retroFont = love.graphics.newFont('font.ttf', 8)

    -- Definindo a fonte ativa
    love.graphics.setFont(retroFont)

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

    -- Definindo a cor de background do jogo
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Desenhando um texto na tela
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, "center")

    -- Renderizando a primeira raquete (Esquerda)
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- Renderizando a segunda raquete (Direita)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- Renderizando a bola no centro
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Finalizando a renderização na resolução virtual
    push:apply('end')
end
