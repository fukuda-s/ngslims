import { getEditor } from '../editors/index';
import { getRenderer } from '../renderers/index';
import { getValidator } from '../validators/index';

const CELL_TYPE = 'dropdown';

export default {
  editor: getEditor(CELL_TYPE),
  // displays small gray arrow on right side of the cell
  renderer: getRenderer('autocomplete'),
  validator: getValidator('autocomplete'),
};
