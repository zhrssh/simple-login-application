const express = require('express')
const app = express()

const PORT = 3000

app.use(express.json())

// Dummy database
users = [{ user: 'zherish', pass: '1234' }]

// Routes
app.get('/', (req, res) => {
    res.send("Hello there!")
})

app.post('/', (req, res) => {
    console.log(req.body)

    var isAuthorized = false;
    if ((users[0].user == req.body.user && users[0].pass == req.body.pass) == true)
        isAuthorized = true;
    else
        isAuthorized = false;


    if (isAuthorized == true)
        res.status(200).send("Login Successful")
    else
        res.status(401).send("Incorrect credentials")
})

app.listen(PORT, () => console.log(`Listening to port ${PORT}`))