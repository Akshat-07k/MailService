<template>

  <div style="padding: 20px; font-family: Arial;color: wheat;min-height:91vh;">
    <h1>
        <select name="AI" id="AI" v-model="selectedAI">
            <option value="gemini">Gemini </option>
            <option value="groq">Groq</option>
        </select>
        
        <s >AI</s> API </h1>
    
    <chat v-if="selectedAI==='gemini'"/>

    <chat2 v-if="selectedAI==='groq'"/>

  </div>

</template>

<script setup>
    import { ref } from "vue";
    import chat from "@/Component/chat.vue";
    import chat2 from "@/Component/chat2.vue";

    const selectedAI = ref("gemini")

</script>

<style scoped>
 select{
    background-color:transparent;
    color: wheat;
    font-size: 32px;
    font-weight: bold;
    border: none;
    margin-right: 3%;
}
option{
    color: black;

}

</style>