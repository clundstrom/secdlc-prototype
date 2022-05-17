const Ajv = require("ajv")
const jwt = require('jsonwebtoken')
const dayjs = require('dayjs');
function generateToken(payload){
  var priv = Buffer.from(process.env.PRIV, 'base64').toString('ascii')
  //return jwt.sign(payload, priv, { algorithm: 'RS256', expiresIn: "1min"})
  return jwt.sign(payload, priv, { algorithm: 'RS256', expiresIn: process.env.TOKEN_DURATION_MIN + "min"})
}

function getToken(req, callback) {
  var token = false;
  if(req.cookies !== undefined && req.cookies.webToken !== undefined){
    token = req.cookies.webToken
  } 
  if(callback){
    callback(token)
  } else {
    return token;
  }
}

function verifyToken(payload, callback){
  var pub = Buffer.from(process.env.PUB, 'base64').toString('ascii')
  var result = false;
  var error;
  try{
    result = jwt.verify(payload, pub, { algorithm: 'RS256'})
  } catch(err){
    error = err.name
    console.log(new Date(), ": ", err.name, err.message)
  }
  if(callback){
    callback(result, error)
  } else {
    return {"result": result, "err": error};
  }
}

function verificationSteps(req, schema, sessions){
  var {result, err} = verifySchema(req.body,schema)
  if(!result){
      console.log(new Date(), ": ", JSON.stringify(err));
      return {"result": false, "code": 400,"err": "Invalid post parameters"}
  }
  var token = getToken(req);
  if(!token){
    return {"result": false, "code": 401, "err": "You are not logged in"}
  }
  var {result, error} = verifyToken(token);
  if(!result){
    return {"result": false, "code": 401, "err": error}
  }
  //If token is legit but is not in registry, add it
  var isTokenIn = sessions.isTokenInRegistry(token)
  if(!isTokenIn){
    sessions.addToken(token, result)
  }
  return {"result": result, "code": 200, "err": ""}
}

function verifySchema(payload, schema, callback) {
  const ajv = new Ajv() // options can be passed, e.g. {allErrors: true}
  const validate = ajv.compile(schema);
  const valid = validate(payload);
  if(callback){
    callback(result, validate.errors)
  } else {
    return {"result": valid, "err": validate.errors};
  }
}
module.exports.verifyToken = verifyToken
module.exports.generateToken = generateToken
module.exports.getToken = getToken
module.exports.verifySchema = verifySchema
module.exports.verificationSteps = verificationSteps;