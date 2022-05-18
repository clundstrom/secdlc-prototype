const dayjs = require('dayjs');

var Sessions = function(){
    var DB = require('./sessionsDB.json')
    const jwt = require('jsonwebtoken')
    const fs = require('fs');

    this.printDB = function(){
        console.log(DB)
    }

    this.addToken = function(token, userdata){   
        DB[token] = userdata
    }

    this.removeToken = function(token){
        if(DB[token]){
            delete DB[token];
            return "Valid token deleted"
        } else {
            return "Token not in registry"
        }
    }

    this.clearExpired = function(){
        const keys = Object.keys(DB);
        keys.forEach((key, index) => {
            let res = jwt.decode(key)
            let now = new Date().getTime()/1000
            if(res.exp < now){
                delete DB[key]
            }
        });
        console.log(new Date(), ": Cleared expired tokens")
    }

    this.isTokenInRegistry = function(token){
        if(DB[token]){
            return true
        }
        else {
            return false
        }
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