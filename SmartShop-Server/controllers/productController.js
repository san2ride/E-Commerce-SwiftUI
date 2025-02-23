const models = require('../models')
const multer = require('multer')
const path = require('path')
const { validationResult } = require('express-validator');
const { getFileNameFromUrl, deleteFile } = require('../utils/fileUtils');

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/')
    },
    filename: function (req, file, cb) {
        cb(null, file.fieldname + '-' + Date.now() + path.extname(file.originalname))
    }
})

// setting up multer for image uploads
const uploadImage = multer({
    storage: storage,
    limits: { fileSize: 5 * 1024 * 1024 },
    fileFilter: function (req, file, cb) {
        const fileTypes = /jpeg|jpg|png/;
        const extname = fileTypes.test(path.extname(file.originalname).toLowerCase())
        const mimeType = fileTypes.test(file.mimetype)

        if (mimeType && extname) {
            return cb(null, true)
        } else {
            cb(new Error('Only images are allowed!'))
        }
    }
}).single('image')

exports.upload = async (req, res) => {
    uploadImage(req, res, (err) => {
        if (err) {
            return res.status(400).json({ message: err.message, success: false });
        }
        if (!req.file) {
            return res.status(400).json({ message: 'No file uploaded', success: false });
        }
        const baseUrl = `${req.protocol}://${req.get('host')}`
        const filePath = `/api/uploads/${req.file.filename}`
        const downloadUrl = `${baseUrl}${filePath}`

        res.json({ message: 'File uploaded successfully', downloadUrl: downloadUrl, success: true })
    })
}

exports.getAllProducts = async (req, res) => {
    const products = await models.Product.findAll({})
    res.json(products)
}

// /api/products/user/8
exports.getMyProducts = async (req, res) => {
    try {
        const userId = req.params.userId
        const products = await models.Product.findAll({
            where: {
                user_id: userId
            }
        })
        res.json(products)
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving products', success: false });
    }
}

exports.create = async (req, res) => {
    console.log('create')
    const errors = validationResult(req)
    console.log(errors)

    if (!errors.isEmpty()) {
        const msg = errors.array().map(error => error.msg).join('')
        return res.status(422).json({ message: msg, success: false });
    }
    const { name, description, price, photo_url, user_id } = req.body
    console.log(req.body)

    try {
        const newProduct = await models.Product.create({
            name: name,
            description: description,
            price: price,
            photo_url: photo_url,
            user_id: user_id
        })
        res.status(201).json({ success: true, product: newProduct })
    } catch (error) {
        res.status(500).json({ message: "Internal server error", success: false });
    }
}

exports.deleteProduct = async (req, res) => {
    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        const msg = errors.array().map(error => error.msg).join('')
        return res.status(422).json({ message: msg, success: false });
    }

    const productId = req.params.productId

    try {
        const product = await models.Product.findByPK(productId)
        if (!product) {
            return res.status(404).json({ message: 'Product not found', success: false });
        }
        const fileName = getFileNameFromUrl(product.photo_url)

        // delete the product
        const result = models.Product.destroy({
            where: {
                id: productId
            }
        })
        if (result == 0) {
            return res.status(404).json({ message: 'Product not found', success: false });
        }
        // delete the file
        await deleteFile(fileName)

        return res.status(200).json({ message: `Product with ID ${productId} deleted succesfully`, success: true });
    } catch (err) {
        return res.status(500).json({ message: `Error deleting product ${error.message} `, success: false });
    }
}