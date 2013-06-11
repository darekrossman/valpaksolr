'use strict';


require('./db');


var express = require('express'),
    routes = require('./routes'),
    api = require('./routes/api'),
    http = require('http'),
    path = require('path'),
    mongoose = require( 'mongoose' ),
    stylus = require('stylus'),
    headless = require('./headless'),
    auth = require('./middleware/auth'),
    app = express(),
    server;

var MongoStore = require('connect-mongo')(express);

function compile(str, path) {
  return stylus(str)
    .set('filename', path)
    .set('compress', true)
    .use(require('nib')());
}

app.configure('development', function(){
  app.use(express.errorHandler());
  app.set('dbUri', 'mongodb://localhost/vp_users')
});

var db = mongoose.connect( app.set('dbUri'), function() {
  console.log('db connected');
});


function mongoStoreConnectionArgs() {
  //var db = db.connections[0].db
  return {
    db: 'vp_users'
    //host: db.serverConfig.host,
    //port: db.serverConfig.port
  };
}

app.configure(function(){
  app.set('port', process.env.PORT || 5000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('my secret goes here'));

  app.use(express.session({
    store: new MongoStore(mongoStoreConnectionArgs())
  }));

  //app.use(express.csrf());

  app.use(function(req, res, next) {
    res.cookie('XSRF-TOKEN', req.session._csrf, {maxage: 300000})
    next();
  });

  app.use(function(req, res, next) {
    if ('_escaped_fragment_' in req.query)
      headless.render(req, res)
    else
      next();
  });



  app.use(app.router);
  app.use(stylus.middleware({src:__dirname + '/public', compile:compile}));
  app.use(express.static(path.join(__dirname, 'public')));

});



app.get('/', function(req, res){
  res.redirect(301, '/coupons/home');
});

app.get('/coupons/*', routes.index);


app.get('/partials/:name', routes.partials);
app.get('/api/listings', api.getAllListings);
app.post('/api/listings/:cat', auth(), api.getAllListingsInCategory);
app.get('/api/profile/:id', api.getBusinessProfile);

app.post('/user/create', routes.createUser);

app.get('/user/:id', routes.getUser);
app.post('/user/:id', auth(), routes.updateUser);

app.get('/search', routes.search);
app.get('/listings/category/:cat', routes.searchCategory);
app.get('/listing/profile/:id', routes.index);

server = http.createServer(app).listen(app.get('port'), function(){
  console.log('Valpak Application is now listening on port ' + app.get('port'));
});


