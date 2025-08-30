<template>
    <input type="text" v-model="promptText" class="promptInput">
    <input type="file" @change="handleFileChange" class="promptInput"/> <br/>
    <button @click="generateText" style="padding: 10px 20px; cursor: pointer;">
      ask API
    </button>
    <div v-if="loaderVar" style="margin-top: 20px;margin-left: 20px;">
      <loader></loader>
    </div>    
    <!-- <div style="margin-top: 20px; white-space: pre-wrap;">
      {{ response || "" }}
    </div> -->
      <div v-html="response"></div>

</template>

<script setup>
import { ref } from "vue";
// import { GoogleGenerativeAI } from "@google/generative-ai"; // legacy 
import { GoogleGenAI } from "@google/genai";    // recommended
import loader from "@/Component/loader.vue";
import { marked } from "marked";

const loaderVar = ref(false);  
const ai = new GoogleGenAI({ apiKey: "AIzaSyCoc3Ehpb84gzPmH_6Jxw7qceIkDAIP4lQ" });

const API_KEY = "AIzaSyCoc3Ehpb84gzPmH_6Jxw7qceIkDAIP4lQ";
// const genAI = new GoogleGenerativeAI("AIzaSyCoc3Ehpb84gzPmH_6Jxw7qceIkDAIP4lQ");

const promptText = ref("Create a simple .....");
const response = ref("");
const imageData = ref(null);
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

    const parts = [
      { text: promptText.value }
    ];

    if (imageData.value) {
      parts.push({
        inlineData: {
          mimeType: "image/jpeg",
          data: imageData.value
        }
      });
    }

    const result = await ai.models.generateContent({
        "model": "gemini-2.5-flash",
        // contents: [
        //     { type: "text", text: promptText.value }
        // ]
        contents: [
            {
              parts: parts
            }
          ],
    });
    const text = result.text;
    response.value = marked.parse(text);
    console.log(response.value)
    // console.log(text);
    loaderVar.value = false;
  } catch (error) {
    console.error("Error generating text:", error);
    response.value = "Error: " + error.message;
    loaderVar.value = false;
  }
};
const handleFileChange = async(event)=>{
  const response =  new Promise((resolve, reject)=>{
    const file = event.target.files[0];
    if(!file) return resolve(null);

    const reader = new FileReader();
    reader.readAsDataURL(file);

    reader.onload = ()=>{
      const base64String = reader.result.split(",")[1];
      resolve(base64String);
    }
    reader.onerror = (error)=>reject(error)
  })

  imageData.value = await response;
  console.log(imageData)

}
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
    margin-right:10px;
}
pre {
  background-color: lightgray;
  padding: 15px; /* Use a larger padding for a better visual effect */
  border-radius: 4px;
}
</style>