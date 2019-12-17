const express = require('express');
const router = express.Router();

const site_controller = require('../controller/site_controller');
const site = new site_controller();

/**
 * @api {get} /sites/getSites Devuelve la información de todos los sitios registrados en la BD
 * @apiName getSites
 * @apiGroup SiteRoutes
 *
 * 
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} html Mensaje de estatus.
 * @apiSuccess {Array}  data Información de todos los sitios en formato JSON.
 */
router.get( '/getSites', site.getSites );

/**
 * @api {get} /sites/getSiteById Devuelve la información del sitio según el ID enviado como parámetro
 * @apiName getSiteById
 * @apiGroup SiteRoutes
 *
 * @apiParam {String} id ID (único) del sitio a buscar.
 * 
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} html Mensaje de estatus.
 * @apiSuccess {Array}  data Información del sitio en formato JSON (en caso de existir).
 */
router.get( '/getSiteById', site.getSiteById );

/**
 * @api {get} /sites/searchSiteByLabel Devuelve la información del sitio según el Label o nombre enviado como parámetro
 * @apiName searchSiteByLabel
 * @apiGroup SiteRoutes
 *
 * @apiParam {String} label o nombre del sitio a buscar.
 * 
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} html Mensaje de estatus.
 * @apiSuccess {Array}  data Información de los sitios cuyo label coincida con el parámetro enviado. Respuesta en formato JSON (en caso de existir).
 */
router.get( '/searchSiteByLabel', site.searchSiteByLabel );

/**
 * @api {get} /sites/getSitesByIdCategory Devuelve la información del sitio según el ID de la categoría enviado como parámetro
 * @apiName getSitesByIdCategory
 * @apiGroup SiteRoutes
 *
 * @apiParam {String} Id de la categoría.
 * 
 * @apiSuccess {Number} code Código de respuesta.
 * @apiSuccess {String} html Mensaje de estatus.
 * @apiSuccess {Array}  data Información de los sitios cuyo id_category coincida con el parámetro enviado. Respuesta en formato JSON (en caso de existir).
 */
router.get( '/searchSiteByLabel', site.searchSiteByLabel );

module.exports = router;