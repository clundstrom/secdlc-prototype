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
console.log(DB_USER, DB_HOST, DB_PASS)
const pool = mariadb.createPool({ host: DB_HOST, user: DB_USER, password: DB_PASS, database: "authio", connectionLimit: 5 });

app.use(express.json())

app.get('/', (req, res) => {
    res.send('Nothing to see here ')
});

app.post('/login', (req, res) => {
    const { username, password } = req.body
    const hash =
        lib.verifySchema(req.body, SCHEMAS.loginSchema, (result, errors) => {
            if (result) {
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
                                        let token = lib.generateToken({ user: username, access: access })
                                        console.log("Generated token: ", token)
                                        res.status(200).cookie("webToken", token).send("Login successful")
                                    } else {
                                        res.status(401).send("Invalid credentials")
                                    }
                                })
                                conn.end();
                            })
                    }).catch(err => {
                        //not connected
                        res.status(401).send(err)
                    });
            } else {
                console.log(new Date(), ": ", JSON.stringify(errors));
                res.status(400).send("Invalid post parameters");
            }
        });
});

app.post('/logout', (req, res) => {
    res.status(200).send('You are now logged out');
});

app.post('/createUser', (req, res) => {
    res.status(201).send("You have created a user");
});

app.get('/getInventory', (req, res) => {
    lib.getToken(req, res, (token) => {
        lib.verifyToken(token, res, (result) => {
            pool.getConnection()
            .then(conn => {
                let access = result.access;
                let query = `SELECT name, quantity, type, description FROM inventory WHERE type IN (${access})`
                if(access === "0"){
                    query = `SELECT name, quantity, type, description FROM inventory`
                }
                conn.query(query)
                    .then((rows) => {
                        res.status(200).json(rows).send()
                        conn.end();
                    })
            }).catch(error => {
                //not connected
                res.status(401).send(error)
        })
    })});
});

app.post('/addItem', (req, res) => {
    lib.verifySchema(req.body, SCHEMAS.addItemSchema, (result, errors) => {
        if (!result) {
            console.log(new Date(), ": ", JSON.stringify(errors));
            return res.status(400).send("Invalid post parameters");
        }
        lib.getToken(req, res, (token) => {
            lib.verifyToken(token, res, (result) => {
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
                        res.status(401).send("Invalid access level")
                    }   
                }).catch(error => {
                    //not connected
                    res.status(401).send(error)
                })
        })});  
    });
});

app.post('/removeItem', (req, res) => {
    lib.verifySchema(req.body, SCHEMAS.removeItemSchema, (result, errors) => {
        if (!result) {
            console.log(new Date(), ": ", JSON.stringify(errors));
            return res.status(400).send("Invalid post parameters");
        }
        lib.getToken(req, res, (token) => {
            lib.verifyToken(token, res, (result) => {
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
                        res.status(401).send("Invalid access level")
                    }   
                }).catch(error => {
                    //not connected
                    res.status(401).send(error)
                })
        })});  
    });
});

app.post('/updateitem', (req, res) => {
    lib.verifySchema(req.body, SCHEMAS.updateItemSchema, (result, errors) => {
        if (result) {
            res.status(200).send("Update succesful")
        } else {
            console.log(new Date(), ": ", JSON.stringify(errors));
            res.status(400).send("Invalid post parameters");
        }
    });
});

app.listen(port, host, () => {
    console.log('Server started');
});