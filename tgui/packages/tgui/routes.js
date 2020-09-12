/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

/**
 * Haven Changelog
 *   DD/MM/YYYY
 *
 * - 12/09/2020: Support interfaces in subdirs - martinlyra
 */

import { selectBackend } from './backend';
import { selectDebug } from './debug/selectors';
import { Window } from './layouts';

const requireInterface = require.context('./interfaces', true, /\.js$/);

const routingError = (type, name) => () => {
  return (
    <Window resizable>
      <Window.Content scrollable>
        {type === 'notFound' && (
          <div>Interface <b>{name}</b> was not found.</div>
        )}
        {type === 'missingExport' && (
          <div>Interface <b>{name}</b> is missing an export.</div>
        )}
      </Window.Content>
    </Window>
  );
};

const SuspendedWindow = () => {
  return (
    <Window resizable>
      <Window.Content scrollable />
    </Window>
  );
};

export const getRoutedComponent = store => {
  const state = store.getState();
  const { suspended, config } = selectBackend(state);
  if (suspended) {
    return SuspendedWindow;
  }
  if (process.env.NODE_ENV !== 'production') {
    const debug = selectDebug(state);
    // Show a kitchen sink
    if (debug.kitchenSink) {
      return require('./debug').KitchenSink;
    }
  }
  const name = config?.interface;
  let esModule;
  try {
    esModule = requireInterface(`./${name}.js`);
  }
  catch (err) {
    if (err.code === 'MODULE_NOT_FOUND') {
      return routingError('notFound', name);
    }
    throw err;
  }
  // Haven modification to support interface .js in subdirs
  const Component = esModule[name.split('/').slice(-1)[0]];
  if (!Component) {
    return routingError('missingExport', name);
  }
  return Component;
};
