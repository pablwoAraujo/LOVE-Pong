-- Definindo a classe
Ball = Class {}

-- Inicializando a classe
function Ball:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height

  -- Definindo o movimento
  self.dy = math.random(2) == 1 and -100 or 100
  self.dx = math.random(2) == 1 and math.random(-80, -100) or math.random(80, 100)
end

-- Espera uma raquete como argumento e retorna verdadeiro ou falso, dependendo se os
-- objetos se sobrepõem
function Ball:collides(paddle)
  -- primeiro, verifique se a borda esquerda de um deles está mais à direita do
  -- que a borda direita do outro
  if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
    return false
  end

  -- em seguida, verifique se a borda inferior de um deles é mais alta que a borda
  -- superior do outro
  if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
    return false
  end

  -- Se o que foi dito acima não for verdade, eles estão se sobrepondo
  return true
end

-- Coloca a bola no meio da tela, com velocidade inicial aleatória
function Ball:reset()
  self.x = VIRTUAL_WIDTH / 2 - 2
  self.y = VIRTUAL_HEIGHT / 2 - 2
  self.dx = math.random(2) == 1 and 100 or -100
  self.dy = math.random(-50, 50)
end

-- Aplica o movimento (velocidade) a posição
function Ball:update(dt)
  self.x = self.x + self.dx * dt
  self.y = self.y + self.dy * dt
end

-- Renderiza a bola na tela
function Ball:render()
  love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
