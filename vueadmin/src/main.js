import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./helpers/store";
import { firestorePlugin } from "vuefire";
import { auth } from "./config/auth";
import { db } from "./config/db";
import * as VueGoogleMaps from "vue2-google-maps";

import { library } from "@fortawesome/fontawesome-svg-core";
import {
  faEnvelope,
  faLock,
  faMapMarked,
  faUser,
  faSignOutAlt,
  faMapMarkedAlt,
  faMapMarker,
  faLocationArrow,
  faInfoCircle,
  faParking,
  faTimes,
  faSearch,
  faStar,
  faHeart,
} from "@fortawesome/free-solid-svg-icons";
import { faHeart as farHeart } from "@fortawesome/free-regular-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/vue-fontawesome";

library.add(
  faEnvelope,
  faLock,
  faMapMarked,
  faUser,
  faSignOutAlt,
  faMapMarkedAlt,
  faMapMarker,
  faLocationArrow,
  faInfoCircle,
  faParking,
  faTimes,
  faSearch,
  faStar,
  faHeart,
  farHeart
);
Vue.component("font-awesome-icon", FontAwesomeIcon);

Vue.config.productionTip = false;
Vue.use(firestorePlugin);
Vue.use(VueGoogleMaps, {
  load: {
    key: "AIzaSyABl1dUSJ86O5cX4f05fT6rPdJ5vCa6-Is",
    libraries: "places" // necessary for places input
  }
});

let app = null;

auth.onAuthStateChanged(async user => {
  if (user) {
    let account = await db
      .collection("account")
      .doc(user.uid)
      .get();
    if (account) {
      let person = await db
        .collection("person")
        .doc(account.data().id_person)
        .get();
      if (person) {
        store.dispatch("fetchUser", user);
        store.dispatch("fetchAccount", account);
        store.dispatch("fetchPerson", person);
      } else {
        store.dispatch("fetchUser", user);
        store.dispatch("fetchAccount", account);
        store.dispatch("fetchPerson", null);
      }
    } else {
      store.dispatch("fetchUser", user);
      store.dispatch("fetchAccount", null);
      store.dispatch("fetchPerson", null);
    }
  }
  if (!app) {
    app = new Vue({
      router,
      store,
      render: h => h(App)
    }).$mount("#app");
  }
});
