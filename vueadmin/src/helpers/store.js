import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    user: {
      loggedIn: false,
      data: null,
      account: null,
      person: null
    }
  },
  getters: {
    alldata(state) {
      return state.user;
    },
    user(state) {
      return state.user.data;
    },
    account(state) {
      return state.user.account;
    },
    person(state) {
      return state.user.person;
    }
  },
  mutations: {
    SET_LOGGED_IN(state, value) {
      state.user.loggedIn = value;
    },
    SET_USER(state, data) {
      state.user.data = data;
    },
    SET_ACCOUNT(state, data) {
      state.user.account = data;
    },
    SET_PERSON(state, data) {
      state.user.person = data;
    }
  },
  actions: {
    fetchUser({ commit }, user) {
      commit("SET_LOGGED_IN", user != null);
      if (user) {
        commit("SET_USER", {
          id: user.uid,
          email: user.email
        });
      } else {
        commit("SET_USER", null);
      }
    },
    fetchAccount({ commit }, account) {
      if (account) {
        commit("SET_ACCOUNT", {
          id: account.id,
          data: account.data()
        });
      } else {
        commit("SET_ACCOUNT", null);
      }
    },
    fetchPerson({ commit }, person) {
      if (person) {
        commit("SET_PERSON", {
          id: person.id,
          data: person.data()
        });
      } else {
        commit("SET_PERSON", null);
      }
    }
  }
});
