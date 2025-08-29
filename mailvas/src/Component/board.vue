<template>
  <!-- Table structure toggle controls -->
  <div class="table-controls">
    <label>
      <input type="checkbox" v-model="tableStructure" />
      Table Structure
    </label>

    <div v-if="tableStructure" class="attributes">
      <label>
        <input type="checkbox" v-model="tableAttributes.align" />
        Align Center
      </label>

      <input
        type="number"
        placeholder="Table Width"
        v-model="tableAttributes.width"
      />

      <input
        type="number"
        placeholder="Cell Padding"
        v-model="tableAttributes.cellpadding"
      />
    </div>
  </div>

  <!-- Main Table Layout -->
  <table
    border="0"
    cellpadding="0"
    cellspacing="0"
    :class="{ outerContainer: tableStructure }"
  >
    <tbody>
      <tr>
        <td>
          <table
            :align="tableAttributes.align ? 'center' : 'left'"
            :class="{ mainTable: tableStructure }"
            :cellpadding="tableAttributes.cellpadding"
            cellspacing="0"
            :width="tableAttributes.width"
          >
            <tbody>
              <tr>
                <td>
                  <VueDraggable
                    v-model="props.canvasElement"
                    item-key="id"
                    class="dropzone"
                    :group="{ name: 'myGroup', pull: true, put: true }"
                    :empty-insert-threshold="50"
                    @add="e => console.log('added to canvas', e)"
                    @update:modelValue="val =>
                      emit('update:canvasElement', val)"
                  >
                    <div
                      v-for="component in props.canvasElement"
                      :key="component.id"
                      class="component-wrapper"
                    >
                      <!-- Special case for button -->
                      <template v-if="component.type === 'button'">
                        <table
                          border="0"
                          :cellpadding="component.cellpadding"
                          :cellspacing="component.cellspacing"
                          :style="component.style"
                        >
                          <tbody>
                            <tr>
                              <td>
                                <div
                                  :is="component.type"
                                  :style="component.style"
                                  v-bind="props.getComponentProps(component)"
                                  @click="
                                    props.handleComponentClick(component)
                                  "
                                  :src="component.src"
                                >
                                  {{ component.text }}
                                </div>
                              </td>
                            </tr>
                          </tbody>
                        </table>
                      </template>

                      <!-- Render other components -->
                      <component
                        v-else
                        :is="component.type"
                        :style="component.style"
                        v-bind="getComponentProps(component)"
                        @click="handleComponentClick(component)"
                        :src="component.src"
                      >
                        {{ component.text }}
                      </component>
                    </div>
                  </VueDraggable>
                </td>
              </tr>
            </tbody>
          </table>
        </td>
      </tr>
    </tbody>
  </table>
</template>

<script setup>
import { ref } from 'vue';
import { VueDraggable } from 'vue-draggable-plus';

const props = defineProps({
  canvasElement: Array,
  getComponentProps: Function,
  handleComponentClick: Function
});

const emit = defineEmits(['update:canvasElement']);

const tableStructure = ref(true);
const tableAttributes = ref({
  border: 0,
  cellpadding: 20,
  cellspacing: 20,
  width: 650,
  align: true
});
</script>

<style scoped>
.table-controls {
  display: flex;
  flex-wrap: wrap;
  gap: 12px;
  align-items: center;
  margin-bottom: 16px;
  font-size: 14px;
}

.table-controls input[type='number'] {
  width: 120px;
  padding: 6px;
  font-size: 14px;
  border: 1px solid #ccc;
  border-radius: 4px;
}

.dropzone {
  min-height: 500px;
  padding: 10px;
  background: #fdfdfd;
  border: 2px dashed #ccc;
  border-radius: 6px;
}

.outerContainer {
  background-color: #f5babb;
  width: 100%;
}

.mainTable {
  background-color: #faeabb;
  margin: 0 auto;
}

.component-wrapper {
  margin: 10px 0;
}
</style>
