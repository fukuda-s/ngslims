import { getEditor } from '../editors/index';
import { getRenderer } from '../renderers/index';
import { getValidator } from '../validators/index';

const CELL_TYPE = 'numeric';

export default {
  editor: getEditor(CELL_TYPE),
  renderer: getRenderer(CELL_TYPE),
  validator: getValidator(CELL_TYPE),
  dataType: 'number',
};
