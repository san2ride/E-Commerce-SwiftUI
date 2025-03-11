const models = require('../models')

exports.createOrder = async (req, res) => {
    const userId = req.userId 

    const { total, order_items } = req.body 

    // start a transaction 
    const transaction = await models.Order.sequelize.transaction() 
    try {
        // create a new order 
        const newOrder = await models.Order.create({
            user_id: userId, 
            total: total
        }, { transaction }) // ensures that this is part of the transaction 
        // create order items with order id 
        const orderItemsData = order_items.map(item => ({
            product_id: item.product_id, 
            quantity: item.quantity, 
            order_id: newOrder.id 
        }))
        await models.OrderItem.bulkCreate(orderItemsData, { transaction })
        // get the active cart for the user 

        // update cart status to make it active = false 

        // clear cart items from cart items table 

        // commit the transaction 
        return res.status(201).json({ success: true });
    } catch (error) {
        // rollback the transaction 
        transaction.rollback() 
        return res.status(500).json({ message: 'Internal server error', success: false });
    }
}