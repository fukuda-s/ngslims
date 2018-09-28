import { getEditor } from '../editors/index';
import { getRenderer } from '../renderers/index';
import { getValidator } from '../validators/index';

const CELL_TYPE = 'time';

export default {
  editor: getEditor('text'),
  // displays small gray arrow on right side of the cell
  renderer: getRenderer('text'),
  validator: getValidator(CELL_TYPE),
};
