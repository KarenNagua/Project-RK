<template>
  <div class="profile">
    <div class="card shadow">
      <p class="titulo">Edita tus datos</p>
      <div class="a shadow">
        <p class="subtitulo">Información personal</p>
        <div class="foto shadow">
          <img :src="user.person.data.picture" />
          <input
            ref="input_file"
            type="file"
            id="picture_input"
            class="hide"
            @change="changeUserPicture"
          />
          <font-awesome-icon
            :icon="['fas', 'camera']"
            class="icon"
            @click="$refs.input_file.click()"
          />
        </div>
        <span class="filedname">Nombres</span>
        <input
          type="text"
          placeholder="Nombres"
          v-model="user.person.data.names"
          v-on:keyup.enter="updateUserFiled(0)"
        />
        <span class="filedname">Apellidos</span>
        <input
          type="text"
          placeholder="Nombres"
          v-model="user.person.data.surnames"
          v-on:keyup.enter="updateUserFiled(0)"
        />
        <span class="filedname">Teléfono</span>
        <input
          type="text"
          placeholder="Nombres"
          v-model="user.person.data.cellphone"
          v-on:keyup.enter="updateUserFiled(0)"
        />
        <span class="filedname">Fecha de nacimiento</span>
        <input
          type="text"
          placeholder="Nombres"
          v-model="user.person.data.birthday"
          v-on:keyup.enter="updateUserFiled(0)"
        />
      </div>
      <div class="b shadow">
        <p class="subtitulo">Información de tu cuenta</p>
        <span class="filedname">Correo Principal</span>
        <input
          type="text"
          placeholder="mail@ejemeplo.com"
          v-model="user.account.data.email"
          disabled="true"
        />
        <span class="filedname">Correo de recuperación</span>
        <input
          type="text"
          placeholder="mail@ejemeplo.com"
          v-model="user.account.data.recovery_email"
          v-on:keyup.enter="updateUserFiled(1)"
        />
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
.hide {
  display: none;
}
.profile {
  font-family: "Noto Sans", sans-serif;
  background: #f1f3f9;
  width: 100%;
  height: 100%;
}
.profile .card {
  background: #fff;
  height: calc(100% - 6vw);
  width: calc(100% - 6vw);
  padding: 3vw 3vw;
  display: flex;
  align-items: flex-start;
  justify-content: flex-start;
  flex-flow: row wrap;
}
.profile .card .titulo {
  margin: 0;
  font-weight: 700;
  font-size: 1.6vw;
  width: 100%;
  height: 4vw;
  display: flex;
  align-items: center;
}
.profile .card .a,
.profile .card .b {
  background: #fff;
  width: calc(50% - 16vw);
  padding: 0 8vw;
  height: calc(100% - 4vw);
  display: flex;
  flex-flow: column;
  align-items: center;
  overflow-y: auto;
}
.profile .card .subtitulo {
  font-weight: 700;
  font-size: 1vw;
  margin: 1.5vw 0 1vw 0;
}
.profile .card .a .foto {
  position: relative;
  width: 12vw;
  height: 12vw;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  user-select: none;
  margin-bottom: 1vw;
}
.profile .card .a .foto img {
  width: 100%;
  height: 100%;
  border-radius: 50%;
}
.profile .card .a .foto .icon {
  position: absolute;
  color: #fff;
  font-size: 3vw;
  cursor: pointer;
  z-index: 100;
}
.profile .card .a .foto .icon:active {
  transform: scale(0.96);
}
.profile .card .filedname {
  width: 100%;
  padding: 0.4vw 0;
  font-size: 0.9vw;
  font-weight: 600;
}
.profile .card input {
  width: calc(100% - 1.2vw);
  padding: 0.6vw;
  font-size: 0.8vw;
  outline-color: #f53c56;
  outline-offset: -3px;
  outline-width: 3px;
}
</style>

<script>
import { mapGetters } from "vuex";
import { db } from "../config/db";
import { storage } from "../config/storage";
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
  computed: {
    ...mapGetters({
      user: "alldata"
    })
  },
  methods: {
    updateUserFiled: async function(type) {
      if (type === 0) {
        //person
        await db
          .collection("person")
          .doc(this.user.person.id)
          .set(this.user.person.data);
        this.$store.state.user.person = this.user.person;
      } else if (type == 1) {
        await db
          .collection("account")
          .doc(this.user.account.id)
          .set(this.user.account.data);
        this.$store.state.user.account = this.user.account;
      }
    },
    changeUserPicture: async function(e) {
      let files = e.target.files;
      let ref = storage.ref();
      let name = files[0].name;
      let snapshot = await ref.child("pictures/" + name).put(files[0]);
      let url = await snapshot.ref.getDownloadURL();
      if (url.length > 0) {
        this.user.person.data.picture = url;
        await db
          .collection("person")
          .doc(this.user.person.id)
          .set(this.user.person.data);
        this.$store.state.user.person = this.user.person;
      }
    }
  }
};
</script>
