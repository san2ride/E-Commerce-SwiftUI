const express = require('express')
const app = express()

app.get('/', (req, res) => {
    res.send('ROOT')
})

app.get('/automobile/:suv/year/:year', (req, res) => {
    const suv = req.params.suv
    const year = req.params.year
    res.send(`Your ${year} ${suv} is here!`)
})
/*
app.get('/suv/fourrunner', (req, res) => {
    res.send('4Runners are cool')
})
app.get('/suv/defender', (req, res) => {
    res.send('Defenders are dope!')
})
*/

// start the server
app.listen(8080, () => {
    console.log("Server is running.")
})