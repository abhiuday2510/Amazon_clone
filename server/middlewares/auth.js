//HERE WE WILL PASS IN THE TOKEN AND WE NEED TO VERIFY THAT TOKEN
const jwt = require("jsonwebtoken");

//we will create a function and not a route
//next is something like : continue on with the next route, since we are going to pass it as a middleware
const auth = async (req, res, next) => {
    try{
        //we are using header because we will be using this auth middlewarwe everytime we need token authentication, so its better to pass it in header
        const token = req.header("x-auth-token");
        if(!token)
            //401 stands for unauthorized
            return res.status(401).json({msg: "No auth token, access denied!"});
        
        const verified = jwt.verify(token , "passwordKey");
        if(!verified)
            return res.status(401).json({msg : "Token verification failed, authorization denied!"});

        //we are adding a new object to this request which is user and we are saving something to it, which is verified.id
        //now everytime we cant pass in the body the user's id
        //so here in this middleware, we first perform all the validations and if the user is valid, we are storing user's id in req.user
        //now we can simply use this middleware to access user's id using req.user
        req.user = verified.id;

        //same like req.user, we are adding the token as well for its easy access
        req.token = token;

        //it basically means that after this middleware, it automatically calls the next call back funtion
        next();
        
    }catch (err) {
        res.status(500).json({error: err.message});
    }
}

module.exports = auth;
