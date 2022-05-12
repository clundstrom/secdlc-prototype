const Ajv = require("ajv")
const jwt = require('jsonwebtoken')

function getToken(req) {
  var bearerToken;
  try{
    const bearerHeader = req.headers['authorization'];
    const bearer = bearerHeader.split(' ');
    bearerToken = bearer[1];
  } catch(err){
    return {"err":"No token in Authorization Bearer Header"}
  }
  return {"token":bearerToken}
}

function generateToken(payload){
  var priv = Buffer.from(process.env.PRIV, 'base64').toString('ascii')
  return jwt.sign(payload, priv, { algorithm: 'RS256'})
}

function verifyToken(payload){
  var pub = Buffer.from(process.env.PUB, 'base64').toString('ascii')
  try{
    var body = jwt.verify(payload, pub, { algorithm: 'RS256'})
  } catch(err){
    console.log(new Date(), ": ", err.name, err.message)
    return {"err":true, "result": err.name + " " + err.message}
  }
  return {"err":false, "result":body}
}

function verifySchema(payload, schema, callback) {
  const ajv = new Ajv() // options can be passed, e.g. {allErrors: true}
  const validate = ajv.compile(schema);
  const valid = validate(payload);
  callback(valid, validate.errors)
}
module.exports.verifyToken = verifyToken
module.exports.generateToken = generateToken
module.exports.getToken = getToken
module.exports.verifySchema = verifySchema