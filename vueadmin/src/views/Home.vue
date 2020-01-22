<template>
  <div class="caja">
    <img class="as_fondo" src="@/assets/image/a.jpg" />
    <div class="bac_color"></div>
    <div class="intro">
      <div class="centro">
        <span class="a">PROJECTRTK</span>
        <span class="b"
          >Lorem ipsum dolor sit amet consectetur adipisicing elit. Accusamus
          sit aliquam dignissimos dolore facilis quasi nemo error distinctio
          explicabo, harum dolorum, nobis sed. Assumenda accusantium ipsum quo a
          eius voluptates. Lorem ipsum dolor sit amet consectetur adipisicing
          elit. Et, consequuntur quae. Cupiditate eius hic iusto ipsum quidem
          inventore obcaecati debitis fuga illo, consequatur similique magnam ex
          iste aperiam quod repellat.</span
        >
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
  margin-bottom: 0.7vw;
}
.caja .intro .centro span.b {
  font-family: "Noto Sans", sans-serif;
  text-align: left;
  font-size: 1vw;
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
