<template>
    <div :class="['app-container', { collapsed: sidenavCollapsed }]">
        <!-- Side Navigation -->
        <nav :class="['side-nav', { collapsed: sidenavCollapsed }]">
            <div class="logo">
                <button class="logo-toggle" @click="toggleSidenav" aria-label="Toggle sidebar">
                    <i class="fa-solid fa-bars"></i>
                </button>
            </div>
            <button class="nav-btn ">
                <span>Editor</span>
            </button>
            <button class="nav-btn">
                <span>Templates</span>
            </button>
        </nav>

        <!-- Main Content -->
        <main :class="['main-content', { 'has-palette': showPalette }]">
            <!-- Toolbar -->
            <div class="toolbar">
                <div class="actions">
                    <button @click="exportJSON">Export JSON</button>
                    <button @click="exportHTML">Export HTML</button>
                </div>
                <button class="component-toggle" @click="togglePalette" v-if="!showPalette">
                   <i class="fa-solid fa-left-long"></i>
                    Add Component
                </button>
            </div>

            <!-- Workspace -->
            <div class="workspace">
                <Board
                    v-model:canvasElement="canvasElement"
                    :getComponentProps="getComponentProps"
                    :handleComponentClick="handleComponentClick"
                    :handleComponentDblClick="handleComponentDblClick"
                    :editingTextId="editingTextId"
                    :editingText="inlineText"
                    :updateInlineText="updateInlineText"
                    :saveInlineText="saveInlineText"
                    :cancelInlineEdit="cancelInlineEdit"
                />
            </div>

            <!-- Floating Component Palette -->
            <div class="component-palette" :class="{ 'palette-visible': showPalette }">
                <div class="palette-header">
                    <h3>Components</h3>
                    <button @click="togglePalette" class="close-btn">&times;</button>
                </div>
                
                <!-- Components List -->
                <div class="palette-content">
                    <ComponentPalette
                        :componentList="componentList"
                        :clone-item="cloneItem"
                    />
                </div>

                <!-- Edit Component Form - Only visible when component selected -->
                <div v-if="selectedComponent !== null" class="edit-panel">
                    <div class="edit-header">
                        <h4>Edit Styles</h4>
                        <button @click="selectedComponent = null" class="close-btn small">&times;</button>
                    </div>
                    <p class="edit-note">Double-click a component in the workspace to edit its text inline.</p>
                    <div class="editor-grid">
                        <div class="editor-section">
                            <h5>Styles</h5>
                            <textarea
                                v-model="componentStyles"
                                placeholder="Edit component styles..."
                                rows="6"
                            ></textarea>
                        </div>
                    </div>
                </div>
            </div>
        </main>
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
const showPalette = ref(false);
// const canvasIndex = () => {
//     return canvasElement.value.findIndex(c => c.id === selectedComponent.value);
// };

const sidenavCollapsed = ref(false);
const toggleSidenav = () => {
    sidenavCollapsed.value = !sidenavCollapsed.value;
}

const editingTextId = ref(null);
const inlineText = ref('');

const handleComponentDblClick = (component) => {
    if (component.type === 'div' || component.type === 'button') {
        editingTextId.value = component.id;
        inlineText.value = component.text || '';
    }
};

const updateInlineText = (value) => {
    inlineText.value = value;
};

const saveInlineText = (component) => {
    const index = canvasElement.value.findIndex(c => c.id === component.id);
    if (index !== -1) {
        canvasElement.value[index].text = inlineText.value;
    }
    editingTextId.value = null;
};

const cancelInlineEdit = () => {
    editingTextId.value = null;
};

const togglePalette = () => {
    showPalette.value = !showPalette.value;
}

watch(selectedComponent, (newValue) => {
        canvasIndex.value = canvasElement.value.findIndex(c => c.id === newValue);
        if (newValue !== null) {
            showPalette.value = true;
        }

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
            color: 'white'
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

<style>
:root {
  --bg: #2D2D44;
  --panel: #383857;
  --muted: #6b7280;
  --primary: #2563eb;
  --accent: #10b981;
  --border: #e6eef8;
  --text: wheat;
  --secondaryText: #2D2D44;
}

/* Layout */
.app-container {
  color: var(--text);
  display: grid;
  grid-template-columns: 120px 1fr;
  min-height: 100vh;
  background: var(--bg);
}

.app-container.collapsed {
  grid-template-columns: 72px 1fr;
}

/* Side Navigation */
.side-nav {
  background: transparent;
  padding: 1rem 0.75rem;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 0.75rem;
  width: 100px;
  transition: width 0.25s ease;
}

.side-nav.collapsed {
  width: 40px;
}

.logo {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  color: var(--text);
  font-weight: 700;
  font-size: 1rem;
  padding: 0.75rem 0.25rem;
}

.logo-toggle {
  background: transparent;
  border: none;
  color: var(--text);
  cursor: pointer;
  font-size: 1rem;
  padding: 0;
}

.side-nav.collapsed .logo span {
  display: none;
}

.nav-btn {
  width: 100%;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.5rem 0.75rem;
  border-radius: 8px;
  background: transparent;
  border: 1px solid transparent;
  color: var(--text);
  cursor: pointer;
  transition: background 0.12s ease, transform 0.06s ease;
  justify-content: flex-start;
  font-size: 0.95rem;
}

.nav-btn i {
  width: 22px;
  text-align: center;
  color: var(--muted);
}

.side-nav.collapsed .nav-btn {
  justify-content: center;
}

.side-nav.collapsed .nav-btn span {
  display: none;
}

.nav-btn.active {
  background: linear-gradient(90deg, rgba(37,99,235,0.12), rgba(16,185,129,0.06));
  border: 1px solid var(--border);
}

/* Main Content */
.main-content {
  padding: 1.25rem 1.5rem;
  position: relative;
}

/* When palette is open, push workspace to avoid overlap */
.main-content.has-palette .workspace {
  margin-right: 360px;
}

/* Toolbar */
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  gap: 1rem;
}

.actions {
  display: flex;
  gap: 0.5rem;
}

.actions button,
.component-toggle {
  background: #ffffff;
  color: var(--secondaryText);
  border: 1px solid var(--border);
  padding: 0.45rem 0.8rem;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
}

.component-toggle {
  display: flex;
  align-items: center;
  gap: 0.6rem;
}

/* Workspace */
.workspace {
  background: var(--panel);
  border-radius: 10px;
  min-height: calc(100vh - 140px);
  padding: 1.5rem;
  box-shadow: 0 8px 24px rgba(15,23,42,0.06);
  transition: margin-right 0.25s ease;
}

.workspace > * {
  width: 100%;
  max-width: 980px;
}

/* Component Palette - docked card on the right */
.component-palette {
  position: fixed;
  right: 0px;
  top: 0;
  width: 270px;
  height: calc(100% - 40px);
  background: var(--panel);
  transition: transform 0.25s ease, opacity 0.25s ease;
  padding: 1rem;
  box-shadow: 0 12px 40px rgba(2,6,23,0.06);
  transform: translateX(420px);
  opacity: 0;
  overflow: auto;
}

.component-palette.palette-visible {
  transform: translateX(0);
  opacity: 1;
}

.palette-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
  color: var(--text);
}

.palette-header h3 { margin: 0; font-size: 1rem; }

.palette-content {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

/* Edit Panel - appears below components when selected */
.edit-panel {
  border-top: 1px solid var(--border);
  margin-top: 1rem;
  padding-top: 1rem;
}

.edit-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.75rem;
}

.edit-header h4 {
  margin: 0;
  font-size: 0.9rem;
  color: var(--text);
}

.edit-note {
  margin: 0 0 1rem;
  color: var(--muted);
  font-size: 0.85rem;
}

.close-btn.small {
  width: 24px;
  height: 24px;
  font-size: 0.9rem;
}

.editor-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

.editor-section {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

/* Close Button */
.close-btn {
  background: transparent;
  border: none;
  color: var(--muted);
  font-size: 1.1rem;
  cursor: pointer;
  width: 36px;
  height: 36px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.close-btn:hover {
  background: rgba(15,23,42,0.04);
  color: var(--text);
}



@media (max-width: 900px) {
  .app-container { grid-template-columns: 72px 1fr; }
  .main-content.has-palette .workspace { margin-right: 0; }
  .component-palette { display: none; }
}
</style>