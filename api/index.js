'use strict';

const express = require('express');
const lib = require('./lib')
const app = new express();
const SCHEMAS = require('./schemas')

let port =  process.env.PORT | 2022
let host = process.env.HOST | "127.0.0.1"


app.use(express.json())

app.get('/', (req, res) => {
    res.send('Nothing to see here ')
});

app.post('/login', (req, res) => {
    lib.verifySchema(req.body, SCHEMAS.loginSchema, (result, errors) => {
        if(result){
            if(req.body.username === process.env.ADMIN_USER && req.body.password === process.env.ADMIN_PASS){
                res.status(200).cookie("webToken", process.env.ROOT).send("Login successful!")
            } else {
                res.status(401).send('Invalid credentials')
            }
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
    res.status(200).send(require('./sample_db_answer.json'));
});

app.post('/addItem', (req, res) => {
    lib.verifySchema(req.body, SCHEMAS.addItemSchema, (result, errors) => {
        if(result){
            res.status(201).send("Item added successfuly succesful")
        } else {
            console.log(new Date(), ": ", JSON.stringify(errors));
            res.status(400).send("Invalid post parameters");
        }
    });
});

app.post('/removeItem', (req, res) => {
    lib.verifySchema(req.body, SCHEMAS.removeItemSchema, (result, errors) => {
        if(result){
            res.status(200).send("Removal succesful")
        } else {
            console.log(new Date(), ": ", JSON.stringify(errors));
            res.status(400).send("Invalid post parameters");
        }
    });
});

app.post('/updateitem', (req, res) => {
    lib.verifySchema(req.body, SCHEMAS.updateItemSchema, (result, errors) => {
        if(result){
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