<template>
  <div class="boxes">
    <div class="box a">
      <Sidenav></Sidenav>
    </div>
    <div class="box b">
      <Sites></Sites>
    </div>
  </div>
</template>

<style>
.boxes {
  background: red;
  position: relative;
  width: 100%;
  height: 100vh;
  display: flex;
  flex-flow: row;
}
.box.a {
  background: blue;
  width: 19%;
  height: 100vh;
}
.box.b {
  background: green;
  width: 81%;
  height: 100vh;
}
</style>

<script>
import Sidenav from "../components/Sidenav";
import Sites from "../components/Sites";

export default {
  name: "mainview",
  components: {
    Sidenav,
    Sites
  }
};
</script>
