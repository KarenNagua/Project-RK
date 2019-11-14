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
const storage = firebase.storage().ref();
const db = firebase.firestore(); //Base de datos Firestore
db.settings({
	timestampsInSnapshots: true
});

const type_actual = getTypeAboutPage();

//This listener is always wating for a change in auth state
auth.onAuthStateChanged(function(user) {
	if (user) {
		//Send Ajax request to validate type of user and move it to the right page
		$.ajax({
			url: '/auth/checkUserTypeAndRedirect',
			type: 'GET',
			cache: false,
			dataType: 'json',
			data: {
				uid: user.uid,
				type: type_actual,
			}
		}).done( d => {
			if( d.code !== -1 ) {
				//Put toast to show message
				if( d.type === 0  && type_actual === -1 ) {
					window.location.href = '/admin/main?u='+d.uid;
				} else if( d.type === 1 && type_actual === -1){
					window.location.href = '/user/main?u='+d.uid;
				}
			} else {
				logout();
			}
		}).fail( (jqXHR, textStatus, errorThrown) => {
			M.toast({html: 'Error, no se pudo completar la operación'});
		});
	} else {
		if( type_actual !== -1 ) {
			window.location.href = '/';
		}
	}
});

function getTypeAboutPage(){
	let url = ''+window.location.href;
	if( url.includes('admin/main') ) {
		return 0;
	} else if( url.includes('user/main') ){
		return 1;
	} else {
		return -1;
	}
}

function logout() {
  firebase.auth().signOut()
    .then( () => {
      	window.location.href = '/';
    })
    .catch( error => {
		window.location.href = '/';
    });
}
