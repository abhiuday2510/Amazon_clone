
const mongoose = require("mongoose");
const ratingSchema = require("./rating");

const productSchema = mongoose.Schema({
    name:{
        type: String,
        required: true,
        trim: true,
    },
    description:{
        type: String,
        required: true,
        trim: true,
    },
    //since images is a list, we are going to do it differently 
    images: [
        {
            type: String,
            required: true,
        },
    ],
    quantity :{
        type : Number,
        required:true,
    },
    price :{
        type : Number,
        required:true,
    },
    category : {
        type: String,
        required : true,
    },
    //array of all the ratingSchema
    ratings : [ratingSchema],
});

const Product = mongoose.model('Product', productSchema);
module.exports = Product;