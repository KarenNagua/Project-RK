const express = require('express');
const router = express.Router();

const admin_controller = require('../controller/admin_controller');
const admin = new admin_controller();


router.get( '/main', admin.main );

router.post( '/updatePersonOrAccountField', admin.updatePersonOrAccountField );
router.post( '/registerUserAdminOrFinal', admin.registerUserAdminOrFinal );

//Admin general EndPoints
//Allow to get all account about the type seding as parameter in the query,
//id Parameter, value 0 return all accounts of type admin, value 1 returns all accounts of type final user
router.get( '/getallAccountsByType', admin.getallAccountsByType );

//Allow to get the information about the account and person by the user ID seding as parameter in the query
//id parameter require
router.get( '/getallAccountAndPersonDataByIdAccount', admin.getallAccountAndPersonDataByIdAccount );





module.exports = router;