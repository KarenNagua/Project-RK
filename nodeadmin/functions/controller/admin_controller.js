const moment = require('moment-timezone');
const { admin, db, auth } = require('../config/firebase_config');

class AdminController {

    main( req,res ) {
        let uid = req.query.u;
        if( uid && uid.length > 0 ) {
            let e = db.collection('account').doc(uid).get();
            let a = db.collection('account').orderBy('type').get();
            let b = db.collection('person').get();
            let c = db.collection('category').get();
            let d = db.collection('site').get();

            Promise.all([e,a,b,c,d]).then( data => {
                if ( data[0] ) {
                    return res.render(
                        'admin/main',
                        {
                            account: { id: data[0].id, data: data[0].data() },
                            account_list: data[1].docs.map( doc => { return { id: doc.id, data: doc.data()}; } ),
                            person_list: data[2].docs.map( doc => { return { id: doc.id, data: doc.data()}; } ),
                            category_list: data[3].docs.map( doc => { return { id: doc.id, data: doc.data()}; } ),
                            site_list: data[4].docs.map( doc => { return { id: doc.id, data: doc.data()}; } ),
                        }
                    );
                } else {
                    return res.redirect('/');
                }
            }).catch( error => {
                console.log(error);
                return res.redirect('/');
            });
        } else {
            res.redirect('/');
        }
    }

    updatePersonOrAccountField( req, res ) {
        let d = JSON.parse(req.body.data);

        let collection = ( d.campo === 'type' || d.campo === 'state' ) ? 'account' : 'person';
        let id_doc = ( d.campo === 'type' || d.campo === 'state' ) ? d.id_account : d.id_person;

        db.collection(collection).doc(id_doc).get()
            .then( doc => {
                let aux = doc.data();
                if( d.tipo === 0 ) {
                    aux[ d.campo ] = d.new;
                } else if( d.tipo === 1 ){
                    aux[ d.campo ] = parseInt(d.new);
                }
                return db.collection(collection).doc(id_doc).set(aux);
            }).then( ref => {
                return res.json({code:0, data:'Campo actualizado'});
            }).catch( error => {
                console.log(error);
                return res.json({code:-1, data:'Error, no se pudo completar la operación'});
            });
    }

    registerUserAdminOrFinal( req, res ){
        let { account, person } = JSON.parse(req.body.data);
        
        let id_person = db.collection('person').doc().id;
        let a = auth.createUser({ email: account.email, password: account.password });
        let b = db.collection('person').doc(id_person).set(person);

        Promise.all([a,b])
            .then( da => {
                account.id_person = id_person;
                let a = db.collection('account').doc(da[0].uid).set(account); 
                let b = db.collection('person').doc(id_person).get();
                let c = db.collection('account').doc(da[0].uid).get();
                return Promise.all([a,b,c]);
            }).then( db => {
                return res.json({code:0, data: 'Usuario registrado', account:{id: db[2].id, data: db[2].data()}, person:{id: db[1].id, data: db[1].data()}});
            }).catch( error => {
                console.log(error);
                return res.json({code:0, data:'Error, no se pudo completar la operación'});
            });
    }

    getallAccountsByType( req,res ) {
        if ( req.query.type ) {
            db.collection('account').where('type','==',parseInt(req.query.type)).get()
                .then( data => {
                    return res.json({code: 0, html: 'Consulta exitosa', accounts: data.docs.map( doc => { return {id: doc.id, data: doc.data()} })});
                }).catch( error => {
                    return res.json({code: -1, html: 'Error, no se pudo completar la operación', error: error});
                });
        } else {
            res.json({code:-1, html:'Error, parámetros incompletos'});
        }
    }

    getallAccountAndPersonDataByIdAccount( req,res ) {
        if ( req.query.id ) {
            db.collection('account').doc(req.query.id).get()
                .then( da => {
                    let a = db.collection('person').doc(da.data().id_person).get();
                    let b = db.collection('account').doc(da.id).get();
                    return Promise.all([a,b]);
                }).then( data => {
                    return res.json({code: 0, html: 'Consulta exitosa', person: {id: data[0].id, data: data[0].data()}, account: {id: data[1].id, data: data[1].data()}});
                }).catch( error => {
                    return res.json({code: -1, html: 'Error, no se pudo completar la operación', error: error});
                });
        } else {
            res.json({code:-1, html:'Error, parámetros incompletos'});
        }
    }

}

module.exports = AdminController;