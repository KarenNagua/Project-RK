const express = require('express');
const router = express.Router();

const site_controller = require('../controller/site_controller');
const site = new site_controller();



module.exports = router;