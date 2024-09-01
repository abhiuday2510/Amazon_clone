const express = require("express");
//import user model
const User = require("../models/user");
//import for encryption
const bcryptjs = require("bcryptjs");
//import for signin authentication
const jwt = require("jsonwebtoken");
//import auth middleawre
const auth = require("../middlewares/auth");

//we will use this router instead of the app instance of express like in index.js since its a better practice
const authRouter = express.Router();

//SIGN UP
//we are sending a post request to register user into the database
//callback function declared async since promises are being used inside a function
authRouter.post('/api/signup', async (req,res) => {
    try{
    //get the data from the client
    //in req.body we store the properties whose request we are going to make
    //these properties will come from client side
    const {name, email, password} = req.body;

    //to do all the verifications of password length or unique email etc etc, we make use of user models
    //findOne() is a promise in mongoose used to find pre-exsistance of any entity in the database 
    const exsistingUser = await User.findOne({email});
    if(exsistingUser){
        //normally if everything goes right the status code for that http call will be 200(meaning OK)
        //the list of status codes and their meaning can be found on https://developer.mozilla.org/en-US/docs/Web/HTTP/Status#successful_responses
        //here even is the user already exists the status code will be 200 since the block is being exicuted and thats why we need to change the status code
        return res.status(400).json({msg: "User with same email ID already exists"});
    }

    //checking if the length of password is more than 6 cause after hashing , its anyways going to be more than 6, hence not validating in user model
    if(password.length<7){
        return res.status(400).json({msg : "Please enter a password with 7 or more characters"});
    }

    //here we are encrypting the password
    //in tghe hash function we provide the string we want to hash("password") and the salt (8)
    //A cryptographic salt is made up of random bits added to each password instance before its hashing.
    //Salts create unique passwords even in the instance of two users choosing the same passwords
    //Salts get added to our original password during hashing so that we dont need to store it seperatly
    const hashedPassword = await bcryptjs.hash(password, 8);

    //creating the user model
    //let is used insted of const since its values are going to change
    let user =new User({
        email,
        //since in our user model its not mentioned hashedPassword, so we cannot destrucutre
        password : hashedPassword,
        name,
    });

    //post that data into the database
    //to post data into the database, we need to make connections to our database and for that we need to import mongoose into index.js
    user = await user.save();

    //return that data to the user for success message 
    return res.json(user);
    }
    catch (e){
        return res.status(500).json({ error : e.message });
    }

})


//SIGN IN 
authRouter.post('/api/signin', async (req,res) => {
    try{
        const {email, password} = req.body;

        //finding the user using findOne(), checking if this user even exists with this given email
        const user = await User.findOne({email});
        if(!user) {
            return res.status(400).json({msg: "User with this email does not exists!"});
        }

        //now we have established that the user exists
        //we need to compare the entered password with the password in the database
        //we will be making use of bcrypt.js again since the stored database password is a hashed one
        const isMatch = await bcryptjs.compare(password, user.password);
        if(!isMatch){
            return res.status(400).json({msg: "Incorrect Password!"});
        }

        //now making use of jsonwebtoken to sign in the user
        //sign() : Synchronously sign the given payload into a JSON Web Token string payload
        //we need to provide an id and a secret key which is used to verify our request later on (if our jwt is correct or not)
        const token = jwt.sign({ id: user._id }, "passwordKey");

        //we need to send the above token which is gonna reside in the app's memory 
        //also we need to send the user data which we will store in the provider state management since we need that data everywhere in our app
        //res.json({token, ...user._doc}) will add token in our user json response body so we do not need a seperate storage for accessing it
        //we are using ._doc so that if user is locked in the terminal , it should not give us a big json file which is of no use to us
        res.json({token, ...user._doc})

    }
    catch(e){
        return res.status(500).json({error: e.message });
    }
})

//CHECK THE VALIDITY OF THE TOKEN (TO SIGN IN)
authRouter.post('/tokenIsValid', async (req, res) => {
    try{
        //req.header() contains key-value pairs representing the headers sent by the client in the HTTP request.
        const token = req.header("x-auth-token");

        //if the token is null or no token is passed, then we simply return false
        if(!token)
            return res.json(false);

        //if the token is there, we need to verify it using jwt.verify(), with token and secret key(passed during signing in) as parameters
        const verified = jwt.verify(token , "passwordKey");

        //now we check if the token is verified or not
        if(!verified)
            res.json(false);

        //now if the token exists and verified, we need to check if the user with the same token is available or not, meaning if the token should not be a random token
        //we are using findById(), since we have signed in using the ID of the user
        const user = await User.findById(verified.id);
        if(!user)
            return res.json(false);

        //if all the above condition passes, then we return true
        return res.json(true);

    }catch(e){
        return res.status(500).json({error: e.message });
    }
})

//GET USER DATA
//we need to have auth middleware here
//this middleware tells that we are authorized and we have the capability to get the user data if we are signed in
authRouter.get('/', auth, async (req, res) => {
    //we can directly write req.user due to auth middleware, same goes with req.token 
    const user = await User.findById(req.user);
    res.json({...user._doc,token:req.token});
})

//initially authRouter was a private variable
//with this statement we are telling that authRouter is not private anymore and it can be used everywhere since javascript keeps all the exported variables/objects in one particular file for public accress throught the application  
//for now we are simply sending a variable but if we want to send multiple things , we need to send an object
module.exports = authRouter;