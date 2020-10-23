Set-Location MyApp\wwwroot\less
 
# Less
lessc site1.less ..\css\site1.css 
lessc site2.less ..\css\site2.css 
lessc siteN.less ..\css\siteN.css 
 
# Uglify CSS - https://www.npmjs.com/package/uglifycss
Set-Location ..\css
uglifycss site1.css site2.css siteN.css --output site.min.css
 
# Uglify JS - https://www.npmjs.com/package/uglify-es
Set-Location ..\js
uglifyjs site1.js site2.js siteN.js -c -o site1.min.js