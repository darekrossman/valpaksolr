var mongoose = require( 'mongoose' );
var Schema   = mongoose.Schema;

var User = new Schema({
  name        : String,
  fbId        : {type: String, unique: true},
  email       : String,
  defaultGeo  : String,
  joined      : Date
});

mongoose.model( 'User', User );

mongoose.connect( 'mongodb://localhost/vp_users', function(err, res) {
  console.log(arguments)
});