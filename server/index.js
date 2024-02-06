//IMPORT FROM PACKAGES
//used like import statements
const express = require('express');
const mongoose = require("mongoose");

//IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");

//INITIALIZATIONS
//we can mention any port number but 3000 is like a convention
const PORT = 3000;
//initializing express
const app = express();
//database connection url from mongoDB
//in the <password> section, enter the password used while creating the database
const DB = "mongodb+srv://abhiuday:Passw0rd@cluster0.ykypq.mongodb.net/?retryWrites=true&w=majority";

//MIDDLEWARES   
//it basically passes incoming requests with json payloads
//we are using this since we have used a lot of destructuring which can be only be used on objects
app.use(express.json());
//by doing this, our node.js application now knows about the exsistance of authRouter in auth.js files
app.use(authRouter);


//CONNECTIONS
//we make this connection after importing mongoose
//we are using then since its a promise, we are not using await since its not inside any function
//to get the url for the connect(), create a database on mongodb.com
mongoose
.connect(DB)
.then(() => {
    console.log("Connection Successful");
})
.catch((e) => {
    console.log(e);
})

//0.0.0.0 IP can be accessed from anywhere, be it localhost or any IP address
//() => {} is a way of using callback functions, they can also be used like : function(){}
app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server is running on port ${PORT}`);
});
