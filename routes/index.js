var mongoose = require( 'mongoose' );
var User     = mongoose.model( 'User' );

var childProcess = require('child_process'),
    ph;




 exports.index = function(req, res){
  res.render('index');
};

exports.search = function (req, res) {

    if (req._parsedUrl.path.indexOf('escaped_fragment') > -1) {
        ph = childProcess.exec('phantomjs phantom.js', function (error, stdout, stdin) {
            if (error) {
                console.log(error.stack);
                console.log('Error code: ' + error.code);
                console.log('Signal received: ' + error.signal);
            }

            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.write(stdout);
            res.end()
        });

        ph.on('exit', function (code) {


        });

    } else {
        res.render('index', {searchKeyword: req.query.q});
    }
};

exports.searchCategory = function (req, res) {
    res.render('index', {searchKeyword: req.params.cat});
};

exports.partials = function (req, res) {
  var name = req.params.name;
  res.render('partials/' + name);
};



exports.createUser = function ( req, res ){
  var newUser = req.body;
  newUser.joined = Date.now();

  new User(newUser).save( function( err, user, count ){
      res.json(user)
    });
};

exports.getUser = function ( req, res ){
  User.findOne( {name: "Darek Rossman"}, function ( err, user, count ){
    res.json(user);
  });
};

exports.updateUser = function ( req, res ){
  var query = {fbId: req.params.id}
  User.findOneAndUpdate(query, req.body, function( err, user ){
    if (!user) {
      console.log('Could not find user with fbId "'+ req.params.id +'"')
      res.json(user)
    } else {
      res.json(user);
    }
  });
};