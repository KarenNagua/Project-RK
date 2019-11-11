//Poject URl
//const url = "http://localhost:5000";
const url = 'https://project-f1d8f.firebaseapp.com';

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
const storage = firebase.storage().ref();

//This listener is always wating for a change in auth state
auth.onAuthStateChanged(function (user) {
	let dir = '' + window.location.href;
	if (user) {
		if( dir.includes('main') ) {
			validateAuthUserType(user.uid, 0)
		} else if( dir.includes('secondary') ) {
			validateAuthUserType(user.uid, 1)
		} else {
			redirectUserToView(user.uid);
		}
    } else {
		if( dir.includes('main') || dir.includes('secondary') ){
			window.location.href = url;
		}
    }
});

function redirectUserToView(uid) {
    db.collection('account').doc(uid).get()
        .then( doc => {
            if ( doc ) {
                console.log(doc.data());
                if ( doc.data().type === 0 ) {
                    window.location.href = url + '/main.html';
                } else {
                    window.location.href = url + '/secundary.html';
                }
            } else {
                console.log('here');
                //User data is incorrect or not exist
                logout();
            }
        }).catch( error => {
            //An error occurred, so the user is logged out
            logout();
        }); 
}

function validateAuthUserType(uid, type) {
  db.collection("account").doc(uid).get()
    .then(doc => {
      if (doc) {
        if (doc.data().type !== type) {
			logout();	
        }
      } else {
        //User data is incorrect or not exist
        logout();
      }
    })
    .catch(error => {
		//An error occurred, so the user is logged out
		logout();
    });
}

function logout(){
    firebase.auth().signOut().then(function() {
        window.location.href = url;
    }).catch(function(error) {
        window.location.href = url;
    });
}
