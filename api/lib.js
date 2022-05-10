const Ajv = require("ajv")

function getToken(req) {
  const bearerHeader = req.headers['authorization'];
  const bearer = bearerHeader.split(' ');
  const bearerToken = bearer[1];
  return bearerToken;
}

function validateToken(token) {
  return "Okay"
}

function verifySchema(payload, schema, callback) {
  const ajv = new Ajv() // options can be passed, e.g. {allErrors: true}
  const validate = ajv.compile(schema);
  const valid = validate(payload);
  callback(valid, validate.errors)
}

module.exports.validateToken = validateToken
module.exports.getToken = getToken
module.exports.verifySchema = verifySchema