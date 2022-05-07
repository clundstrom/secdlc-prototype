'use strict';

const express = require('express');
const lib = require('./lib')
const app = new express();


let port =  process.env.PORT | 2022
let host = process.env.HOST | "127.0.0.1"


app.use(express.json())

app.get('/', (req, res) => {
    res.send('Nothing to see here' + lib.validateToken("aa"))
});

app.get('/test', (req, res) => {
    res.cookie("test", "value")
        .send('Hello this is API test');
});

app.post('/testpost', (req, res) => {
    console.log(req.body)
    res.send('Test post')
});

app.post('/login', (req, res) => {
    res.send('You are now logged in');
});

app.post('/logout', (req, res) => {
    res.send('You are now logged out');
});

app.post('/creatUser', (req, res) => {
    res.send("You have created a user");
});

app.get('/getInventory', (req, res) => {
    res.send(require('./sample_db_answer.json'));
});

app.post('/addItem', (req, res) => {
    res.send('You have added an item ' );
});

app.post('/removeItem', (req, res) => {
    res.send('You have removed an item');
});

app.post('/updateitem', (req, res) => {
    res.send('You have updated an item');
});

app.listen(port, host, () => {
    console.log('Server started');
});