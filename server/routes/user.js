const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const { Product } = require("../models/product");
const User = require("../models/user");

    //ADD PRODUCT TO CART
    userRouter.post('/api/add-to-cart', auth, async (req, res) => {
        try{
            const {id} = req.body;
            const product = await Product.findById(id);
            let user = await User.findById(req.user);

            if(user.cart.length ==0) {
                user.cart.push({product , quantity : 1});
            }
            else{
                let isProductFound = false;
                for(let i=0;i<user.cart.length; i++){
                    //mongoDb always adds _ in its id
                    //here we are not comparing id as strings, rather we are comparing object ids as provided by mongoDb, thats why we dont use == here and use equals()
                    if(user.cart[i].product._id.equals(product._id)){
                        isProductFound = true;
                    }
                }
                if(isProductFound){
                    let producttt = user.cart.find((productt) => productt.product._id.equals(product._id));
                    producttt.quantity += 1;
                }
                else{
                    user.cart.push({product , quantity : 1});
                }
            }
            user = await user.save();
            res.json(user);
        }catch (e){
            res.status(500).json({error : e.message});
        }
    });

    //Delete product from cart
    userRouter.delete('/api/remove-from-cart/:id', auth, async (req, res) => {
        try{
            const {id} = req.params;
            const product = await Product.findById(id);
            let user = await User.findById(req.user);
            for(let i=0;i<user.cart.length; i++){
                if(user.cart[i].product._id.equals(product._id)){
                    if(user.cart[i].quantity == 1){
                        //splice() deletes based on what we enter
                        //deletes the entire product from the cart if its quantity is 1
                        //since we do not want product with 0 quantity in our cart
                        user.cart.splice(i,1);
                    }else {
                        //if the product quantity in the cart is >1, we simply decrease its quantity
                        user.cart[i].quantity -= 1;
                    }
                }
            }
            user = await user.save();
            res.json(user);
        }catch (e){
            res.status(500).json({error : e.message});
        }
    });

module.exports = userRouter;