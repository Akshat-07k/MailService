<template>
  <VueDraggable
    class="components-panel"
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
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
  /* min-height: 400px; */
  padding: 12px;
  border-radius: 6px;
}

.component-item {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 12px;
  /* background: #fff; */
  border: 1px solid #ccc;
  border-radius: 4px;
  text-align: center;
  cursor: grab;
  transition: 0.2s;
}

.component-item:hover {
  background: #2D2D44;
}
</style>
