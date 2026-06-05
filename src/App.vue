<script setup>
import { RouterView } from 'vue-router';
import Header from './Component/Header.vue';
</script>

<template>
  <div style="background-color: #1E1E2F;">
      <Header></Header>
      <main>
        <RouterView />
      </main>
  </div>
</template>

<style scoped>
*{
  padding: 0;
  margin: 0;
}
</style>
