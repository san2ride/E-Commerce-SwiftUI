const express = require('express')
const app = express()

app.get("/", (req, res) => {
    res.send("Hello Jason")
})


// start the server
app.listen(8080, () => {
    console.log("Server is running.")
})