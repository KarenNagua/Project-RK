const moment = require('moment-timezone');
const { admin, db, auth } = require('../config/firebase_config');

class AuthController {

    checkUserTypeAndRedirect( req, res ) {
        let { uid, type } = req.query;
        if( uid ) {
            db.collection('account').doc(uid).get()
                .then( account => {
                    if ( account ) {
                        if( parseInt(type) !== -1 && account.data().type !== parseInt(type)) {
                            return res.json({code: -1, data: 'Error, acceso no autorizado'});
                        } else {
                            return res.json({code: 0, data: 'Acceso autorizado', uid:account.id, type: account.data().type});
                        }
                    } else {
                        return res.json({code: -1, data: 'Error, acceso no autorizado'});
                    }
                }).catch( error => {
                    console.log(error);
                    return res.json({code: -1, data: 'Error, acceso no autorizado'});
                });
        } else {
            res.redirect('/');
        }
    }

    checkUserDataExist( req,res ) {
        if( req.query.uid ) {
            db.collection('account').doc(req.query.uid).get()
                .then( c => {
                    console.log(c);
                    if( c.id && c.data() ) {
                        return res.json({code: 0, html: 'El usuario existe', account: { id: c.id, data: c.data() }});
                    } else {
                        return res.json({code: -1, html: 'Usuario no registrado'});
                    }
                }).catch( e => {
                    return res.json({code: -1, html: 'Error, no se pudo completar la operación', error: e});
                });
        } else {
            res.json({code: -1, html: 'Error, parámetros incompletos'});
        }
    }
}

module.exports = AuthController;