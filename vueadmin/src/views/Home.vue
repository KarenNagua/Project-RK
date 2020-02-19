<template>
  <div class="caja">
    <img class="as_fondo" src="@/assets/image/a.jpg" />
    <div class="bac_color"></div>
    <div class="intro">
      <div class="centro">
        <span class="a">Welcome to</span>
        <span class="aa">Project RK</span>
        <span class="b">
          The best way to know, find and discover new places around you. Let's
          start!
        </span>
      </div>
    </div>
    <Login></Login>
  </div>
</template>

<style>
body {
  margin: 0;
  padding: 0;
}
.caja {
  position: relative;
  width: 100%;
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-flow: row;
}
.caja img.as_fondo {
  position: absolute;
  z-index: 1;
  width: 100%;
  height: 100%;
}
.caja .bac_color {
  position: absolute;
  z-index: 2;
  top: 0;
  left: 0;
  width: 100%;
  height: 100vh;
  background: rgba(255, 255, 255, 0.35);
}
.caja .intro {
  position: relative;
  z-index: 3;
  width: 40%;
  height: 28vw;
  display: flex;
  align-items: center;
  justify-content: center;
}
.caja .intro .centro {
  width: 70%;
  height: 80%;
  display: flex;
  flex-flow: column wrap;
  justify-content: center;
}
.caja .intro .centro span {
  font-size: 0.9vw;
  color: #172b4d;
}
.caja .intro .centro span.a {
  font-family: "Noto Sans", sans-serif;
  font-size: 2.5vw;
  font-weight: 700;
  line-height: 2.5vw;
}
.caja .intro .centro span.aa {
  font-family: "Noto Sans", sans-serif;
  font-size: 4.5vw;
  font-weight: 700;
  margin-bottom: 1.3vw;
  line-height: 4.5vw;
}
.caja .intro .centro span.b {
  font-family: "Noto Sans", sans-serif;
  text-align: justify;
  font-size: 1.45vw;
}
</style>

<script>
import Login from "../components/Login";

export default {
  name: "home",
  components: {
    Login
  }
};
</script>
