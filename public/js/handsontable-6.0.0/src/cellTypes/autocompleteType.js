import { getEditor } from '../editors/index';
import { getRenderer } from '../renderers/index';
import { getValidator } from '../validators/index';

const CELL_TYPE = 'autocomplete';

export default {
  editor: getEditor(CELL_TYPE),
  renderer: getRenderer(CELL_TYPE),
  validator: getValidator(CELL_TYPE),
};
