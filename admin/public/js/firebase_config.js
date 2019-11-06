//Firebase Config
var firebaseConfig = {
    apiKey: "AIzaSyBSnqH6G2CF9Pqi76rXCGlCRqITAWwGnx4",
    authDomain: "project-f1d8f.firebaseapp.com",
    databaseURL: "https://project-f1d8f.firebaseio.com",
    projectId: "project-f1d8f",
    storageBucket: "project-f1d8f.appspot.com",
    messagingSenderId: "607290027483",
    appId: "1:607290027483:web:9c8d914da26464b146cbfe",
    measurementId: "G-E17FMJ7VXS"
  };

//Firebase Init
firebase.initializeApp(firebaseConfig);

//Firebase variables
const auth = firebase.auth(); //Registro e inicio de sesión
const db = firebase.firestore(); //Base de datos Firestore
db.settings({
    timestampsInSnapshots: true
});


