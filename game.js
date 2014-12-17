var bgImage, bgReady, canvas, ctx, hero, heroImage, heroReady, keysDown, main, monster, monsterImage, monsterReady, monstersCaught, previous, render, reset, update,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

canvas = document.createElement('canvas');

ctx = canvas.getContext("2d");

canvas.width = 512;

canvas.height = 480;

previous = Date.now();

document.body.appendChild(canvas);

bgReady = false;

bgImage = new Image();

bgImage.onload = function() {
  return bgReady = true;
};

bgImage.src = "images/background.png";

heroReady = false;

heroImage = new Image();

heroImage.onload = function() {
  return heroReady = true;
};

heroImage.src = "images/hero.png";

monsterReady = false;

monsterImage = new Image();

monsterImage.onload = function() {
  return monsterReady = true;
};

monsterImage.src = "images/monster.png";

hero = {
  speed: 256,
  x: 0,
  y: 0
};

monster = {
  x: 0,
  y: 0
};

monstersCaught = 0;

keysDown = {};

addEventListener("keydown", (function(e) {
  keysDown[e.keyCode] = true;
}), false);

addEventListener("keyup", (function(e) {
  delete keysDown[e.keyCode];
}), false);

reset = function() {
  hero.x = canvas.width / 2;
  hero.y = canvas.height / 2;
  monster.x = 32 + (Math.random() * (canvas.width - 64));
  return monster.y = 32 + (Math.random() * (canvas.height - 64));
};

update = function(modifier) {
  var k, keys;
  keys = (function() {
    var _results;
    _results = [];
    for (k in keysDown) {
      _results.push(k);
    }
    return _results;
  })();
  if ((__indexOf.call(keys, "38") >= 0)) {
    hero.y -= hero.speed * modifier;
  }
  if ((__indexOf.call(keys, "40") >= 0)) {
    hero.y += hero.speed * modifier;
  }
  if ((__indexOf.call(keys, "37") >= 0)) {
    hero.x -= hero.speed * modifier;
  }
  if ((__indexOf.call(keys, "39") >= 0)) {
    hero.x += hero.speed * modifier;
  }
  if (hero.x <= (monster.x + 32) && monster.x <= (hero.x + 32) && hero.y <= (monster.y + 32) && monster.y <= (hero.y + 32)) {
    monstersCaught += 1;
    return reset();
  }
};

render = function() {
  if (bgReady) {
    ctx.drawImage(bgImage, 0, 0);
  }
  if (heroReady) {
    ctx.drawImage(heroImage, hero.x, hero.y);
  }
  if (monsterReady) {
    ctx.drawImage(monsterImage, monster.x, monster.y);
  }
  ctx.fillStyle = "rgb(250, 250, 250)";
  ctx.font = "24px Helvetica";
  ctx.textAlign = "left";
  ctx.textBaseline = "top";
  return ctx.fillText("Monsters caught: " + monstersCaught, 32, 32);
};

main = function() {
  var delta, now;
  now = Date.now();
  delta = now - previous;
  update(delta / 1000);
  render();
  previous = now;
  return requestAnimationFrame(main);
};

reset();

main();
