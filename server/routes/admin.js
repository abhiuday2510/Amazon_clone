const express = require("express");
const admin = require("../middlewares/admin");
const Product = require("../models/product");
const adminRouter = express.Router();


//ADD PRODUCT
adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try{
        const {name, description, images, quantity, price, category} = req.body;
        //let allows us to change the values later on
        let product = new Product({
            name, description, images, quantity, price, category,
        });
        product = await product.save();
        res.json(product);
    }catch (e){
        res.status(500).json({error : e.message});
    }
})

module.exports = adminRouter;