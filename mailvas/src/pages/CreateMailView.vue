<template>
    <div>
        <div class="container">
            <div class="board1" >
                <!-- <button 
                    @click="displayContentList = !displayContentList"
                    style="padding: 10px 20px; background-color: #08CB00;border: none;border-radius: 1rem;cursor: pointer;"
                    >Components</button> -->
                <br><br>
                <ComponentPalette
                v-if="displayContentList"
                :componentList="componentList"
                :clone-item="cloneItem"
                />
            </div>
            <div class="board2">
                <Board
                    v-model:canvasElement="canvasElement"
                    :getComponentProps="getComponentProps"
                    :handleComponentClick="handleComponentClick"
                />

            </div>
        </div>

            <div class="stylingBox">
                <div class="actions">
                    <button @click="exportJSON">Export JSON</button>
                    <button @click="exportHTML">Export HTML</button>
                </div>

                <!-- Container for styling + board -->
                <div class="container">
                    <!-- CSS Editor -->
                    <div class="components2" v-if="selectedComponent !== null">
                        <h3>Edit Styles</h3>
                        <textarea
                            name="styleText"
                            cols="30"
                            rows="15"
                            v-model="componentStyles"
                            placeholder="Write CSS for the selected component..."
                        ></textarea>
                    </div>

                    <!-- Content Editor -->
                    <div class="board" v-if="selectedComponent !== null">
                        <h3>Edit Content</h3>
                        <!-- For div or button -->
                        <textarea
                            v-if="canvasElementType() === 'div' || canvasElementType() === 'button'"
                            cols="100"
                            rows="10"
                            id="textContent"
                            v-model="canvasTextElement"
                            placeholder="Enter text content..."
                        ></textarea>

                        <!-- For image -->
                        <textarea
                            v-if="canvasElementType() === 'img'"
                            cols="40"
                            rows="3"
                            id="textContent"
                            v-model="imageElement"
                            placeholder="Enter image URL..."
                        ></textarea>
                    </div>
                </div>
            </div>

    </div>
</template>

<script setup>
import { computed, nextTick, ref,watch } from 'vue';
import { VueDraggable } from 'vue-draggable-plus';  
import ComponentPalette from '@/Component/ComponentPalette.vue';
import Board from '@/Component/board.vue';

const displayContentList = ref(true);

const selectedComponent = ref(null);
const canvasIndex = ref(-1);

// const canvasIndex = () => {
//     return canvasElement.value.findIndex(c => c.id === selectedComponent.value);
// };

watch(selectedComponent, (newValue) => {
        canvasIndex.value = canvasElement.value.findIndex(c => c.id === newValue);

}, { deep: true });

const canvasElementType = ()=>{
    return  canvasIndex.value!==-1 && canvasElement.value[canvasIndex.value]?.type || null;
}

const componentList = ref([
    {
        id: 1,
        type: 'button',
        text: 'Button',
        cellpadding:10,
        style: {
            backgroundColor: '#4CAF50',
            color: 'white',
            border: 'none',
            borderRadius: '5px',
            cursor: 'pointer'
        },
        action: function() {
            console.log(this.id)
            selectedComponent.value = this.id;
        }
    },
    {
        id: 2,
        type: 'div',  
        text: 'Text Box', 
        style: {
            padding: '8px',
            borderRadius: '4px',
            border: '1px solid #ccc',
            width: '90%',
            marginTop: '10px',
            minHeight: '10px',
            whiteSpace: 'pre-wrap', 
            cursor: 'pointer',
            color: '#000'
            // contentEditable: 'true' // added to make div editable
        },
        action: function() { 
            console.log(this.id)
            selectedComponent.value = this.id;
        }
    },
    {
        id:3,
        type:'img',
        src:"https://i.imgur.com/PEVId2M.png",
        alt:"img",
        style : {
            width: '50px',
            height: '50px',
            borderRadius: '4px',
            cursor:'pointer'
        },
        action: function(){
            console.log(this.id)
            selectedComponent.value = this.id;
        }
    },
    {
        id:4,
        type:"br",
        action: function(){
            console.log(this.id)
            selectedComponent.value = this.id;
        }

    }
]);

const canvasElement = ref([]);

const cloneItem = (item) => ({ ...item, id: canvasElement.value.length });

const getComponentProps = (component) => {

}
const handleComponentClick = (component) => {
    // if (component.type === 'button' && component.action) {
        component.action();
    // }

}

const componentStyles = computed({
    get : ()=>{
        //agar hai to 
        if(selectedComponent.value !== null){
            const component =  canvasElement.value.find( e => e.id === selectedComponent.value);

             // textbox me style show krna as key : value ( pair)
            //  return component ? Object.entries(component.style).map(([key, value]) => `${key}: ${value};`).join('\n') : '';
            return component ? JSON.stringify(component.style, null, 2) : '';
        }
        return '';
    },
    set : async(newValue) => {  
        try{
            const styleObj = JSON.parse(newValue);
            // IDK why but selctedComponent.id ka value 100 se kam hai 
            const canvasIndex = canvasElement.value.findIndex(c => c.id === selectedComponent.value);
            console.log(canvasIndex)
            if (canvasIndex !== -1) {
                canvasElement.value[canvasIndex].style = { ...styleObj };
                await nextTick();
            }
            
            console.log('Updated style:', styleObj);
        }
        catch(e){
            console.error('Error parsing styles:', e);
        }
    }
});

watch(canvasElement, (newValue) => {
    console.log('Canvas Elements changed:');
}, { deep: true });

const canvasTextElement = computed({
    get: () =>{
        if(selectedComponent.value !== null){
            const component = canvasElement.value.find( e => e.id === selectedComponent.value);
            return component ? component.text : '';
        }
        return '';
    },
    set : async(newValue)=>{
        const canvasIndex = canvasElement.value.findIndex(c => c.id === selectedComponent.value);
        console.log(canvasIndex)
        if(canvasIndex !== -1){
            console.log(newValue,canvasIndex)

            canvasElement.value[canvasIndex].text = newValue;
        } 
    }
})
const imageElement = computed ({
    get : () => {
        //no need to do this much but ok 
        if(selectedComponent.value !== null){
            const component = canvasElement.value.find( e => e.id === selectedComponent.value);
            return component ? component.src : '';
        }
        return '';
    },  
    set : (newValue) => {
        const canvasIndex = canvasElement.value.findIndex(c => c.id === selectedComponent.value);
        if(canvasIndex !== -1){
            canvasElement.value[canvasIndex].src = newValue;
        }
    }
})

function exportJSON() {
  console.log("JSON Export:", JSON.stringify(canvasElement.value, null, 2))
  alert("Check console for JSON")
}
function exportHTML() {
  // Create a temp wrapper element
  const wrapper = document.createElement("div")
  
  canvasElement.value.forEach(component => {
    const el = document.createElement(component.type)
    
    // Apply styles
    if (component.style) {
      Object.assign(el.style, component.style)
    }

    // Apply props (like src for img, href for a)
    Object.entries(component).forEach(([key, val]) => {
      if (["type", "id", "style", "text","action"].includes(key)) return
      el.setAttribute(key, val)
    })

    // Add text content
    if (component.text) {
      el.innerText = component.text
    }

    wrapper.appendChild(el)
  })

  console.log("HTML Export:", wrapper.innerHTML)
  alert("Check console for HTML")
}

</script>

<style scoped>

.container {
    display: flex;
    gap: 20px;
    padding: 20px;
    background: #1E1E2F;
    border-radius: 12px;
}



/* Sidebar button */
.container button {
    width: 100%;
    /* padding: 12px 15px; */
    background: #08CB00;
    color: white;
    font-weight: 600;
    font-size: 14px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background 0.3s;
}

.container button:hover {
    background: #06a900;
}

/* Board Area */
.board1 {
    flex: 1;
    min-height: 400px;
    /* background-color: #465C88; */
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
}
.board2 {
    flex: 4;
    min-height: 400px;
    /* background: #465C88; */
    border-radius: 10px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
    padding: 20px;
    color: white;
}

/* Styling Box */
.stylingBox {
    margin-top: 20px;
    background: #1e1e2f; /* Dark panel */
    padding: 20px;
    border-radius: 12px;
    display: flex;
    flex-direction: column;
    gap: 20px;
    color: #f5f5f5;
}

/* Action Buttons */
.actions {
    display: flex;
    gap: 12px;
    justify-content: flex-start;
}

.actions button {
    background: #007bff;
    color: #fff;
    font-weight: bold;
    padding: 10px 18px;
    border-radius: 6px;
    border: none;
    cursor: pointer;
    transition: background 0.3s ease;
}

.actions button:hover {
    background: #0056b3;
}

/* Container for editors */
.container {
    display: flex;
    gap: 20px;
    flex-wrap: wrap;
}

/* Editor Panels */
.components2 {
    flex: 1;
    width: 150px;
    /* background: #465C88; */
    border-radius: 10px;
    padding: 15px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}
 .board {
    flex: 1;
    min-width: 300px;
    /* background: #465C88; */
    border-radius: 10px;
    padding: 15px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
}

.components2 h3, .board h3 {
    font-size: 16px;
    margin-bottom: 10px;
    color: #ffcc00; /* Highlight title */
}

/* Textarea Styling */
textarea {
    width: 90%;
    border: 1px solid #444;
    border-radius: 6px;
    padding: 10px;
    background: #1e1e2f;
    color: #f5f5f5;
    font-family: monospace;
    font-size: 14px;
    resize: vertical;
}

textarea:focus {
    outline: none;
    border-color: #007bff;
    box-shadow: 0 0 8px rgba(0, 123, 255, 0.4);
}


</style>