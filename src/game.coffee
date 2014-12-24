# Classes                                                                       {{{
# ---------------------------------------------------------------------------------
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
# }}}

# Create the canvas
canvas        = document.createElement('canvas')
ctx           = canvas.getContext("2d")
canvas.width  = 480
canvas.height = 480
document.body.appendChild(canvas)

floor_tile = new Object(32, 32, "images/brick.png", true)
wall_tile  = new Object(32, 32, "images/wall.png", false)
hero       = new Sprite(0, 0, 32, 32, 256, "images/hero.png")
monster    = new Sprite(0, 0, 32, 32, 256, "images/monster.png")

monstersCaught = 0

previous = Date.now()
# Keyboard Input
keysDown = {}

mapKey = [
  floor_tile,
  wall_tile
]
map = [
  [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0],
  [1,0,0,0,0,1,0,0,0,0,0,0,0,0,0],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
  [1,0,0,0,0,1,0,0,0,0,0,0,0,0,0],
  [1,1,1,1,1,1,0,0,0,0,0,0,0,0,0],
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

getTileAtCoordinates = (x,y) ->


spritesAreColliding = (spriteOne, spriteTwo) ->
  if spriteOne.x <= (spriteTwo.x + spriteTwo.width) && spriteTwo.x <= (spriteOne.x + spriteOne.width) && spriteOne.y <= (spriteTwo.y + spriteTwo.height) && spriteTwo.y <= (spriteOne.y + spriteOne.height)
    true
  else
    false


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

mapTileAtCoordinatesIsPermeable = (tileSize, x, y) ->
  mapKey[map[Math.floor(x/tileSize)][Math.floor(y/tileSize)]].permeable

getPositionFromMovement = (modifier, current_position) ->
  keys = (k for k of keysDown)
  position = {x: current_position.x, y: current_position.y}
  if ("38" in keys)
    if (hero.y - (hero.speed * modifier)) <= 0
      position.y = canvas.height - hero.y
    else
      position.y -= hero.speed * modifier
  if ("40" in keys)
    if (hero.y + (hero.speed * modifier)) >= canvas.height
      position.y = hero.y - canvas.height
    else
      position.y += hero.speed * modifier
  if ("37" in keys)
    if (hero.x - (hero.speed * modifier)) <= 0
      position.x = canvas.width - hero.x
    else
      position.x -= hero.speed * modifier
  if ("39" in keys)
    if (hero.x + (hero.speed * modifier)) >= canvas.width
      position.x = hero.x - canvas.width
    else
      position.x += hero.speed * modifier
  position

# Updates game object
update = (modifier) ->
  current_position = {x: hero.x, y: hero.y}
  future_position  = getPositionFromMovement(modifier, current_position)
  if mapTileAtCoordinatesIsPermeable(32, future_position.x, future_position.y)
    hero.x = future_position.x
    hero.y = future_position.y
  else
    hero.x = current_position.x
    hero.y = current_position.y

  if spritesAreColliding(hero, monster)
    monstersCaught += 1
    reset()

renderMap = (map) ->
  for i,v in map
    for j,r in i
      ctx.drawImage(mapKey[j].image, r*mapKey[j].width, v*mapKey[j].height)

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
  renderMap(map)
  render()

  previous = now

  requestAnimationFrame(main)

reset()
main()
