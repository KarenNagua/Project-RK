const express = require('express');
const router = express.Router();

const admin_controller = require('../controller/admin_controller');
const admin = new admin_controller();


router.get( '/main', admin.main );

router.post( '/updatePersonOrAccountField', admin.updatePersonOrAccountField );
router.post( '/registerUserAdminOrFinal', admin.registerUserAdminOrFinal );




module.exports = router;