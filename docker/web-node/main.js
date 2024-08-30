const express = require('express')
const redis = require('redis');
const uuid = require('uuid');
const app = express();
const redisClient = redis.createClient(6379);

redisClient.on('error', (err) => {
    console.log(err);
});

redisClient.on('connect', () => {
    console.log('Connected!');
});

redisClient.connect();

app.get('/get/:key', async function (req, res) {
    const key = req.params.key;
    const value = await redisClient.get(key);
    res.send(value);
});

app.get('/set/:value', async function (req, res) {
    const key = uuid.v1();
    const value = req.params.value;
    await redisClient.set(key, value);
    res.send(key);
});

app.listen(8080);