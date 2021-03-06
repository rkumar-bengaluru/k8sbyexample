var express = require("express")
var os =  require("os")

const app = express()
const PORT = 3000

app.get("/", (req,res) => {
    const helloMessage = `Version 2 -> Hello from ${os.hostname()}\n`
    console.log(helloMessage)
    res.send(helloMessage)
})

app.listen(PORT, ()=> {
    console.log(`Web server listening on port ${PORT}`)
})