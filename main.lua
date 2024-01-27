-- Biblioteca para criar uma resolução virtual, em vez do tamanho da janela
-- https://github.com/Ulydev/push
push = require "push"

-- Definindo as dimensões da janela
WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

-- Definindo as dimensões da janela virtual
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Definindo a velocidade da raquete
PADDLE_SPEED = 200

-- Função usada para inicializar o jogo
function love.load()
    -- Usando o filtro para evitar o desfoque no texto
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Objeto com a nova fonte para textos
    retroFont = love.graphics.newFont('font.ttf', 8)

    -- Fonte para desenhar a pontuação de cada player na tela
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- Definindo a fonte ativa
    love.graphics.setFont(retroFont)

    -- Definindo a resolução virtual, que será renderizada dentro das dimensões da janela real
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Inicializando as variáveis de pontuação
    player1Score = 0
    player2Score = 0

    -- Posição das raquetes
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end

-- Executa a cada quadro
function love.update(dt)
    -- Movimentação do player 1
    if love.keyboard.isDown('w') then
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    -- Movimentação do player 2
    if love.keyboard.isDown('up') then
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
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
    love.graphics.setFont(retroFont)
    love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, "center")

    -- Desenhando a pontuação no centro da tela
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Renderizando a primeira raquete (Esquerda)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- Renderizando a segunda raquete (Direita)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- Renderizando a bola no centro
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Finalizando a renderização na resolução virtual
    push:apply('end')
end
