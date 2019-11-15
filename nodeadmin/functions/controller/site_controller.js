const moment = require('moment-timezone');
const { admin, db, auth } = require('../config/firebase_config');

class SiteController {

    getSites( req, res ) {
        db.collection('sites').get()
            .then( data => {
                return res.json({
                    code: 0,
                    html: 'Consulta exitosa',
                    data: data.docs.map( doc => { return { id: doc.id, data: doc.data() } }),
                });
            }).catch( err => {
                return res.json({code: -1, html: 'Error, no se pudo completar la operación', error: err});        
            });
    }

    /*searchSitesByCategoryId( req,res ) {

    }*/

    getCategoriesById( req, res ){
        if (req.query.id) {
            db.collection('category').doc(req.query.id).get()
                .then( c => {
                    if( c ) {
                        return res.json({
                            code: 0,
                            html: 'Consulta exitosa',
                            data: { id: c.id, data: c.data() },
                        });
                    } else {
                        return res.json({ code: 0, html: 'No existen registros con el ID ' + req.query.id, data: [] });
                    }
                }).catch( err => {
                    return res.json({code: -1, html: 'Error, no se pudo completar la operación', error: err});
                });
        } else {
            res.json({code: -1, html: 'Error, parámetros incompletos'});
        }
    }

    searchCategoryByLabel( req, res ) {
        if ( req.query.label ) {
            db.collection('category').get()
                .then( data => {
                    let d = [];
                    data.docs.forEach( doc => {
                        let a = doc.data().label.toLowerCase();
                        if( a.includes( req.query.label.toLowerCase() ) ) {
                            d.push({
                                id: doc.id,
                                data: doc.data()
                            });
                        }
                    });
                    return res.json({
                        code: 0,
                        html: 'Consulta exitosa',
                        data: d,
                    });
                }).catch( err => {
                    console.log(err);
                    return res.json({code: -1, html: 'Error, no se pudo completar la operación', error: err});        
                });
        } else {
            res.json({code: -1, html: 'Error, parámetros incompletos'});
        }
    }

}

module.exports = SiteController;