<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<script>
import axios from 'axios'
import json from './assets/data/data.json'
import {initializeRating} from './assets/script/rating.js'
const STORAGE_KEY = 'fahm-json'

window.log = ''
if (!console._log_old) {
  console._log_old = console.log
  console.log = function (msg) {
    console._log_old(msg)
    window.log += Date() + ' ' + msg + '<br>'
  }
  console.error = console.log
}

export default {
  name: 'App',
  methods: {
    onDeviceReady: function () {
      console.log('device ready')

      document.removeEventListener('deviceready', this.onDeviceReady)

      // define backbutton functionality
      document.addEventListener('backbutton', this.onBackKeyDown, false)

      initializeRating()

      console.log('plugins loaded')

      console.log(JSON.stringify(window.plugins))

      console.log(JSON.strigify(window.cordova.plugins))
    },
    onBackKeyDown: function (e) {
      e.preventDefault()
      console.log('pressed backbutton')
      let back = document.getElementById('back')
      if (back && back.getAttribute('class') !== 'disabled') {
        back.click()
      } else {
        // Exit app
        if (navigator.app) {
          navigator.app.exitApp()
        } else if (navigator.device) {
          navigator.device.exitApp()
        } else {
          window.close()
        }
      }
    }
  },
  mounted () {
    let localStorage = window.localStorage
    let data = JSON.parse(localStorage.getItem(STORAGE_KEY)) || json

    this.$store.commit('setData', data)

    let _self = this
    // Try to load remote data, save it on local
    axios.get('https://raw.githubusercontent.com/LibreAppFoundation/fahm/master/src/assets/data/data.json').then(function (response) {
      _self.$store.commit('setData', response.data)
      localStorage.setItem(STORAGE_KEY, JSON.stringify(response.data))
    }).catch(function (err) {
      console.log(err)
    })

    // load scripts
    let script = document.createElement('script')
    script.setAttribute('src', 'cordova.js')
    document.head.appendChild(script)

    document.addEventListener('deviceready', this.onDeviceReady)
  }
}

</script>

<style>
:root {
  --primary-color: #0084b4;
}
html {
  background: #f5f5f5;
}
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
}
h1, h2 {
  font-weight: normal;
  margin-bottom: 0;
}
h2 {
  margin-top: 0;
  font-size: 1.2rem;
  text-transform: uppercase;
}
a {
  color: black;
  text-decoration: none;
}
body {
  max-width: 720px;
  margin: auto;
}
.nav {
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  padding: 1em .5em;
  background: var(--primary-color);
  color: white;
  text-align: left;
  box-shadow: 1px 1px 1px rgba(0, 0, 0, .5);
  z-index: 1
}
.icon {
  vertical-align: middle;
  margin-right: .5em;
  padding-right: .5em;
  border-right: 1px solid rgba(0, 0, 0, .2)
}
.nav a {
  color: white;
  display: table-cell;
  vertical-align: middle;
}
.nav h2 {
  display: table-cell;
  vertical-align: bottom;
}
.external {
  background: var(--primary-color);
  padding: 1rem;
  color: white;
  display: block;
  margin-top: 5vh
}
.external img {
  vertical-align: middle;
}
.link {
  color: var(--primary-color);
  text-decoration: underline;
}
</style>
