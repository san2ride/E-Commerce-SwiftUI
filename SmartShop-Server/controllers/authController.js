const jwt = require('jsonwebtoken')
const bcrypt = require('bcryptjs')
const models = require('../models')
const { Op } = require('sequelize');
const { validationResult } = require('express-validator');

exports.login = async (req, res) => {
    const errors = validationResult(req)
    console.log(errors)
    if (!errors.isEmpty()) {
        const msg = errors.array().map(error => error.msg).join('')
        return res.status(422).json({ success: false, message: msg })
    }
    const { username, password } = req.body

    // check if user exists
    const existingUser = await models.User.findOne({
        where: {
            username: { [Op.iLike]: username }
        }
    })
    if(!existingUser) {
        return res.status(401).json({ message: 'Username or password is incorrect', success: false });
    }
    // check the password
    const isPasswordValid = await bcrypt.compare(password, existingUser.password)
    if(!isPasswordValid)
        return res.status(401).json({ message: 'Password is incorrect', success: false });
    // generate JWT token
    const token = jwt.sign({ userId: existingUser.id}, 'SECRETKEY' {
        expiresIn: '1h'
    })
}

exports.register = async (req, res) => {

    const errors = validationResult(req)
    console.log(errors)
    if (!errors.isEmpty()) {
        const msg = errors.array().map(error => error.msg).join('')
        return res.status(422).json({ success: false, message: msg })
    }
    try {
        const { username, password } = req.body
        const existingUser = await models.User.findOne({
            where: {
                username: { [Op.iLike]: username }
            }
        })

        if (existingUser) {
            return res.json({ message: 'Username taken!', success: false })
        }

        // create password hash
        const salt = await bcrypt.genSalt(10)
        const hash = await bcrypt.hash(password, salt)

        // create User
        const _ = models.User.create({
            username: username,
            password: hash
        })
        res.status(201).json({ success: true })
    } catch (error) {
        res.status(500).json({ message: 'Internal server error.', success: false })
    }
}