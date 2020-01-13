<template>
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-8">
        <div class="card">
          <div class="card-header">Página principal</div>
          <div class="card-body">            
            <div v-if="user" class="alert alert-success" role="alert">Estas logeado!</div>
            <div v-else class="alert alert-success" role="alert">No estas logeado!</div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style>
.container {
  margin-top: 5vw;
  height: calc(100vh - 5vw);
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
</style>

<script>
import { mapGetters } from "vuex";

export default {
  name: "mainview",
  computed: {
    ...mapGetters({
      user: "user"
    })
  }
};
</script>