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
  self.dx = math.random(-50, 50)
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
