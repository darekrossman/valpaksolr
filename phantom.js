var page = require('webpage').create()
var url = "http://darek.io:5000/search/?keywords=pizza"

page.open(url, function(status){
  console.log(page.content);
  phantom.exit();
});