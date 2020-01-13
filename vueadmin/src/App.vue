<template>
  <div id="app">
    <div id="nav" class="nav">
      <span class="logotipo">PROJECTRTK</span>
      <div class="menu">
        <router-link class="link" to="/login">Ingresar</router-link>
      </div>
    </div>
    <router-view />
  </div>
</template>

<style>
body {
  margin: 0;
  padding: 0;
}
.shadow {
  -webkit-box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 3px 1px -2px rgba(0,0,0,0.12), 0 1px 5px 0 rgba(0,0,0,0.2);
  box-shadow: 0 2px 2px 0 rgba(0,0,0,0.14), 0 3px 1px -2px rgba(0,0,0,0.12), 0 1px 5px 0 rgba(0,0,0,0.2);
}
#app {
  height: auto;
  width: 100%;
  position: relative;
}
.nav {
  background: #35495d;
  position: fixed;
  padding: 0 10vw;
  top: 0;
  width: calc(100% - 20vw);
  height: 5vw;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.nav .logotipo {
  color: #fff;
  font-size: 1.2vw;
  font-weight: 800;
}
.nav .menu {  
  display: flex;
  flex-flow: row;
  align-items: center;
}
.nav .menu .link {
  text-decoration: none;
  color: #fff;
  font-size: 1vw;
  font-weight: 550;
  cursor: pointer;
  margin-right: 1vw;
}
</style>
