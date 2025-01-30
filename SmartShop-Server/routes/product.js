const express = require('express')
const product = require('../models/product')
const router = express.Router()

// /api/products
router.get('/', productController.getAllProducts)