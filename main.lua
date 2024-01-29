-- Biblioteca para criar uma resolução virtual, em vez do tamanho da janela
-- https://github.com/Ulydev/push
push = require "push"

-- Biblioteca que nos permite usar classes como na orientação a objetos
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require "class"

-- Importando nossas classes
require "Ball"
require "Paddle"

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
    -- Deixando o jogo aleatório, para isso usamos o tempo do sistema como seed
    -- pois ele irá variar sempre na inicialização
    math.randomseed(os.time())

    -- Usando o filtro para evitar o desfoque no texto
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Objeto com a nova fonte para textos
    retroFont = love.graphics.newFont("font.ttf", 8)

    -- Fonte para desenhar a pontuação de cada player na tela
    scoreFont = love.graphics.newFont("font.ttf", 32)

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

    -- Inicializando as raquetes
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- Criando a instância do objeto Ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- Guardando o estado do jogo
    gameState = "start"
end

-- Executa a cada quadro
function love.update(dt)
    -- Movimentação do player 1
    if love.keyboard.isDown("w") then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Movimentação do player 2
    if love.keyboard.isDown("up") then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- Atualiza o movimento da bola se estivermos no estado de jogo "play"
    if gameState == "play" then
        ball:update(dt)
    end
    -- Atualizando o movimento das raquetes
    player1:update(dt)
    player2:update(dt)
end

-- Captura as teclas pressionadas
function love.keypressed(key)
    -- Se a tecla pressionada foi a tecla de escape (ESC)
    if key == "escape" then
        -- Encerrando o jogo
        love.event.quit()
    elseif key == "enter" or key == "return" then
        -- Caso o estado esteja em "start" mude para "play"
        if gameState == "start" then
            gameState = "play"
        else
            -- Caso contrário volte para "start"
            gameState = "start"

            -- Volve a bola para posição inicial
            ball:reset()
        end
    end
end

-- Função para desenhar na tela
function love.draw()
    -- Começando a renderizar na resolução virtual
    push:apply("start")

    -- Definindo a cor de background do jogo
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    -- Definindo a fonte do texto
    love.graphics.setFont(retroFont)

    -- Desenhando um texto na tela
    if gameState == "start" then
        love.graphics.printf("Hello Start State!", 0, 20, VIRTUAL_WIDTH, "center")
    else
        love.graphics.printf("Hello Play State!", 0, 20, VIRTUAL_WIDTH, "center")
    end

    -- Desenhando a pontuação no centro da tela
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)

    -- Renderizando as raquetes
    player1:render()
    player2:render()

    -- Renderizando a bola no centro
    ball:render()

    -- Finalizando a renderização na resolução virtual
    push:apply("end")
end
