var express = require("express")
var os =  require("os")

const app = express()
const PORT = 3000

app.get("/", (req,res) => {
    const helloMessage = `Hello from ${os.hostname()}`
    console.log(helloMessage)
    res.send(helloMessage)
})

app.listen(PORT, ()=> {
    console.log(`Web server listening on port ${PORT}`)
})