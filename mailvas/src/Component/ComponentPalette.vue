<template>
  <div class="components-panel">
    <VueDraggable
      v-model="props.componentList"
      :group="{ name: 'myGroup', pull: 'clone', put: false }"
      :clone="props.cloneItem"
      item-key="id"
      :sort="false"
    >
      <div
        v-for="component in props.componentList"
        :key="component.id"
        class="component-item"
      >
        <component
          :is="component.type"
          :style="component.style"
          @click="component.action"
          :src="component.src || 'https://via.placeholder.com/100'"
          :alt="component.alt"
          :cellpadding="component.cellpadding"
        >
          {{ component.text }}
        </component>
      </div>
    </VueDraggable>
  </div>
</template>

<script setup>
import { VueDraggable } from 'vue-draggable-plus';

const props = defineProps({
  componentList: Array,
  cloneItem: Function
});
</script>

<style scoped>
.components-panel {

  min-height: 400px;
  background-color: #fff0c4;
  padding: 12px;
  border-radius: 6px;
  border: 1px solid #ddd;
}

.component-item {
  margin-bottom: 12px;
  padding: 8px;
  background: #fff;
  border: 1px solid #ccc;
  border-radius: 4px;
  text-align: center;
  cursor: grab;
  transition: background 0.2s;
}

.component-item:hover {
  background: #f9f9f9;
}
</style>
