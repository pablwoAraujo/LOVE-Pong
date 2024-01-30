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

    -- Definindo o título da janela
    love.window.setTitle("Pong")

    -- Usando o filtro para evitar o desfoque no texto
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Objeto com a nova fonte para textos
    retroFont = love.graphics.newFont("font.ttf", 8)

    -- Fonte para escrever a mensagem do ganhador
    largeFont = love.graphics.newFont("font.ttf", 16)

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

    -- Definindo os efeitos sonoros
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- Inicializando quem vai sacar primeiro
    servingPlayer = 1

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
    if gameState == "serve" then
        -- Antes de começar o jogo, inicializamos a velocidade da bola com base
        -- no último jogador que pontuou
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    elseif gameState == "play" then
        -- Verifica a colisão e atualiza o movimento da bola se estivermos no estado
        -- de jogo "play"
        ballCollision()
        ball:update(dt)
    end
    -- Atualizando o movimento das raquetes
    player1:update(dt)
    player2:update(dt)
end

-- Calcula a colisão da bola com as raquetes e com as margins da tela
function ballCollision()
    if ball:collides(player1) then
        ball.dx = -ball.dx * 1.03
        ball.x = player1.x + 5

        -- Mantendo a velocidade na mesma direção, mas randomizando o ângulo
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end

        sounds['paddle_hit']:play()
    end

    if ball:collides(player2) then
        ball.dx = -ball.dx * 1.03
        ball.x = player2.x - 4

        -- Mantendo a velocidade na mesma direção, mas randomizando o ângulo
        if ball.dy < 0 then
            ball.dy = -math.random(10, 150)
        else
            ball.dy = math.random(10, 150)
        end

        sounds['paddle_hit']:play()
    end

    -- Verificando a colisão com os limites da tela superior e invertendo o
    -- movimento no eixo Y
    if ball.y <= 0 then
        ball.y = 0
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end

    -- Verificando a colisão com os limites da tela inferior e invertendo o
    -- movimento no eixo Y
    if ball.y >= VIRTUAL_HEIGHT - 4 then
        ball.y = VIRTUAL_HEIGHT - 4
        ball.dy = -ball.dy
        sounds['wall_hit']:play()
    end

    -- Se a bola ultrapassar a borda esquerda, volte a posição inicial e atualize a pontuação
    if ball.x < 0 then
        servingPlayer = 1
        player2Score = player2Score + 1
        sounds['score']:play()

        -- Se o player 2 conseguir 10 pontos o jogo termina, muda para o estado "done"
        if player2Score == 2 then
            winningPlayer = 2
            gameState = "done"
        else
            -- Se não, muda para o estado "serve" e continua o jogo
            gameState = "serve"
            -- Devolve a bola para a posição inicial
            ball:reset()
        end
    end

    -- Se a bola ultrapassar a borda direita, volte a posição inicial e atualize a pontuação
    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2
        player1Score = player1Score + 1
        sounds['score']:play()

        -- Se o player 1 conseguir 10 pontos o jogo termina, muda para o estado "done"
        if player1Score == 2 then
            winningPlayer = 1
            gameState = "done"
        else
            gameState = "serve"
            ball:reset()
        end
    end

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
end

-- Captura as teclas pressionadas
function love.keypressed(key)
    -- Se a tecla pressionada foi a tecla de escape (ESC)
    if key == "escape" then
        -- Encerrando o jogo
        love.event.quit()
    elseif key == "enter" or key == "return" then
        -- Caso o estado esteja em "start" mude para "serve"
        if gameState == "start" then
            gameState = "serve"
        elseif gameState == "serve" then
            gameState = "play"
        elseif gameState == "done" then
            gameState = "serve"
            ball:reset()

            -- Redefine as pontuações para 0
            player1Score = 0
            player2Score = 0

            -- Define o jogador sacador como o oposto de quem ganhou
            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
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

    -- Desenhando a pontuação na tela
    displayScore()

    -- Desenhando um texto na tela
    if gameState == "start" then
        love.graphics.setFont(retroFont)
        love.graphics.printf("Welcome to Pong!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to begin!", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "serve" then
        love.graphics.setFont(retroFont)
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s serve!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to serve!", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "done" then
        love.graphics.setFont(largeFont)
        love.graphics.printf("Player " .. tostring(winningPlayer) .. " wins!", 0, 10, VIRTUAL_WIDTH, "center")
        love.graphics.setFont(retroFont)
        love.graphics.printf("Press Enter to restart!", 0, 30, VIRTUAL_WIDTH, "center")
    end

    -- Renderizando as raquetes
    player1:render()
    player2:render()

    -- Renderizando a bola no centro
    ball:render()

    -- Mostrando o FPS na tela
    displayFPS()

    -- Finalizando a renderização na resolução virtual
    push:apply("end")
end

-- Imprimindo o FPS atual na tela
function displayFPS()
    love.graphics.setFont(retroFont)
    love.graphics.setColor(0, 255 / 255, 0, 255 / 255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end

-- Imprimindo a pontuação na tela
function displayScore()
    -- Desenhando a pontuação no centro da tela
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end
