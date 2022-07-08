import express from "express"
import os from "os"
import fetch from 'node-fetch';

const app = express()
const PORT = 3000

app.get("/", (req,res) => {
    const helloMessage = `Hello from ${os.hostname()}\n`
    console.log(helloMessage)
    res.send(helloMessage)
})


app.get("/nginx", async (req,res) => {
    const url = "http://nginx"
    const response = await fetch(url)
    const body = await response.text();
    res.send(body);
})

app.listen(PORT, ()=> {
    console.log(`Web server listening on port ${PORT}`)
})