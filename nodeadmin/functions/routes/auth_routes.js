const express = require('express');
const router = express.Router();

const auth_controller = require('../controller/auth_controller');
const auth = new auth_controller();

/**
 * @api {get} /auth/checkUserTypeAndRedirect/:uid:type Verifica si el tipo de cuenta permite el acceso a la página desde donde se solicita.
 * @apiName checkUserTypeAndRedirect
 * @apiGroup AuthRoutes
 *
 * @apiParam {String} uid ID único del usuario.
 * @apiParam {Number} type Indica la página actual desde donde accede el usuario.
 *
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} data Mensaje de estatus.
 * @apiSuccess {String} uid ID único del usuario.
 * @apiSuccess {Number} type Indica el tipo de la cuenta del usuario (Administrador o usuario final).
 */
router.get( '/checkUserTypeAndRedirect', auth.checkUserTypeAndRedirect );

/**
 * @api {get} /auth/checkUserDataExist/:uid Valida si el usuario que accedió existe en la BD.
 * @apiName checkUserDataExist
 * @apiGroup AuthRoutes
 *
 * @apiParam {Number} uid ID único del usuario.
 *
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} html  Mensaje de estatus.
 * @apiSuccess {JSON} account Información de la cuenta del usuario.
 */
router.get( '/checkUserDataExist', auth.checkUserDataExist );

module.exports = router;