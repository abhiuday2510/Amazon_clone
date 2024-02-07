const express = require("express");
const admin = require("../middlewares/admin");
const adminRouter = express.Router();


//ADD PRODUCT
adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try{
        const {name, description, images, quantity, price, category} = req.body;
        
    }catch (e){
        res.status(500).json({error : e.message});
    }
})