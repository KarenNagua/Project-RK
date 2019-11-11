const functions = require('firebase-functions');
const { admin, db, auth } = require('./config/firebase_config');

//This end point or cloud function, allow to add a user (email and password) in firebase authentication
//Call it with an Ajax request since any JS, with the url provided by firebase when the deploy its realized
exports.createUserInAuth = functions.https.onRequest( (req, res) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Headers', 'application/json');
    
    let { email, password } = JSON.parse(req.body.data); 
    if ( email && password ) {
        auth.createUser({ email: email, password: password })
            .then( user => {
                return res.json({code:0, data:'Usuario registrado en auth (Firebase)', uid: user.uid});
            }).catch( error => {
                return res.json({code: -1, data: 'Error, no se pudo completar el registro en el auth (Firebase)'});
            });
    } else {
        res.json({code: -1, data: 'Error, email y password requeridos'});
    }
});

