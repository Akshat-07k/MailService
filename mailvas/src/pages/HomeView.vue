<template>
  <div style="padding: 20px; font-family: Arial;color: wheat;min-height:91vh;">
    <h1>Gemini <s >AI</s> API </h1>
    <input type="text" v-model="promptText" class="promptInput"><br>
    <button @click="generateText" style="padding: 10px 20px; cursor: pointer;">
      ask API
    </button>
    <div v-if="loaderVar" style="margin-top: 20px;margin-left: 20px;">
      <loader></loader>
    </div>    
    <div style="margin-top: 20px; white-space: pre-wrap;">
      {{ response || "" }}
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";
import { GoogleGenerativeAI } from "@google/generative-ai"; // legacy 
import { GoogleGenAI } from "@google/genai";    // recommended
import loader from "@/Component/loader.vue";

const loaderVar = ref(false);  //

const ai = new GoogleGenAI({ apiKey: "AIzaSyCoc3Ehpb84gzPmH_6Jxw7qceIkDAIP4lQ" });

const API_KEY = "AIzaSyCoc3Ehpb84gzPmH_6Jxw7qceIkDAIP4lQ";
const genAI = new GoogleGenerativeAI("AIzaSyCoc3Ehpb84gzPmH_6Jxw7qceIkDAIP4lQ");

const promptText = ref("Create a simple .....");

const response = ref("");

// const generateText = async () => {
//   try {
//     const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" }); // 'gemini-pro' 
//     const result = await model.generateContent(promptText.value);
//     const text = result.response.text();
//     response.value = text;
//     console.log(text);
//   } catch (error) {
//     console.error("Error generating text:", error);
//     response.value = "Error: " + error.message;
//   }
// };
const generateText = async () => {
  try {
    loaderVar.value = true;
    const result = await ai.models.generateContent({
        model: "gemini-2.5-flash",
        contents: [
            { type: "text", text: promptText.value }
        ]
    });
    const text = result.text;
    response.value = text;
    console.log(text);
    loaderVar.value = false;
  } catch (error) {
    console.error("Error generating text:", error);
    response.value = "Error: " + error.message;
  }
};

</script>

<style scoped>
button {
  background-color: #42b883;
  color: white;
  border: none;
  border-radius: 6px;
}
.promptInput{
    width: 300px;
    padding: 10px;
    margin-top: 10px;
    margin-bottom: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
}
</style>
