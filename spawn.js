var spawn = require('child_process').spawn;

var processCount = 1
var processes = [];
var completedProcesses = [];

for (var i = 0; i < processCount; i++) {
  console.log('phantomjs started [ '+ i +' ]');
  var ph = spawn('phantomjs', ['phantom.js', 'http://localhost:5000/coupons/query?keywords=pizza&geo=33703'])
  processes.push(ph);

  (function(phantom, index){
    phantom.stdout.setEncoding('utf8');

    phantom.stdout.on('data', function (data) {
      var buff = new Buffer(data);
      console.log('phantomjs started [ '+ index +' ]: ' + buff);
    });

    phantom.stderr.on('data', function (data) {
      data += '';
      console.log(data.replace("\n", "\nstderr: "));
    });

    phantom.on('exit', function (code) {
      completedProcesses.push(index)
      console.log('phantomjs [ '+ index +' ] exited with code ' + code);

      if (completedProcesses.length === processCount) {
        process.exit(code);
      }
    });

  })(ph, i)

}

