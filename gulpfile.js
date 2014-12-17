var gulp   = require('gulp');
var concat = require('gulp-concat');
var gutil  = require('gulp-util');
var coffee = require('gulp-coffee');

var coffeeWatcher = gulp.watch('src/**/*.coffee', ['compile-coffee'])

gulp.task('default', function() {
  // place code for your default task here.
});

gulp.task('compile-coffee', function() {
  gulp.src('./src/*.coffee')
      .pipe(coffee({bare: true}).on('error', gutil.log))
      .pipe(concat('game.js'))
      .pipe(gulp.dest('.'))
});
