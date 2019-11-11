const moment = require('moment-timezone');
const { admin, db, auth } = require('../config/firebase_config');

class AuthController {

    //Type: GET
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
}

module.exports = AuthController;