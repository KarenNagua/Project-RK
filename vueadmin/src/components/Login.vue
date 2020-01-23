<template>
  <div class="login_div">
    <form class="login_form shadow" action="#" @submit.prevent="submit">
      <span class="a">Ingresa tus datos</span>
      <div class="login_bloque">
        <div class="input_div">
          <font-awesome-icon :icon="['fas', 'envelope']" class="icon" />
          <input
            type="email"
            id="email"
            name="email"
            placeholder="ejemplo@email.com"
            required
            autofocus
            v-model="form.email"
          />
        </div>
        <div class="input_div">
          <font-awesome-icon :icon="['fas', 'lock']" class="icon" />
          <input
            type="password"
            id="password"
            name="password"
            placeholder="***********"
            required
            v-model="form.password"
          />
        </div>
      </div>
      <button type="submit" class="shadow">Ingresar</button>
      <span v-if="error" class="error" id="error">{{ error }}</span>
    </form>
  </div>
</template>

<style>
@import url("https://fonts.googleapis.com/css?family=Noto+Sans:400,700&display=swap");

.login_div {
  position: relative;
  z-index: 3;
  width: 40%;
  height: 28vw;
  display: flex;
  align-items: center;
  justify-content: center;
}
.login_div .login_form {
  background: #f7fafc;
  border-radius: 0.45vw;
  width: 55%;
  height: 70%;
  display: flex;
  flex-flow: column;
  justify-content: center;
  align-items: center;
}
.login_div .login_form span.a {
  font-family: "Noto Sans", sans-serif;
  color: #172b4d;
  font-weight: 700;
  display: block;
  font-size: 1.3vw;
  width: 100%;
  text-align: center;
  margin-bottom: 0.5vw;
}
.login_div .login_form .login_bloque {
  width: 72%;
}
.login_div .login_form .login_bloque .input_div {
  background: #fff;
  border-radius: 0.5vw;
  margin: 0.5vw 0;
  display: flex;
  flex-flow: row;
  align-items: center;

  -webkit-box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14),
    0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);
  box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14),
    0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);
}
.login_div .login_form .login_bloque .input_div .icon {
  font-size: 0.95vw;
  width: 2.5vw;
  text-align: center;
  color: #172b4d;
}
.login_div .login_form .login_bloque .input_div input {
  outline: 0;
  width: calc(100% - 2.5vw);
  font-family: "Noto Sans", sans-serif;
  border: none;
  padding: 0.9vw;
  padding-left: 0;
  font-size: 0.75vw;
  border-top-right-radius: 0.5vw;
  border-bottom-right-radius: 0.5vw;
}
.login_div .login_form button {
  font-family: "Noto Sans", sans-serif;
  background: #11cdef;
  border: none;
  border-radius: 0.5vw;
  margin-top: 0.4vw;
  width: 72%;
  padding: 0.7vw 0;
  color: #fff;
  font-weight: 600;
  font-size: 0.8vw;
  cursor: pointer;
  outline: 0;
  transition: all 0.1s 0.1s;
  -webkit-box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14),
    0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);
  box-shadow: 0 2px 2px 0 rgba(0, 0, 0, 0.14),
    0 3px 1px -2px rgba(0, 0, 0, 0.12), 0 1px 5px 0 rgba(0, 0, 0, 0.2);
}
.login_div .login_form button:active {
  transform: scale(0.98);
}
.login_div .login_form .error {
  font-family: "Noto Sans", sans-serif;
  color: red;
  font-size: 0.75vw;
  width: 72%;
  padding: 0.5vw 0;
  text-align: center;
}
</style>

<script>
import { auth } from "../config/auth";
import { db } from "../config/db";

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
    submit: function() {
      auth
        .signInWithEmailAndPassword(this.form.email, this.form.password)
        .then(async user => {
          console.log(user.user.uid);
          let account = await db
            .collection("account")
            .doc(user.user.uid)
            .get();
          console.log(account);
          if (account) {
            if (account.data().state === 0) {
              this.$router.push({ path: "/mainview" });
            } else {
              if (account.data().state === 1) {
                alert(
                  "Error, tu cuenta se encuentra bloqueada, por favor comunicate con el administrador"
                );
              } else {
                alert(
                  "Error, tu cuenta ya no existe, por favor comunicate con el administrador"
                );
              }
              await auth.signOut();
            }
          }
        })
        .catch(err => {
          this.error = err.mesagge;
        });
    }
  }
};
</script>
