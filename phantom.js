var page = require('webpage').create(),
    system = require('system'),
    url = system.args[1];

console.log('Getting webpage: ' + system.args[1]);

page.open(url, function(status){
  console.log(page.content);
  phantom.exit();
});