var mongoose = require( 'mongoose' );
var Schema   = mongoose.Schema;

var User = new Schema({
  name        : String,
  password    : String,
  email       : {type: String, unique: true},
  defaultGeo  : String,
  joined      : Date
});

mongoose.model( 'User', User );

