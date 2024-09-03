//contains the structure of one rating that we are going to have 
const mongoose = require("mongoose");

const ratingSchema = mongoose.Schema({
    userId : {
        type : String,
        required: true,
    },
    rating: {
        type: Number,
        required: true,
    },
});

//we are not ging to make a model out of this
//whenever we just want to provide a structure, we do not need to create a model out of it
module.exports = ratingSchema;