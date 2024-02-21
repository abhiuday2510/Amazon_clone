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
        console.log(req.query.category);
        const products = await Product.find({category : req.query.category});
        res.json(products);
    } catch (e) {
        res.status(500).json({error : e.message});
    }
})

module.exports = productRouter;