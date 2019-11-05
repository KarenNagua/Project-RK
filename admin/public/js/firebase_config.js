//Firebase Config
var firebaseConfig = {
    apiKey: "AIzaSyBm3ZRIoz8_sKwEoa7R_lXIXen4K3heX4s",
    authDomain: "myplaces-a4d91.firebaseapp.com",
    databaseURL: "https://myplaces-a4d91.firebaseio.com",
    projectId: "myplaces-a4d91",
    storageBucket: "myplaces-a4d91.appspot.com",
    messagingSenderId: "484111150906",
    appId: "1:484111150906:web:02d38bfaf3d3990fea6a03",
    measurementId: "G-MK5EBY88K9"
};

//Firebase Init
firebase.initializeApp(firebaseConfig);

//Firebase variables
const auth = firebase.auth(); //Registro e inicio de sesión
const db = firebase.firestore(); //Base de datos Firestore
db.settings({
    timestampsInSnapshots: true
});


