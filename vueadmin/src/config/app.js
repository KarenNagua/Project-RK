import Firebase from "firebase/app";
import credentials from "./credentials";

const FirebaseApp = Firebase.initializeApp(credentials.config);

export const firebase = FirebaseApp;
