# ---------------------------------------------------------------------------------
# Linell Bonnette - linell@schoolstatus.com
# ---------------------------------------------------------------------------------

# Create the canvas
canvas        = document.createElement('canvas')
ctx           = canvas.getContext("2d")
canvas.width  = 512
canvas.height = 480
document.body.appendChild(canvas)

previous = Date.now()


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

background = new Sprite(0, 0, 512, 480, null, "images/background.png")
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
    hero.y -= hero.speed * modifier
  if ("40" in keys)
    hero.y += hero.speed * modifier
  if ("37" in keys)
    hero.x -= hero.speed * modifier
  if ("39" in keys)
    hero.x += hero.speed * modifier

  if spritesAreColliding(hero, monster)
    monstersCaught += 1
    reset()

# Render
render = ->
  ctx.drawImage(background.image, background.x, background.y)
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
  render()

  previous = now

  requestAnimationFrame(main)

reset()
main()
