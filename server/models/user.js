//we create user models with mongoose
const mongoose = require("mongoose");

//schema is like the structure of the user model we are going to create, this is not the final model
const userSchema = mongoose.Schema({
    //here we need to define some properties that are going to be in this model along with their definitions
    name: {
        required: true,
        type: String,
        //trim removes all the leading and trailing spaces in the name
        trim: true
    },
    email: {
        requires: true,
        type: String,
        trim: true,
        //validates if entered email is matching all the criteria like @ or .com presence etc
        validate: {
            validator: (value) => {
                //here we make use of regex
                const re = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                //the match() function matches a string with a regular expression, and returns an array containing the results of that search.
                return value.match(re);
            },
            //this message runs whenever the validator becomes false
            message: "Please enter a valid email address",
        },
    },
    password: {
        required: true,
        type: String,
        // validate: {
        //     validator: (value) => { 
        //         return value.length >= 7;
        //     },
        //     message: "Please enter a password with 7 or more characters",
        // },
    },
    //this wont be a required feild since its not entered during signup/login and hence has a default value of an empty string
    address: {
        type: String,
        default: '',
    },
    //if the user is seller or admin, but by default we set it to user cause we dont want everyone to be admin
    type: {
        type: String, 
        default: "user",
    }
    //CART
});

//using the above schema to create the final model
const User = mongoose.model("User", userSchema);

//exporting the User model
module.exports = User;

