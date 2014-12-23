// Generated by CoffeeScript 1.7.1
(function() {
  var Sprite, background, canvas, ctx, hero, keysDown, main, monster, monstersCaught, previous, render, reset, spritesAreColliding, update,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  canvas = document.createElement('canvas');

  ctx = canvas.getContext("2d");

  canvas.width = 512;

  canvas.height = 480;

  document.body.appendChild(canvas);

  previous = Date.now();

  Sprite = (function() {
    function Sprite(x, y, width, height, speed, imageSource) {
      this.x = x;
      this.y = y;
      this.width = width;
      this.height = height;
      this.speed = speed;
      this.image = new Image();
      this.image.src = imageSource;
    }

    return Sprite;

  })();

  spritesAreColliding = function(spriteOne, spriteTwo) {
    if (spriteOne.x <= (spriteTwo.x + spriteTwo.width) && spriteTwo.x <= (spriteOne.x + spriteOne.width) && spriteOne.y <= (spriteTwo.y + spriteTwo.height) && spriteTwo.y <= (spriteOne.y + spriteOne.height)) {
      return true;
    } else {
      return false;
    }
  };

  background = new Sprite(0, 0, 512, 480, null, "images/background.png");

  hero = new Sprite(0, 0, 32, 32, 256, "images/hero.png");

  monster = new Sprite(0, 0, 32, 32, 256, "images/monster.png");

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
      if ((hero.y - (hero.speed * modifier)) <= 0) {
        hero.y = canvas.height - hero.y;
      } else {
        hero.y -= hero.speed * modifier;
      }
    }
    if ((__indexOf.call(keys, "40") >= 0)) {
      if ((hero.y + (hero.speed * modifier)) >= canvas.height) {
        hero.y = hero.y - canvas.height;
      } else {
        hero.y += hero.speed * modifier;
      }
    }
    if ((__indexOf.call(keys, "37") >= 0)) {
      if ((hero.x - (hero.speed * modifier)) <= 0) {
        hero.x = canvas.width - hero.x;
      } else {
        hero.x -= hero.speed * modifier;
      }
    }
    if ((__indexOf.call(keys, "39") >= 0)) {
      if ((hero.x + (hero.speed * modifier)) >= canvas.width) {
        hero.x = hero.x - canvas.width;
      } else {
        hero.x += hero.speed * modifier;
      }
    }
    if (spritesAreColliding(hero, monster)) {
      monstersCaught += 1;
      return reset();
    }
  };

  render = function() {
    ctx.drawImage(background.image, background.x, background.y);
    ctx.drawImage(hero.image, hero.x, hero.y);
    ctx.drawImage(monster.image, monster.x, monster.y);
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

}).call(this);
