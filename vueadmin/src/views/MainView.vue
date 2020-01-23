<template>
  <div class="boxes">
    <div class="box a">
      <Sidenav></Sidenav>
    </div>
    <div class="box b">
      <Sites v-if="side.sites"></Sites>
      <Profile v-else-if="side.profile"></Profile>
    </div>
  </div>
</template>

<style>
.boxes {
  background: #fff;
  position: relative;
  width: 100%;
  height: 100vh;
  display: flex;
  flex-flow: row;
}
.box.a {
  width: 19%;
  height: 100vh;
}
.box.b {
  background: #fff;
  width: 81%;
  height: 100vh;
}
</style>

<script>
import Sidenav from "../components/Sidenav";
import Sites from "../components/Sites";
import Profile from "../components/Profile";

export default {
  name: "mainview",
  data: function() {
    return {
      side: {
        sites: true,
        profile: false
      }
    };
  },
  components: {
    Sidenav,
    Sites,
    Profile
  }
};
</script>
