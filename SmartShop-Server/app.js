const express = require( 'express')
const app = express ()
console. log(app)

// start the server
app.listen(8080, () => {
    console.log("Server is running.")
})