<template>
  <div class="sites">
    <div class="category">
      <div
        :class="search.bar_class"
        @mouseover="changeStatusSearchVariables(true)"
        @mouseleave="changeStatusSearchVariables(false)"
      >
        <div class="bar">
          <form action="@" @submit.prevent="submitSearchForm">
            <input
              type="text"
              placeholder="Ingresa un nombre para buscar"
              :keyup="submitSearchForm"
              @keyup="submitSearchForm"
              v-model="search.query"
            />
            <font-awesome-icon :icon="['fas', 'search']" class="icon b" />
          </form>
        </div>
      </div>
      <div
        :class="search.category_class"
        @mouseover="changeStatusSearchVariables(true)"
        @mouseleave="changeStatusSearchVariables(false)"
      >
        <span>Filtrar por categoría</span>
        <select ref="select_category" @change="submitSearchForm">
          <option value="*_todas">Todas las categorías</option>
          <option
            :key="c.id"
            v-for="c in data.categories"
            :value="c.id + '_' + c.data.label"
            >{{ c.data.label }}</option
          >
        </select>
      </div>
    </div>
    <div class="map" id="map">
      <gmap-map
        :center="map.center"
        :zoom="map.zoom"
        style="width:100%;height:100%;"
      >
        <gmap-marker
          :key="m.key"
          :id="'marker_' + m.key"
          v-for="m in map.markers"
          :position="m.position"
          @click="showInfoSite(m.site)"
          ref="marker"
        ></gmap-marker>
      </gmap-map>
    </div>
    <div :class="map.site_class">
      <div v-if="map.current_site" class="bar">
        <span>{{ map.current_site.site.data.label }}</span>
        <font-awesome-icon
          :icon="['fas', 'times']"
          class="icon"
          @click="closeInfoSite()"
        />
      </div>
      <div v-if="map.current_site" class="info">
        <p class="titulo">
          Descripción
        </p>
        <p class="normal">
          {{ map.current_site.site.data.description }}
        </p>
        <p class="titulo">
          Categoría
        </p>
        <p class="normal">
          {{ map.current_site.category.data.label }}
        </p>
        <p class="titulo">
          Información de contácto
        </p>
        <div class="fila">
          <p class="subtitulo">
            Calle principal:
          </p>
          <p class="subnormal">
            {{ map.current_site.site.data.address.main }}
          </p>
        </div>
        <div class="fila">
          <p class="subtitulo">
            Calle secundaria:
          </p>
          <p class="subnormal">
            {{ map.current_site.site.data.address.secondary }}
          </p>
        </div>
        <div class="fila">
          <p class="subtitulo">
            Referencia:
          </p>
          <p class="subnormal">
            {{ map.current_site.site.data.address.reference }}
          </p>
        </div>
      </div>
    </div>
    <div :class="btn_favorites" @click="showOnlyFavoritesSites">
      <font-awesome-icon :icon="['fas', 'heart']" class="icon" />
    </div>
    <div class="slider">
      <div :key="s.id" v-for="s in data.sites" class="site shadow" :id="s.id">
        <div class="card">
          <div class="name">
            <span>{{ s.data.label }}</span>
            <font-awesome-icon
              v-if="s.is_favorite"
              :icon="['fas', 'heart']"
              class="icon"
              @click="removeSiteToFavorites(s)"
            />
            <font-awesome-icon
              v-else
              :icon="['far', 'heart']"
              class="icon"
              @click="addSiteToFavorites(s)"
            />
          </div>
          <div class="actions">
            <div class="button a" @click="locateSite(s.id)">
              <font-awesome-icon
                :icon="['fas', 'location-arrow']"
                class="icon"
              />
              Ubicar
            </div>
            <div class="button b" @click="showInfoSite(s)">
              <font-awesome-icon :icon="['fas', 'info-circle']" class="icon" />
              Info
            </div>
          </div>
        </div>
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
.sites {
  font-family: "Noto Sans", sans-serif;
  position: relative;
  width: 100%;
  height: 100%;
  background: #fff;
}
.sites .category {
  position: absolute;
  z-index: 150;
  width: 35vw;
  left: calc(50% - 17.5vw);
  top: 1vw;
  height: 3vw;
}
.sites .category .fila {
  width: calc(100% - 1.6vw);
  background: #fff;
  padding: 0 0.8vw;
}
.sites .category .fila.barra {
  height: 120%;
  max-height: 100%;
  background: #fff;
  transition: all 0.2s 0.2s;
}
.sites .category .fila.barra.focused {
  max-height: 120%;
  background: #fff;
  transition: all 0.2s 0.2s;
}
.sites .category .fila.barra .bar {
  width: 100%;
  height: 100%;
  display: flex;
  flex-flow: row;
  align-items: center;
  align-content: space-between;
}
.sites .category .fila.barra form {
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.sites .category .fila.barra form input {
  background: #fff;
  width: calc(100% - 3.5vw);
  border: none;
  height: 2.4vw;
  padding: 0 1vw;
  font-size: 0.9vw;
  outline: 0;
  transition: all 0.2s 0.2s;
}
.sites .category .fila.barra.focused .bar input {
  border: 1px solid #00000030;
  transition: all 0.2s 0.2s;
}
.sites .category .fila.barra form .icon.b {
  width: 3.5vw;
  font-size: 1.2vw;
}
.sites .category .fila.cate {
  position: relative;
  height: 100%;
  max-height: 0;
  display: flex;
  align-items: center;
  justify-content: space-around;
  opacity: 0;
  z-index: -1;
  transition: all 0.2s 0.2s;
}
.sites .category .fila.cate.focused {
  background: #fff;
  max-height: 100%;
  opacity: 1;
  z-index: 1;
  transition: all 0.2s 0.2s;
}
.sites .category .fila.cate span {
  width: 10vw;
  font-size: 0.9vw;
  font-weight: 600;
  text-align: left;
  color: #f53c56;
}
.sites .category .fila.cate select {
  width: calc(100% - 10vw);
  background: #fff;
  border: none;
  font-size: 0.9vw;
  outline: 0;
  cursor: pointer;
}
.sites .category .fila.lista {
  max-height: 0;
  position: relative;
  opacity: 0;
  z-index: -1;
  transition: all 0.2s 0.2s;
}
.sites .category .fila.lista.focused {
  max-height: 100%;
  background: #f2f2f2;
  opacity: 1;
  z-index: 1;
  transition: all 0.2s 0.2s;
}
.sites .category .fila.lista.has_results {
  height: 12vw;
  overflow-y: auto;
}
.sites .map {
  z-index: 1;
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}
.slider {
  position: absolute;
  z-index: 4;
  background: rgba(255, 255, 255, 0.45);
  bottom: 0;
  width: calc(100% - 4vw);
  overflow-x: auto;
  white-space: nowrap;
  overflow-y: hidden;
  height: 8.5vw;
  padding: 2vw 2vw;
  user-select: none;
}
.btn_favoritos {
  position: absolute;
  z-index: 200;
  bottom: 11.2vw;
  left: 1vw;
  width: 2vw;
  height: 2vw;
  font-size: 0.9vw;
  background: #000;
  color: #fff;
  border-radius: 0.5vw;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.2s 0.2s;
}
.btn_favoritos:active {
  transform: scale(0.90);
}
.btn_favoritos.active {
  background: #f53c56;
  transition: all 0.2s 0.2s;
}
.btn_favoritos .icon {

}
.slider .site {
  position: relative;
  background: #fff;
  width: auto;
  height: 8.5vw;
  margin: 0 1vw;
  display: -webkit-inline-box;
  display: -ms-inline-flexbox;
  display: inline-flex;
}
.slider .site .card {
  width: 100%;
  display: flex;
  flex-flow: column;
  padding: 0 0.5vw;
}

.slider .site .card .name {
  width: calc(100% - 2vw);
  height: 50%;
  padding: 0 1vw;
  display: flex;
  align-items: center;
  justify-content: center;
  white-space: normal;
  color: #172b4d;
}
.slider .site .card .name span {
  font-size: 1.1vw;
  font-weight: 600;
}
.slider .site .card .name .icon {
  margin-left: 1vw;
  font-size: 1.1vw;
  cursor: pointer;
  color: #f53c56;
}
.slider .site .card .name .icon:active {
  transform: scale(0.96);
}
.slider .site .card .actions {
  height: 50%;
  display: flex;
  flex-flow: row;
  align-items: center;
  justify-content: space-around;
}
.slider .site .card .actions .button {
  padding: 0.6vw 0;
  width: 5.5vw;
  margin: 0 0.5vw;
  border-radius: 0.8vw;
  color: #f3f3f3;
  font-size: 0.85vw;
  display: flex;
  flex-flow: row;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}
.slider .site .card .actions .button:active {
  transform: scale(0.96);
}
.slider .site .card .actions .button.a {
  background: #f53c56;
}
.slider .site .card .actions .button.b {
  background: #f53c56;
}
.slider .site .card .actions .button .icon {
  margin-right: 0.4vw;
}
.info_site {
  position: absolute;
  background: #fff;
  z-index: 100;
  width: 24vw;
  height: 25vw;
  right: 1vw;
  top: 6vw;
  user-select: none;

  opacity: 0;
  z-index: -1;
  transition: all 0.2s 0.2s;
}
.info_site.active {
  opacity: 1;
  z-index: 100;
  transition: all 0.2s 0.2s;
}
.info_site .bar {
  position: absolute;
  height: 3.5vw;
  width: calc(100% - 4vw);
  background: #172b4d;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 2vw;
}
.info_site .bar span {
  color: #fff;
  font-weight: 700;
}
.info_site .bar .icon {
  color: #fff;
  cursor: pointer;
}
.info_site .bar .icon:active {
  transform: scale(0.96);
}
.info_site .info {
  width: calc(100% - 4vw);
  height: calc(100% - 3.5vw);
  position: absolute;
  top: 3.5vw;
  padding: 0 2vw;
  overflow: auto;
}
.info_site .info .titulo {
  font-size: 1vw;
  font-weight: 600;
  margin: 0;
  padding: 1vw 0;
}
.info_site .info .normal {
  font-size: 0.9vw;
  text-align: justify;
  margin: 0;
  padding: 0.3vw 0;
}
.info_site .info .fila {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  margin-bottom: 0.5vw;
}
.info_site .info .subtitulo {
  font-weight: 600;
  font-size: 0.8vw;
  width: 8vw;
  margin: 0;
}
.info_site .info .subnormal {
  margin: 0;
  width: calc(100% - 8vw);
  font-size: 0.8vw;
}
</style>

<script>
import { firebase } from "../config/app";
import { db } from "../config/db";
import { mapGetters } from "vuex";
export default {
  data: function() {
    return {
      data: {
        user: null,
        categories: [],
        sites: [],
        sites_copy: [],
        favorites: []
      },
      btn_favorites: {
        btn_favoritos: true,
        shadow: true,
        active: false
      },
      map: {
        zoom: 14,
        center: { lat: 45.508, lng: -73.587 },
        markers: [],
        places: [],
        currentPlace: null,
        user_position: null,
        info_open: false,
        current_site: null,
        site_class: {
          info_site: true,
          shadow: true,
          active: false
        }
      },
      search: {
        query: "",
        bar_class: {
          fila: true,
          barra: true,
          shadow: true,
          focused: false
        },
        category_class: {
          fila: true,
          cate: true,
          shadow: true,
          focused: false
        }
      },
      error: null
    };
  },
  created() {
    this.data.user = this.$store.state.user.data;
    this.geolocate();
    this.getFavorites();
    this.getCategories();
    this.getSites();
  },
  methods: {
    setPlace(place) {
      this.currentPlace = place;
    },
    addMarker() {
      if (this.currentPlace) {
        const marker = {
          lat: this.currentPlace.geometry.location.lat(),
          lng: this.currentPlace.geometry.location.lng()
        };
        this.markers.push({ position: marker });
        this.places.push(this.currentPlace);
        this.center = marker;
        this.currentPlace = null;
      }
    },
    getMarkerFromRefWithID(id) {
      let marker = null;
      this.$refs.marker.forEach(m => {
        let id_site = "marker_" + id;
        if (id_site === m.$attrs.id) {
          marker = m;
        }
      });
      return marker;
    },
    getMarkerFromDataWithID(id) {
      let marker = null;
      this.map.markers.forEach(m => {
        if (id === m.key) {
          marker = m;
        }
      });
      return marker;
    },
    getCategoryFromId(id) {
      let category = null;
      this.data.categories.forEach(c => {
        if (c.id === id) {
          category = c;
        }
      });
      return category;
    },
    showInfoSite(s) {
      this.map.current_site = {
        site: s,
        category: this.getCategoryFromId(s.data.id_category)
      };
      this.map.site_class.active = true;
    },
    closeInfoSite() {
      this.map.site_class.active = false;
    },
    locateSite(id) {
      let marker = this.getMarkerFromDataWithID(id);
      this.map.center = marker.position;
      this.map.zoom = 17;
    },
    getSitesByCategory(category) {
      let data = [];
      if (category.id !== "*") {
        this.data.sites_copy.forEach(s => {
          if (s.data.id_category === category.id) {
            data.push(s);
          }
        });
      } else {
        data = this.data.sites_copy;
      }
      return data;
    },
    filterSitesByLabelCoincidence(aux) {
      let data = [];
      aux.forEach(s => {
        let q = this.search.query.toLowerCase();
        let l = s.data.label.toLowerCase();
        if (l.includes(q)) {
          data.push(s);
        }
      });
      return data;
    },
    submitSearchForm() {
      this.btn_favorites.active = false;
      let data = this.getSitesByCategory({
        id: this.$refs.select_category.value.split("_")[0],
        label: this.$refs.select_category.value.split("_")[1]
      });
      if (this.search.query.length > 0) {
        data = this.filterSitesByLabelCoincidence(data);
      }
      this.data.sites = data;
    },
    changeStatusSearchVariables(status) {
      this.search.bar_class.focused = status;
      this.search.category_class.focused = status;
    },
    changeSiteFavoriteStatus(id, status) {
      this.data.sites_copy.forEach(s => {
        if (s.id === id) {
          s.is_favorite = status;
        }
      });
      this.data.sites.forEach(s => {
        if (s.id === id) {
          s.is_favorite = status;
        }
      });
    },
    checkSiteFavoriteStatus(id) {
      let status = false;
      this.data.favorites.forEach(f => {
        if (f.data.id_site === id) {
          status = true;
        }
      });
      return status;
    },
    getFavoriteWithSiteId(id) {
      let favorite = null;
      this.data.favorites.forEach(f => {
        if (f.data.id_site === id) {
          favorite = f;
        }
      });
      return favorite;
    },
    deleteItemFromFavoriteList({ id, data }) {
      let index = -1;
      this.data.favorites.forEach((f, i) => { 
        if (f.id === id) {
          index = i;
        }
      });
      if (index !== -1) {
        this.data.favorites.splice(index, 1);
      }

      if (this.btn_favorites.active) {
        let index = -1;
        this.data.sites.forEach((s, i) => {
          if (s.id === data.id_site) {
            index = i;
          }
        });
        if (index != -1) {
          this.data.sites.splice(index, 1);
        }
      }
    },
    showOnlyFavoritesSites() {
      if (this.btn_favorites.active) {
        this.btn_favorites.active = false;
        this.data.sites = this.data.sites_copy;
      } else {
        let data = [];
        this.data.sites_copy.forEach(s => {
          let f = this.getFavoriteWithSiteId(s.id);
          if (f !== null) {
            data.push(s);
          }
        });
        this.btn_favorites.active = true;
        this.data.sites = data;
      }
    },
    addSiteToFavorites: async function({ id }) {
      let favorite = {
        id_site: id,
        id_account: this.user.account.id,
        id_person: this.user.person.id,
        register_date: firebase.serverTimestamp
      };
      let docref = await db.collection("mysites").add(favorite);
      let doc = await db
        .collection("mysites")
        .doc(docref.id)
        .get();
      this.data.favorites.push({
        id: doc.id,
        data: doc.data()
      });
      this.changeSiteFavoriteStatus(id, true);
    },
    removeSiteToFavorites: async function({ id }) {
      let favorite = this.getFavoriteWithSiteId(id);
      await db
        .collection("mysites")
        .doc(favorite.id)
        .delete();
      this.deleteItemFromFavoriteList(favorite);
      this.changeSiteFavoriteStatus(id, false);
    },
    geolocate: function() {
      navigator.geolocation.getCurrentPosition(position => {
        this.map.center = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
        this.map.user_position = position.coords;
      });
    },
    getFavorites: async function() {
      let data = await db
        .collection("mysites")
        .where("id_account", "==", this.user.account.id)
        .get();
      data.forEach(f => {
        this.data.favorites.push({
          id: f.id,
          data: f.data()
        });
      });
    },
    getCategories: async function() {
      let data = await db
        .collection("category")
        .orderBy("register_date")
        .get();
      data.forEach(c => {
        this.data.categories.push({
          id: c.id,
          data: c.data()
        });
      });
    },
    getSites: async function() {
      let data = await db
        .collection("site")
        .where("estado", "==", 0)
        .get();
      data.docs.forEach(site => {
        this.data.sites.push({
          id: site.id,
          data: site.data(),
          is_favorite: this.checkSiteFavoriteStatus(site.id) //Check favorite
        });
        const marker = {
          lat: site.data().coordinates.lat,
          lng: site.data().coordinates.lng
        };
        this.map.markers.push({
          key: site.id,
          position: marker,
          site: {
            id: site.id,
            data: site.data()
          }
        });
      });
      this.data.sites_copy = this.data.sites;
    }
  },
  computed: {
    ...mapGetters({
      user: "alldata"
    })
  }
};
</script>
