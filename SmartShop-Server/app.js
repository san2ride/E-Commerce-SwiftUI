const express = require('express')
const app = express()
const automobiles = [{brand: "Porsche", style: "sports car"}, {brand: "Defender", style: "suv"}]

app.get('/', (req, res) => {
    res.send('ROOT')
})

app.get('/hello', (req, res) => {
    res.json({ message: 'Hello Jason'})
})

app.get('/automobile', (req, res) => {
    res.json(automobile)
})

app-post('/automobile', (req, res) => {
    const { brand, style } = req.body
    res.send ('OK')
})

app.get('/automobile/:suv/year/:year', (req, res) => {
    const suv = req.params.suv
    const year = req.params.year
    res.send(`Your ${year} ${suv} is here!`)
})

app.get('/automobile/:style', (req, res) => {
    const style = req.params.style
    res.json(automobiles.filter(automobile => automobile.style.toLowerCase() == style.toLowerCase()))
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