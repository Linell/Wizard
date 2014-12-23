# ---------------------------------------------------------------------------------
# Linell Bonnette - linell@schoolstatus.com
# ---------------------------------------------------------------------------------

# Create the canvas
canvas        = document.createElement('canvas')
ctx           = canvas.getContext("2d")
canvas.width  = 480
canvas.height = 480
document.body.appendChild(canvas)

previous = Date.now()

class Object
  constructor: (width, height, imageSource, permeable) ->
    @width = width
    @height = height
    @permeable = permeable
    @image = new Image()
    @image.src = imageSource


class Sprite
  constructor: (x, y, width, height, speed, imageSource) ->
    @x      = x
    @y      = y
    @width  = width
    @height = height
    @speed  = speed
    @image  = new Image()
    @image.src = imageSource

spritesAreColliding = (spriteOne, spriteTwo) ->
  if spriteOne.x <= (spriteTwo.x + spriteTwo.width) && spriteTwo.x <= (spriteOne.x + spriteOne.width) && spriteOne.y <= (spriteTwo.y + spriteTwo.height) && spriteTwo.y <= (spriteOne.y + spriteOne.height)
    true
  else
    false

floor_tile = new Object(32, 32, "images/brick.png")
hero       = new Sprite(0, 0, 32, 32, 256, "images/hero.png")
monster    = new Sprite(0, 0, 32, 32, 256, "images/monster.png")

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
    if (hero.y - (hero.speed * modifier)) <= 0
      hero.y = canvas.height - hero.y
    else
      hero.y -= hero.speed * modifier
  if ("40" in keys)
    if (hero.y + (hero.speed * modifier)) >= canvas.height
      hero.y = hero.y - canvas.height
    else
      hero.y += hero.speed * modifier
  if ("37" in keys)
    if (hero.x - (hero.speed * modifier)) <= 0
      hero.x = canvas.width - hero.x
    else
      hero.x -= hero.speed * modifier
  if ("39" in keys)
    if (hero.x + (hero.speed * modifier)) >= canvas.width
      hero.x = hero.x - canvas.width
    else
      hero.x += hero.speed * modifier

  if spritesAreColliding(hero, monster)
    monstersCaught += 1
    reset()

renderMap = ->
  map = [
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
    [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  ]
  for i,v in map
    for j,r in i
      if j == 0
        ctx.drawImage(floor_tile.image, v*floor_tile.width, r*floor_tile.height)

# Render
render = ->
  # ctx.drawImage(background.image, background.x, background.y)
  ctx.drawImage(hero.image, hero.x, hero.y)
  ctx.drawImage(monster.image, monster.x, monster.y)

  ctx.fillStyle = "rgb(250, 250, 250)"
  ctx.font = "24px Helvetica"
  ctx.textAlign = "left"
  ctx.textBaseline = "top"
  ctx.fillText("Monsters caught: " + monstersCaught, 32, 32)

main = ->
  now = Date.now()
  delta = now - previous

  update ( delta / 1000 )
  renderMap()
  render()

  previous = now

  requestAnimationFrame(main)

reset()
main()
