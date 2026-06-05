<template>
    <input type="text" v-model="promptText" class="promptInput" placeholder="Prompt here"/><br>
    <button @click="main()">Ask Ai</button>
    <loader v-if="loaderVar"/>
    <div v-html="response"></div>
</template>

<script setup>
import Groq from "groq-sdk";
import { ref } from "vue";
import { marked } from "marked";
import loader from "./loader.vue";

const groq = new Groq({ apiKey: import.meta.env.VITE_GROQ_API_KEY ,dangerouslyAllowBrowser: true });
const promptText = ref('');
const response = ref('');
const loaderVar = ref(false);

 async function main() {
  loaderVar.value=true;
  response.value='';
  
  const completion = await getGroqChatCompletion();
  console.log(completion);
  response.value = marked.parse(completion.choices[0]?.message?.content || "");
  
  loaderVar.value=false;
}

 const getGroqChatCompletion = async () => {
  return groq.chat.completions.create({
    messages: [

      {
        role: "system",
        content: "You are a helpful assistant.",
      },
      {
        role: "user",
        content: promptText.value,
      },
    ],
    model: "openai/gpt-oss-20b",
  });
};
</script>

<style scoped>

button {
  background-color: #42b883;
  color: white;
  border: none;
  border-radius: 6px;
  padding: 10px 20px; 
  cursor: pointer;
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

</style>