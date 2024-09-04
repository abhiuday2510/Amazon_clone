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

//post request route to rate the product
productRouter.post('/api/rate-product', auth, async(req, res) => {
    try{
        //id is product id not user id
        const {id, rating} = req.body;
        
        //we are using let instead of const since we are going to modify the product
        let product = await Product.findById(id);

        //looping through all the ratings a product has to find if the user has already rated the product
        for(let i=0; i<product.ratings.length ; i++){

            //we have access to req.user because of the auth middleware
            if(product.ratings[i].userId == req.user){
                //The splice() method is powerful for directly modifying arrays by adding, removing, or replacing elements at specific positions.
                /*let arr = [1, 2, 3, 4, 5];
                arr.splice(2, 2); // Removes 2 elements starting from index 2
                console.log(arr); // Output: [1, 2, 5]

                let arr = [1, 2, 3, 4, 5];
                arr.splice(2, 0, 'a', 'b'); // Adds 'a' and 'b' at index 2
                console.log(arr); // Output: [1, 2, 'a', 'b', 3, 4, 5]

                let arr = [1, 2, 3, 4, 5];
                arr.splice(2, 2, 'a', 'b'); // Replaces 2 elements at index 2 with 'a' and 'b'
                console.log(arr); // Output: [1, 2, 'a', 'b', 5]*/

                //the below line simply deletes the element at index i
                product.ratings.splice(i,1);
                break;
            }
        }
        const ratingSchema = {
            userId : req.user,
            //we use shorthand syntax here
            rating,
        }

        //push() is like add() in JS, adds element to the end of array
        product.ratings.push(ratingSchema);

        product = await product.save();

        res.json(product);

    }
    catch(e){
        res.status(500).json({error : e.message});
    }
})

//get deal of the day
//deal of the day depends on the product having highest rating
productRouter.get('/api/deal-of-day', auth, async(req, res) => {
    try{

        //getting all teh products first
        let products = await Product.find({});
        
        //sorting products in descending order to get the product with highest rating
        //a is product 1 , b is product 2
        //sort() method mutates the array and returns the reference to the sme array
        products = products.sort((a, b) => {

            //aSum and bSum calculates the total rating for a and b
            let aSum = 0;
            let bSum = 0;
            for(let i = 0; i<a.ratings.length; i++){
                aSum += a.ratings[i].rating;
            }
            for(let i = 0; i<b.ratings.length; i++){
                bSum += b.ratings[i].rating;
            }

            //here we are giving the condition of sorting
            //it is conventionally expected to return -ve if first arg is smaller than second arg, 0 if equal and +ve otherwise
            //here we want it in descending order so doing opposite
            return aSum < bSum ? 1 : -1;
        })
        res.json(products[0]);
    }
    catch(e){
        res.status(500).json({error : e.message});
    }
    
})



module.exports = productRouter;