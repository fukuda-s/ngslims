import { Selection } from '../../../3rdparty/walkontable/src/index';

/**
 * @return {Selection}
 */
function createHighlight({ activeHeaderClassName }) {
  const s = new Selection({
    highlightHeaderClassName: activeHeaderClassName,
  });

  return s;
}

export default createHighlight;
