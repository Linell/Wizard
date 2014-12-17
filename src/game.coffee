# ---------------------------------------------------------------------------------
# Linell Bonnette - linell@schoolstatus.com
# ---------------------------------------------------------------------------------

# Create the canvas
canvas        = document.createElement('canvas')
ctx           = canvas.getContext("2d")
canvas.width  = 512
canvas.height = 480
previous = Date.now()

document.body.appendChild(canvas)

# Load Images
bgReady = false
bgImage = new Image()
bgImage.onload = ->
  bgReady = true
bgImage.src = "images/background.png"
heroReady = false
heroImage = new Image()
heroImage.onload = ->
  heroReady = true
heroImage.src = "images/hero.png"
monsterReady = false
monsterImage = new Image()
monsterImage.onload = ->
  monsterReady = true
monsterImage.src = "images/monster.png"

# Game Objects
hero =
  speed: 256 # pixels per second
  x: 0
  y: 0

monster =
  x: 0
  y: 0

monstersCaught = 0

# Keyboard Input
keysDown = {}

addEventListener "keydown", ((e) ->
  keysDown[e.keyCode] = true
  return
), false
addEventListener "keyup", ((e) ->
  delete keysDown[e.keyCode]
  return
), false

# Reset the game
reset = ->
  hero.x = canvas.width / 2
  hero.y = canvas.height / 2

  monster.x = 32 + (Math.random() * (canvas.width - 64))
  monster.y = 32 + (Math.random() * (canvas.height - 64))

# Updates game object
update = (modifier) ->
  keys = (k for k of keysDown)
  if ("38" in keys)
    hero.y -= hero.speed * modifier
  if ("40" in keys)
    hero.y += hero.speed * modifier
  if ("37" in keys)
    hero.x -= hero.speed * modifier
  if ("39" in keys)
    hero.x += hero.speed * modifier

  if hero.x <= (monster.x + 32) && monster.x <= (hero.x + 32) && hero.y <= (monster.y + 32) && monster.y <= (hero.y + 32)
    monstersCaught += 1
    reset()

# Render
render = ->
  if bgReady
    ctx.drawImage(bgImage, 0, 0)

  if heroReady
    ctx.drawImage(heroImage, hero.x, hero.y)

  if monsterReady
    ctx.drawImage(monsterImage, monster.x, monster.y)

  ctx.fillStyle = "rgb(250, 250, 250)"
  ctx.font = "24px Helvetica"
  ctx.textAlign = "left"
  ctx.textBaseline = "top"
  ctx.fillText("Monsters caught: " + monstersCaught, 32, 32)

main = ->
  now = Date.now()
  delta = now - previous

  update ( delta / 1000 )
  render()

  previous = now

  requestAnimationFrame(main)

reset()
main()
