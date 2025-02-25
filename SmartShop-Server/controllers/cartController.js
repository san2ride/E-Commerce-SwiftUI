const models = require('../models')

exports.addCartItem = async (req, res) => {
    const { productId, quantity } = req.body 
    req.userId = 9 // hard-coded 
    try {
        // get the cart based on userId is_active: true 
        let cart = await models.Cart.findOne({
            where: {
                user_id: req.userId, 
                is_active: true 
            }
        })
        if(!cart) {
            // create a new cart 
            cart = models.Cart.create({
                user_id: req.userId, 
                is_active: true 
            })
        }
        // add item to the cart 
        const [cartItem, created] = await models.CartItem.findOrCreate({
            where: {
                cart_id: cart.id, 
                product_id: productId 
            }, 
            defaults: { quantity }
        })
        console.log(cartItem)
        if(!created) {
            // already exists 
            cartItem.quantity += quantity 
            // save it 
            await cartItem.save()
        }
        res.status(201).json({
            message: 'Item added to the cart.', 
            success: true 
        })
    } catch (error) {
        console.log(error)
        res.status(500).json({ message: 'Internal server error', success: false });
    }
}