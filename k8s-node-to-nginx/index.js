var express = require("express")
var os =  require("os")
var fetch = require("node-fetch")

const app = express()
const PORT = 3000

app.get("/", (req,res) => {
    const helloMessage = `Version 2 -> Hello from ${os.hostname()}\n`
    console.log(helloMessage)
    res.send(helloMessage)
})

app.get("/nginx", async (req,res) => {
    const url = "http://localhost:8080"
    const response = await fetch(url)
    const body = await response.text();
    res.send(body);
})

app.listen(PORT, ()=> {
    console.log(`Web server listening on port ${PORT}`)
})