<template>
    <nav class="navClass">
        <RouterLink to="/" class="custom-link">Home</RouterLink>
        <RouterLink to="/create-mail" class="custom-link">Create Mail</RouterLink>
        <RouterLink to="/AI" class="custom-link">AI</RouterLink>
    </nav>
</template>

<script setup>
import { RouterLink , useRoute } from 'vue-router';


</script>


<style scoped>
.navClass{
    display: flex;
    gap: 20px;
    padding: 10px 20px;
    background-color: #2D2D44;
    font-family: Arial;
    color: wheat;
}
/* styles.css or <style> block in your component */
.custom-link {
  color: wheat;
  font-weight: bold;
  text-decoration: none;
}

.custom-link:hover {
  text-decoration: underline;
}

</style>