function verifyToken(req, res) {
    const bearerHeader = req.headers['authorization'];
  
    if (bearerHeader) {
      const bearer = bearerHeader.split(' ');
      const bearerToken = bearer[1];
      //req.token = bearerToken;
      console.log(bearerToken)
    } else {
      // Forbidden
      res.sendStatus(403);
    }
}

function validateToken(token){
    return "Okay"
}

module.exports.validateToken = validateToken
module.exports.verifyToken = verifyToken