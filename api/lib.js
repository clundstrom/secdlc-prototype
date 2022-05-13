const Ajv = require("ajv")
const jwt = require('jsonwebtoken')

function generateToken(payload){
  var priv = Buffer.from(process.env.PRIV, 'base64').toString('ascii')
  return jwt.sign(payload, priv, { algorithm: 'RS256'})
}

function getToken(req, res, callback) {
  var token;
  if(req.cookies && req.cookies.webToken){
    token = req.cookies.webToken
  } else {
    console.log(new Date(), ": No token in cookies")
    return res.status(400).send("No token in HttpOnly webToken cookie")
  }
  callback(token)
}

function verifyToken(payload, res, callback){
  var pub = Buffer.from(process.env.PUB, 'base64').toString('ascii')
  try{
    var result = jwt.verify(payload, pub, { algorithm: 'RS256'})
  } catch(err){
    console.log(new Date(), ": ", err.name, err.message)
    return res.status(401).send(err.name + " " + err.message)
  }
  callback(result)
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