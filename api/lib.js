const Ajv = require("ajv")
const jwt = require('jsonwebtoken')

function getToken(req) {
  const bearerHeader = req.headers['authorization'];
  const bearer = bearerHeader.split(' ');
  const bearerToken = bearer[1];
  return bearerToken;
}

function generateToken(payload){
  var priv = Buffer.from(process.env.PRIV, 'base64').toString('ascii')
  return jwt.sign(payload, priv, { algorithm: 'RS256'})
}

function verifySchema(payload, schema, callback) {
  const ajv = new Ajv() // options can be passed, e.g. {allErrors: true}
  const validate = ajv.compile(schema);
  const valid = validate(payload);
  callback(valid, validate.errors)
}

module.exports.generateToken = generateToken
module.exports.getToken = getToken
module.exports.verifySchema = verifySchema