import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import * as firebase from "firebase";
import store from "./helpers/store";

Vue.config.productionTip = false;

var configFirebase = {
  apiKey: "AIzaSyBSnqH6G2CF9Pqi76rXCGlCRqITAWwGnx4",
  authDomain: "project-f1d8f.firebaseapp.com",
  databaseURL: "https://project-f1d8f.firebaseio.com",
  projectId: "project-f1d8f",
  storageBucket: "project-f1d8f.appspot.com",
  messagingSenderId: "607290027483",
  appId: "1:607290027483:web:9c8d914da26464b146cbfe",
  measurementId: "G-E17FMJ7VXS"
};

firebase.initializeApp(configFirebase);

firebase.auth().onAuthStateChanged(user => {
  store.dispatch("fetchUser", user);
});

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount("#app");
