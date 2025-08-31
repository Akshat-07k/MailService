<template>
  <div class="container">
    <div class="left">
      <img :src="flower" alt="flower" height="400px">
    </div>
    <div class="right">
      <div class="card">
          
      </div>
      <div class="card"> 

      </div>
    </div>
  </div>
</template>

<script setup>
import flower from '@/assets/flower-Photoroom.png'
</script>

<style scoped>
.container {
  display: flex;
  background-color: transparent;
  min-height: 88vh;
  padding: 20px;
}

.left {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
}

.right {
  flex: 2;
  display: flex;
  flex-direction: column;
  gap: 20px; /* space between cards */
  justify-content: center;
}

.card {
  background: #2D2D44;
  border-radius: 12px;
  padding: 20px;
  box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
  min-height: 150px;
  width: 400px;
  margin: auto;
}
</style>
