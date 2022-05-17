
var Sessions = function(){
    var DB = require('./sessionsDB.json')
    const fs = require('fs');

    this.printDB = function(){
        console.log(DB)
    }

    this.addToken = function(token, userdata){
       
        DB[token] = userdata
        console.log("added token")
        console.log(DB)
    }

    this.removeToken = function(token){
        if(DB[token]){
            delete DB[token];
            return "Valid token deleted"
        } else {
            return "Token not in registry"
        }
    }

    this.verifyJwtSession = function(token, userdata){
        
    }

    this.saveDB = function(){
        let data = JSON.stringify(DB, null, 2);
        fs.writeFile('./sessionsDB.json', data, (err) => {
            if (err) throw err;
            console.log('Data written to file');
        });
    }

    this.clearDB = function(){
        let data = JSON.stringify({}, null, 2);
        fs.writeFile('./sessionsDB.json', data, (err) => {
            if (err) throw err;
            console.log('Data written to file');
        });
    }

    return this
}

module.exports.Sessions = Sessions;