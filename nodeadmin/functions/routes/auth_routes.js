const express = require('express');
const router = express.Router();

const auth_controller = require('../controller/auth_controller');
const auth = new auth_controller();

router.get( '/checkUserTypeAndRedirect', auth.checkUserTypeAndRedirect );

module.exports = router;