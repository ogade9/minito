/*This imports express.js library
Express is a toolkit for building web servers and APIs
*/
const express = require("express")
// app is the backend server
const mongoose = require("mongoose")
const app = express()
/* What are ports and why do I need them?
It is a way for applications to communicate on a machine
So my computer talks to port 5000 which talks to express server
*/
const userSchema = new mongoose.Schema({
    userId: String,
    fullName: String,
    email: String,
    userName: String,

})
require('dotenv').config();
const mongoURI = process.env.MONGO_URI
const port = process.env.PORT || 5000
const userConnection = mongoose.createConnection(mongoURI)
const user = mongoose.model('User', userSchema)
userConnection.on('connected', () =>{
    console.log("User Database Connected!!!")
})
userConnection.on('error', (err) =>{
    console.log("Error connecting to the users database", err)
})
    //.then(() => console.log("Successfully connected to mongo database for trips"))
    //.catch((err) => console.error("Connection error for trips", err)
//)
/*
What are cors?
CORS: Cross-Origin Resource Sharing
Browsers block this for security reasons but cors is what lets the browser know
that it is okay for my frontend and backend to communicate
Note: My backend port is 5000
My frontend port is 5173
*/
const cors = require("cors")
/*
Middleware
This runs before routes execute.
It is like a pipeline.
*/
app.use(express.urlencoded({extended: true}))
app.use(express.json()) // It allows backend to understand json data that I sent from my frontend
app.use(cors())// It enables all cors requests for all routes

//Creating a route
app.get("/", cors(), async(req,res) => {
    /*
        req and res are core backend objects
        req contains information about the request
        For example, headers, body, params, query strings
        res: This is used to send a response back
    */
    res.json(
        {
        message: "Server connected"
        }
    )
    // I used res here to send data back because an hypothetical "request" was
    //made
})
app.get("/api/robot-users", cors(), async(req,res) => {

    res.json(
        {
        message: "Post user connected"
        }
    )
})
app.get("/api/user/signin", cors(), async(req,res) => {
   
    res.json(
        {
        message: "user sign-in connected"
        }
    )
    
})
app.post("/api/robot-users", cors(), async(req,res) => {
   try{
    const newUser = user(req.body)
    console.log("before save")
    await newUser.save()
    console.log("After save")
    console.log(newUser)
    res.status(201).send("Added another user succesfully")
   }catch(error){
    res.status(400).send(error.message);
   }

    
})
app.post("/api/user/signin", cors(), async(req,res) => {
   try{
    const newUser = user(req.body)
    await newUser.save()
    console.log(newUser)
    res.status(201).send("Added user sign in details succesfully")
   }catch(error){
    res.status(400).send(error.message);
   }

    
})
    

//This starts the server and a callback function that lets me know if it was successful
app.listen(port, () => {
    console.log(`Listening at http://localhost:${port}`)
})