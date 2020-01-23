<template>
  <div class="sidenav shadow">
    <div class="user">
      <div class="picture">
        <img
          v-if="user.person"
          :src="user.person.data.picture"
          class="shadow"
        />
      </div>
      <span v-if="user.person" class="name">{{
        user.person.data.names.split(" ")[0] +
          " " +
          user.person.data.surnames.split(" ")[0]
      }}</span>
      <span v-if="user.person" class="email">{{ user.data.email }}</span>
    </div>
    <div class="nav">
      <div :class="menu.sitios" @click="changeSection(0)">
        <font-awesome-icon :icon="['fas', 'map-marked']" class="icon" />
        Sitios
      </div>
      <div :class="menu.profile" @click="changeSection(1)">
        <font-awesome-icon :icon="['fas', 'user']" class="icon" />
        Mi Perfil
      </div>
      <div class="item" @click="logout">
        <font-awesome-icon :icon="['fas', 'sign-out-alt']" class="icon" />
        Cerrar Sesión
      </div>
    </div>
  </div>
</template>

<style>
@import url("https://fonts.googleapis.com/css?family=Noto+Sans:400,700&display=swap");
.shadow {
  -webkit-box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14),
    0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);
  box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14),
    0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);
}
.sidenav {
  font-family: "Noto Sans", sans-serif;
  width: 100%;
  height: 100%;
  background: #fff;
  display: flex;
  flex-flow: column wrap;
  align-items: center;
  justify-content: flex-start;
  padding: 0 0;
}
.user {
  background: #172b4d;
  width: 100%;
  height: 18vw;
  display: flex;
  flex-flow: column wrap;
  align-items: center;
  justify-content: center;
}
.user .picture {
  width: 9vw;
  height: 9vw;
}
.user .picture img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
}
.user span.name {
  display: block;
  margin-top: 0.6vw;
  font-weight: 700;
  font-size: 1.2vw;
  color: #fff;
}
.user span.email {
  display: block;
  margin-top: 0.2vw;
  font-weight: 400;
  font-size: 0.9vw;
  color: #fff;
}
.nav {
  height: calc(100% - 18vw);
  width: 100%;
  display: flex;
  flex-flow: column wrap;
  justify-content: start;
  align-items: flex-start;
  background: #f1f3f9;
}
.nav .item {
  width: calc(100% - 2vw);
  padding: 0 1vw;
  color: #172b4d;
  height: 3.5vw;
  display: flex;
  align-items: center;
  transition: all 0.1s 0.1s;
  cursor: pointer;
  font-size: 0.9vw;
}
.nav .item .icon {
  font-size: 0.9vw;
  width: 3vw;
}
.nav .item:hover {
  background: #f53c5680;
}
.nav .item.active {
  transition: all 0.1s 0.1s;
  background: #f53c56;
  color: #fff;
  font-weight: 500;
}
</style>

<script>
import { mapGetters } from "vuex";
import { auth } from "../config/auth";
export default {
  data: function() {
    return {
      menu: {
        sitios: {
          item: true,
          active: true
        },
        profile: {
          item: true,
          active: false
        }
      },
      error: null
    };
  },
  computed: {
    ...mapGetters({
      user: "alldata"
    })
  },
  methods: {
    changeSection(index) {
      if (index === 0) {
        this.menu.profile.active = false;
        this.$parent.side.profile = false;
        this.menu.sitios.active = true;
        this.$parent.side.sites = true;
      } else if (index === 1) {
        this.menu.sitios.active = false;
        this.$parent.side.sites = false;
        this.menu.profile.active = true;
        this.$parent.side.profile = true;
      }
    },
    logout: async function() {
      //store.dispatch("fetchUser", user);
      //store.dispatch("fetchAccount", account);
      //store.dispatch("fetchPerson", person);
      await auth.signOut();
      this.$router.push({ path: "/" });
    }
  }
};
</script>
