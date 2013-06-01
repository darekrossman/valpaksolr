'use strict';

var express = require('express'),
    routes = require('./routes'),
    api = require('./routes/api'),
    http = require('http'),
    path = require('path'),
    stylus = require('stylus'),
    app = express(),
    server;

function compile(str, path) {
  return stylus(str)
    .set('filename', path)
    .set('compress', true)
    .use(require('nib')());
}

app.configure(function(){
  app.set('port', process.env.PORT || 5000);
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser('flavrflav'));
  app.use(express.session());
  app.use(app.router);
  app.use(stylus.middleware({src:__dirname + '/public', compile:compile}));
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);
app.get('/partials/:name', routes.partials);
app.get('/solr/listings', api.getAllListings);
app.get('/solr/listings/:cat', api.getAllListingsInCategory);
app.get('/api/profile/:id', api.getBusinessProfile);


app.get('/search', routes.search);
app.get('/listings/category/:cat', routes.searchCategory);
app.get('/listing/profile/:id', routes.index);

server = http.createServer(app).listen(app.get('port'), function(){
  console.log('Valpak Application is now listening on port ' + app.get('port'));
});


