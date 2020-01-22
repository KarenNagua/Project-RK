import Vue from "vue";
import { auth } from "../config/auth";
import VueRouter from "vue-router";
import Home from "../views/Home.vue";
import MainView from "../views/MainView.vue";
//import store from "../helpers/store";

Vue.use(VueRouter);

const routes = [
  {
    path: "*",
    redirect: "/home"
  },
  {
    path: "/",
    name: "home",
    component: Home
  },
  {
    path: "/mainview",
    name: "mainview",
    component: MainView,
    meta: {
      requiresAuth: true
    }
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.BASE_URL,
  routes
});

router.beforeEach((to, from, next) => {
  if (to.matched.some(route => route.meta.requiresAuth)) {
    if (auth.currentUser) {
      next();
    } else {
      next({ path: "/" });
    }
  }
  next();
});

export default router;
