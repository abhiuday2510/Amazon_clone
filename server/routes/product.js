const express = require("express");
const Product = require("../models/product");
const productRouter = express.Router();
const auth = require("../middlewares/auth");

//if the client wants the product of certain category, he has to give some more info(i.e body) into the url
//the current url: /api/products , will become something like: /api/products?category=Essentials
//with the question mark we are differentiating between the original url and the extra request body added by the client
productRouter.get('/api/products', auth, async(req, res) => {
    try{
        //req.query will get us anything after the question mark in the url
        //like for: /api/products?category=Essentials, the below req.querry.category will give value as 'Essentials'
        const products = await Product.find({category : req.query.category});
        res.json(products);
    } catch (e) {
        res.status(500).json({error : e.message});
    }
})

//get request to search products and get them
// the /api/products/search/:name way of writing helps us in searching with different params
productRouter.get('/api/products/search/:name', auth, async(req, res)=> {
    try{
        //for searching the products dynamically, we are going to make use of regex
        const products = await Product.find({
            //mongoDB has built in functionality of using regex for searching as follows
            //Alongside the $regex operator, you can use the $options operator to specify flags to the regular expression.
            //Common flags include i for case-insensitivity, m for multi-line matching, and so on.
            name: {$regex: req.params.name, $options: "i"},
        },);
        res.json(products);
    } catch(e) {
        res.status(500).json({error : e.message});
    }
})

module.exports = productRouter;