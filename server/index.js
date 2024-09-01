//IMPORT FROM PACKAGES
const express = require('express');
const mongoose = require("mongoose");

//IMPORTS FROM OTHER FILES
const authRouter = require("./routes/auth");
const adminRouter = require('./routes/admin');
const productRouter = require("./routes/product");

//INITIALIZATIONS
//we can mention any port number but 3000 is like a convention
const PORT = 3000;
//initializing express
const app = express();
//database connection url from mongoDB
//in the <password> section, enter the password used while creating the database
const DB = "mongodb+srv://abhiuday:Passw0rd@cluster0.ykypq.mongodb.net/?retryWrites=true&w=majority";

//MIDDLEWARES   
//It tells the Express app to use the built-in middleware function express.json(), which parses incoming requests with JSON payloads and makes the data available under the req.body property
//Without this middleware, req.body would be undefined when the request body contains JSON data.
app.use(express.json());
//by doing this, our node.js application now knows about the exsistance of authRouter in auth.js file
app.use(authRouter);
//by doing this, our node.js application now knows about the exsistance of adminRouter in admin.js file
app.use(adminRouter);
//by doing this, our node.js application now knows about the exsistance of productRouter in product.js file
app.use(productRouter);


//CONNECTIONS
//we make this connection after importing mongoose
//we are using then since its a promise, we are not using await since its not inside any function
//to get the url for the connect(), create a database on mongodb.com
mongoose
.connect(DB)
.then(() => {
    console.log("Database Connection Successful");
    //0.0.0.0 IP can be accessed from anywhere, be it localhost or any IP address
    //() => {} is a way of using callback functions, they can also be used like : function(){}
    app.listen(PORT, "0.0.0.0", () => {
        console.log(`Server is running on port ${PORT}`);
    });
})
.catch((e) => {
    console.log("Database Connection unsuccessful"+e);
})


