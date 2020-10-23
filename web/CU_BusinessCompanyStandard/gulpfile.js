/// <reference path="js/insymacontentlists.js" />
// include plug-ins
var gulp = require('gulp');
var less = require('gulp-less');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var del = require('del');

var config = {
    //Include all js files needed
    src: ["./js/lib/modernizr.min.js",
        // "./js/jquery-2.1.3.min.js",
        "./js/jquery-3.5.1.min.js",
        "./js/lib/jquery.cookie.js",
        "./js/lib/jquery.flexslider-min.js",
        "./js/lib/jquery-polyglot.language.switcher.min.js",
        "./js/lib/jquery.tinysort.min.js",
        "./js/lib/jquery.touchSwipe.min.js",
        "./js/lib/jquery-ui-custom.min.js",
        "./js/lib/fancybox/jquery.fancybox.min.js",
//        "./js/lib/slick.js",
//        "./js/lib/parallax.min.js",
        "./js/lib/uniform.min.js",
        "./js/shuffle.js",
        // SHARIFF - Link abfüllen in CU: Objekt "Link für Infos" unter Seiteneinstellungen > DSVGO
        "./js/insymaFormValidation.js",
        "./js/social.js",
        "./js/youtube.js",
        //"./js/insymaOverlaybox.js",
        "./js/insymaDataprivacy.js",
        "./js/insymafancyScripts.js",
        "./js/map.js",
        "./js/insymaContentlists.js",
        "./js/project_scripts.js"]
  //      "./js/common-validation.1.1.0.js"
};



//delete the output file(s)
gulp.task('clean', function () {
    return del(['js/main.min.js']);
});
gulp.task('cleanDebug', function () {
    return del(['js/debug.min.js']);
});

//minify 
gulp.task('main', function () {
    return gulp.src(config.src)
        .pipe(uglify())
        .pipe(concat('main.min.js'))
        .pipe(gulp.dest('js/'));
});

//debugging
gulp.task('debug', function () {
    return gulp.src(config.src)
        .pipe(concat('main.js'))
        .pipe(gulp.dest('js/'));
});

// less

gulp.task('less', function(cb) {
	gulp
	  .src('*.less')
	  .pipe(less())
	  .pipe(
		gulp.dest(function(f) {
		  return f.base;
		})
	  );
	cb();
  });
  
  gulp.task(
	'default',
	gulp.series('less', function(cb) {
	  gulp.watch('*.less', gulp.series('less'));
	  cb();
	})
  );