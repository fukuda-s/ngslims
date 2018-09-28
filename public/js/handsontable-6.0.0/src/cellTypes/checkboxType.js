import { getEditor } from '../editors/index';
import { getRenderer } from '../renderers/index';

const CELL_TYPE = 'checkbox';

export default {
  editor: getEditor(CELL_TYPE),
  renderer: getRenderer(CELL_TYPE),
};
