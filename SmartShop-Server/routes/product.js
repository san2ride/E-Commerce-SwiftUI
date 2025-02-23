const express = require('express')
const router = express.Router()
const productController = require('../controllers/productController')
const { body, param } = require('express-validator');

const productValidator = [
    body('name', 'name cannot be empty.').not().isEmpty(),
    body('description', 'description cannot be empty.').not().isEmpty(),
    body('price', 'price cannot be empty.').not().isEmpty(),
    body('photo_url').notEmpty().withMessage('photoUrl cannot be empty.')
]

const deleteProductValidator = [
    param('productId')
        .notEmpty().withMessage('ProductId is required.')
        .isNumeric().withMessage('Product ID must be a number')
]

const updateProductValidator = [
    param('productId')
    .notEmpty().withMessage('ProductId is required.')
    .isNumeric().withMessage('Product Id must be a number'), 
    body('name', 'name cannot be empty.').not().isEmpty(), 
    body('description', 'description cannot be empty.').not().isEmpty(), 
    body('price', 'price cannot be empty.').not().isEmpty(), 
    body('photo_url')
    .notEmpty().withMessage('photoUrl cannot be empty.'), 
    body('user_id')
    .notEmpty().withMessage('UserId is required.')
    .isNumeric().withMessage('UserId must be a number'), 
]

// /api/products
router.get('/', productController.getAllProducts)
router.post('/', productValidator, productController.create)
router.get('/user/:userId', productController.getMyProducts)

router.post('/upload', productController.upload)

// DELETE /api/products/34
router.delete('/:productId', deleteProductValidator, productController.deleteProduct)

// PUT
router.put('/:productId', updateProductValidator, productController.updateProduct)

module.exports = router