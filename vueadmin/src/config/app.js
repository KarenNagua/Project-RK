import Firebase from "firebase/app";
import credentials from "./credentials";
import "firebase/firestore";

const FirebaseApp = Firebase.initializeApp(credentials.config);

FirebaseApp.serverTimestamp = Firebase.firestore.FieldValue.serverTimestamp();

export const firebase = FirebaseApp;
