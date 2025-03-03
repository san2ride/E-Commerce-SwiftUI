const express = require('express')
const router = express.Router() 
const cartController = require('../controllers/cartController')

router.post('/items', cartController.addCartItem)
// load cart
router.get('/', cartController.loadCart)

module.exports = router 