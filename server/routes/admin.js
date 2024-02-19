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

//GET ALL THE LISTED PRODUCTS
adminRouter.get('/admin/get-product', admin, async(req, res) => {
    try{
        //by not specifying any criteria in the find({}), we are saying that we need all the products listed 
        const products = await Product.find({});
        //sending product data back to the client side
        res.json(products);
    } catch (e) {
        res.status(500).json({error : e.message});
    }
})

//DELETE TEH LISTED PRODUCT
adminRouter.post('/admin/delete-product', admin, async(req, res) => {
    try{
        const {id} = req.body;
        let product = await Product.findByIdAndDelete(id);
        res.json(product);
    } catch (e) {
        res.status(500).json({error : e.message});
    }
})

module.exports = adminRouter;