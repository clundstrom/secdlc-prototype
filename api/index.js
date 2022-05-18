'use strict';

const express = require('express');
const lib = require('./lib')
const bcrypt = require('bcrypt')
const mariadb = require('mariadb')
const app = new express();
const SCHEMAS = require('./schemas');
const { verify } = require('jsonwebtoken');
const port = process.env.PORT || 2022
const host = process.env.HOST || "127.0.0.1"
const DB_USER = process.env.DB_USER || "authio_service_account"
const DB_HOST = process.env.DB_HOST || "127.0.0.1"
const DB_PASS = process.env.DB_PASS || "<your_mysql_password>"
const mw = require('./middleware.js');
const dayjs = require('dayjs');
const pool = mariadb.createPool({ host: DB_HOST, user: DB_USER, password: DB_PASS, database: "authio", connectionLimit: 5 });
const Sessions = require('./sessions.js').Sessions()

mw.run(app, express)

app.get('/', (req, res) => {
    res.send('Nothing to see here ')
});

app.post('/login', (req, res) => {
    const { username, password } = req.body

    var {result, err} = lib.verifySchema(req.body, SCHEMAS.loginSchema)
    if(!result){
        console.log(new Date(), ": ", JSON.stringify(err));
        return res.status(400).send("Invalid post parameters");
    }
    pool.getConnection()
    .then(conn => {
        conn.query(`SELECT hash, access FROM users WHERE name = ?`, [username])
            .then((rows) => {
                if (rows.length !== 1) {
                    res.status(401).send("Invalid credentials")
                    conn.end();
                    return
                }
                let hash = rows[0].hash
                let access = rows[0].access
                bcrypt.compare(password, hash, (error, result) => {
                    if (result) {
                        var old_token = lib.getToken(req);
                        if(old_token){
                            Sessions.removeToken(old_token)
                        }
                        let token = lib.generateToken({ user: username, access: access })
                        console.log("Generated token: ", token)
                        res.setHeader('Access-Control-Allow-Origin', 'http://localhost:4200');
                        res.cookie("webToken", token, {
                            secure: false,
                            httpOnly: true,
                            expires: dayjs().add(process.env.TOKEN_DURATION_MIN, "minutes").toDate(),
                            }).status(200).json({"data": token})
                        Sessions.addToken(token, { user: username, access: access })

                    } else {
                        res.status(403).send("Invalid credentials")
                    }
                })
                conn.end();
            })
    }).catch(err => {
        //not connected
        res.status(401).send(err)
    });
});

app.post('/logout', (req, res) => {
    var token = lib.getToken(req);
    if(!token){
        return res.status(400).send("You are not logged in")
    }
    let msg = Sessions.removeToken(token)
    res.cookie("webToken", "", {
        secure: false,
        httpOnly: true,
        expires: dayjs().add(-5, "minutes").toDate(),
      }).status(200).send(msg)
    //res.status(200).send(msg)
});

app.post('/createUser', (req, res) => {
    res.status(201).send("You have created a user");
});

app.get('/getInventory', (req, res) => {
    var token = lib.getToken(req);
    if(!token){
        return res.status(400).send("You are not logged in")
    }
    var {result, err} = lib.verifyToken(token);
    if(!result){
        return res.status(401).send(err)
    }
    var isTokenIn = Sessions.isTokenInRegistry(token)
    if(!isTokenIn){
        return res.status(401).send("Your token is invalid/expired")
    }
    pool.getConnection()
        .then(conn => {
            let access = result.access;
            let query = `SELECT name, quantity, type, description FROM inventory WHERE type IN (${access})`
            if(access === "0"){
                query = `SELECT name, quantity, type, description FROM inventory`
            }
            conn.query(query)
                .then((rows) => {
                    res.status(200).json(rows);
                    conn.end();
                })
        }).catch(error => {
            //not connected
            res.status(401).send(error)
        })
});

app.post('/addItem', (req, res) => {
    var {result, code, err} = lib.verificationSteps(req, SCHEMAS.addItemSchema, Sessions)
    console.log(result, code, err)
    if(!result){
        return res.status(code).send(err)
    }

    pool.getConnection()
        .then(conn => {
            let access = result.access;
            if(access === "0"){
                var body = req.body;
                let query = "INSERT INTO inventory (name, quantity, type, description) value (?, ?, ?, ?)"
                body.description = body.description || "";
                conn.query(query, [body.name, body.quantity, body.type, body.description])
                .then((query_result) => {
                    res.status(201).send("Item added successfuly succesful")
                    conn.end();
                }).catch(error => {
                    if(error.code === 'ER_DUP_ENTRY'){
                        res.status(400).send("Item already exists")
                    } else {
                        res.status(500).send()
                    }  
                })
            } else {
                res.status(403).send("Invalid access level")
            }   
        }).catch(error => {
            //not connected
            res.status(401).send(error)
        })
});

app.post('/removeItem', (req, res) => {
    var {result, code, err} = lib.verificationSteps(req, SCHEMAS.removeItemSchema, Sessions)
    if(!result){
        return res.status(code).send(err)
    }

    pool.getConnection()
    .then(conn => {
        let access = result.access;
        if(access === "0"){
            var body = req.body;
            let query = "DELETE FROM inventory WHERE name = ?"
            conn.query(query, [body.name])
            .then((query_result) => {
                if(query_result.affectedRows === 0){
                    res.status(200).send("No item removed/No item by that name")
                } else {
                    res.status(200).send("Removed item successfully")
                }
                conn.end();
            }).catch(error => {
                res.status(500).send()
            })
        } else {
            res.status(403).send("Invalid access level")
        }   
    }).catch(error => {
        //not connected
        res.status(401).send(error)
    })
});

app.post('/updateitem', (req, res) => {
    var {result, code, err} = lib.verificationSteps(req, SCHEMAS.updateItemSchema, Sessions)
    if(!result){
        return res.status(code).send(err)
    }
    pool.getConnection()
        .then(conn => {
            let access = result.access;
            if(access === "0"){
                var body = req.body;
                let query = `UPDATE inventory
                                SET name = ?, quantity = ?
                                WHERE name = ?`;
                conn.query(query, [body.new_name, body.new_quantity, body.name])
                .then((query_result) => {
                    if(query_result.affectedRows === 0){
                        res.status(200).send("No item updated/No item by that name")
                    } else {
                        res.status(200).send("Updated item successfully")
                    }
                    conn.end();
                }).catch(error => {
                    if(error.code === "ER_DUP_ENTRY"){
                        res.status(401).send("Can't change name of item to an already existing one")
                    } else {
                        res.status(500).send(error)
                    }
                })
            } else {
                res.status(401).send("Invalid access level")
            }   
        }).catch(error => {
            //not connected
            res.status(401).send(error)
        })
});
function clearOld(sessions){
    Sessions.clearExpired()
    setTimeout(clearOld, 60*60*3*1000, sessions)
}
app.listen(port, host, () => {
    console.log('Server started');
    setTimeout(clearOld, 60*60*3*1000, Sessions)
});