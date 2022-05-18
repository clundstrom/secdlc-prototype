const cookie_parser = require('cookie-parser')
var setPossibleRequests = (req, res, next) => {
    // NOTE: Exclude TRACE and TRACK methods to avoid XST attacks.
    const allowedMethods = [
      "OPTIONS",
      "HEAD",
      "CONNECT",
      "GET",
      "POST",
      "PUT",
      "DELETE",
      "PATCH",
    ];
  
    if (!allowedMethods.includes(req.method)) {
      res.status(405).send(`${req.method} not allowed.`);
    }

    next();
};

var setCorsHeader = (req, res, next) => {
    // NOTE: Exclude TRACE and TRACK methods to avoid XST attacks.
    res.setHeader('Access-Control-Allow-Origin', 'http://localhost:4200');
    
    next();
};

function run(app, express){
    app.use(cookie_parser())
    app.use(setPossibleRequests)
    app.use(setCorsHeader)
    app.use(express.json())
}


module.exports.run = run;