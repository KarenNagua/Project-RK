const admin = require('firebase-admin');
const serviceAccount = require('./serviceaccount.json');

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://project-f1d8f.firebaseio.com"
});

const auth = admin.auth();
const db = admin.firestore();
db.settings({timestampsInSnapshots: true});

module.exports = {
    admin: admin,
    db: db,
    auth: auth 
};