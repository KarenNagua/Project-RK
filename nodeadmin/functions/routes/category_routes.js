const express = require('express');
const router = express.Router();

const category_controller = require('../controller/category_controller');
const category = new category_controller();

/**
 * @api {get} /category/getCategories Consulta todas las categorías registradas en la base de datos.
 * @apiName getCategories
 * @apiGroup CategoryRoutes
 *
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} html Mensaje de estatus.
 * @apiSuccess {Array}  data Lista de todas las categorías registradas en formato JSON.
 */
router.get( '/getCategories', category.getCategories );

/**
 * @api {get} /category/searchCategoryByLabel Consulta todas las categorías cuya etiqueta (label) incluya el parámetro de búsqueda.
 * @apiName searchCategoryByLabel
 * @apiGroup CategoryRoutes
 *
 * @apiParam {String} label Etiqueta de la categoría a buscar, ya sea en su totalidad o coincidencias.
 * 
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} html Mensaje de estatus.
 * @apiSuccess {Array}  data Lista de todas las categorías en formato JSON donde haya coincidencia con el parámetro de búsqueda.
 */
router.get( '/searchCategoryByLabel', category.searchCategoryByLabel );


/**
 * @api {get} /category/getCategoriesById Consulta la información de la categoría cuyo ID sea igual al parámetro de búsqueda.
 * @apiName getCategoriesById
 * @apiGroup CategoryRoutes
 *
 * @apiParam {String} id ID (único) de la categoría a buscar.
 * 
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} html Mensaje de estatus.
 * @apiSuccess {Array}  data Información de la categoría en formato JSON (en caso de existir).
 */
router.get( '/getCategoriesById', category.getCategoriesById );




module.exports = router;