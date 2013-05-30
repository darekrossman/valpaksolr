var request = require('request');


// Example
// BPP:       http://vpdev.valpak.com/rshack/rs/bpp?businessProfileId=33216
// Listings:  http://vpdev.valpak.com/rshack/rs/lists/?latitude=27.878991&langitude=-82.758636&keywords=pizza

var vpRestConfig = {
  HOST: 'http://www.valpak.com/rshack/rs',
  BPP: '/bpp/',
  LISTINGS: '/lists/'
};



var yipitOpts = {
  key: 'dWeyfrp8FyBPz2z3'
};


exports.getBusinessProfile = function(req, res) {
  request({
    url: vpRestConfig.HOST + vpRestConfig.BPP,
    qs: {
      businessProfileId: req.params.id
    }
  },
  function(error, response, body) {
    if (!error && response.statusCode == 200) {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.write(body);
      res.end();
    } else {
      res.send(404, 'Could not connect.');
    }
  });
};

exports.getAllListings = function(req, res) {
  request({
    url: vpRestConfig.HOST + vpRestConfig.LISTINGS,
    qs: {
      latitude: '27.878991',   // req.query.latitude
      longitude: '-82.7460',  //req.query.longitude
      radius: 25,
      keywords: req.query.keywords
    }
  },
  function(error, response, body) {
    console.log(response.req.path);
    if (!error && response.statusCode === 200) {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      console.log(body)
      res.write(body);
      res.end();
    } else {
      res.send(404, 'Could not connect.');
    }
  });
};

exports.getAllListingsInCategory = function(req, res) {
  request({
    url: vpRestConfig.HOST + vpRestConfig.LISTINGS,
    qs: {
      latitude: '27.878991',   // req.query.latitude
      longitude: '-82.7460',  //req.query.longitude
      radius: 25,
      keywords: req.params.cat
    }
  },
  function(error, response, body) {
    console.log(response.req.path);
    if (!error && response.statusCode == 200) {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.write(body)
      res.end()
    } else {
      res.send(404, 'Could not connect.')
    }
  });
}

exports.getYipitDeals = function(req, res) {
  request({
    url: 'http://api.yipit.com/v1/'
  },
  function(error, response, body) {
    if (!error && response.statusCode == 200) {
      res.json(body)
    } else {
      res.send(404, 'Could not connect.')
    }
  });
}







