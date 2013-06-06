var childProcess = require('child_process'),
    ph;

function renderPage(req, res) {
  ph = childProcess.exec('phantomjs phantom.js' + ' ' + req.url, function (error, stdout, stdin) {
    if (error) {
      console.log(error.stack);
      console.log('Error code: ' + error.code);
      console.log('Signal received: ' + error.signal);
    }

    res.writeHead(200, { 'Content-Type': 'text/html' });
    res.write(stdout);
    res.end()
  });
}

exports.render = renderPage