var jwt = require('jwt-simple'),
    secret = 'io.darek.lightspeed';

module.exports = function auth(options) {

  return function(req, res, next){
    if (!req.session.user) {
      res.status(403);
      res.end();
      return
    }
    next();
  }

};