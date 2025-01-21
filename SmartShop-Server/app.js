const express = require('express')
const models = require('./models')
const app = express()

// JSON parser
app.use(express.json())

app.post('/register', (req, res) => {
    const { username, password } = req.body

    // create User
    const newUser = models.User.create({
        username: username,
        password: password
    })
    res.status(201).json({success: true})
})

// start the server
app.listen(8080, () => {
    console.log("Server is running.")
})