<template>
  <div class="login_div">
    <form class="login_form shadow" action="#" @submit.prevent="submit">
      <h4>Iniciar sesión</h4>
      <div class="login_bloque">
        <span>Usuario:</span>
        <input
          type="email"
          id="email"
          name="email"
          placeholder="ejemplo@email.com"
          required
          autofocus
          v-model="form.email"
        />
        <span>Contraseña:</span>
        <input
          type="password"
          id="password"
          name="password"
          placeholder="***********"
          required
          v-model="form.password"
        />
      </div>
      <button type="submit" class="shadow">Ingresar</button>
      <div v-if="error" class="error" id="error">{{ error }}</div>
    </form>
  </div>
</template>

<style>
.login_div {
  width: 100%;
  height: calc(100vh - 5vw);
  margin-top: 5vw;
  display: flex;
  align-items: center;
  justify-content: center;
}
.login_div .login_form {
  background: #fff;
  border-radius: 1.2vw;
  width: 30vw;
  height: 26vw;
  display: flex;
  flex-flow: column;
  justify-content: center;
  align-items: center;
}
.login_div .login_form h4 {
  font-weight: 800;
  display: block;
  font-size: 2.2vw;
  width: 100%;
  text-align: center;
  margin: 0;
}
.login_div .login_form .login_bloque {
  width: 70%;
}
.login_div .login_form .login_bloque span {
  display: block;
  font-weight: 600;
  font-size: 1vw;
  margin: 1vw;
}
.login_div .login_form .login_bloque input {
  display: block;
  width: calc(100% - 2vw);
  background: #e3e3e3;
  border-radius: 0.8vw;
  border: none;
  padding: 1vw;
  outline: 0;
}
.login_div .login_form button {
  background: #35495d;
  border: none;
  border-radius: 0.8vw;
  margin-top: 1.5vw;
  width: 70%;
  padding: 1vw 0;
  color: #fff;
  font-weight: 600;
  font-size: 0.9vw;
  cursor: pointer;
  outline: 0;
  transition: all 0.1s 0.1s;
}
.login_div .login_form button:active {
  transform: scale(0.98);
}
.login_div .login_form .error {
  color: red;
  font-size: .09vw;
}
</style>

<script>
import firebase from "firebase";

export default {
  data() {
    return {
      form: {
        email: "",
        password: ""
      },
      error: null
    };
  },
  methods: {
    submit() {
      firebase
        .auth()
        .signInWithEmailAndPassword(this.form.email, this.form.password)
        .then(data => {
          console.log(data);
          this.$router.replace({ name: "mainview" });
        })
        .catch(err => {
          console.log(err);
          this.error = err.message;
        });
    }
  }
};
</script>
