import { filter, map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState, useSharedState } from "tgui/backend";
import { Button, ByondUi, Flex, Input, Section, Stack } from "tgui/components";
import { NtosWindow, Window } from "tgui/layouts";

/**
 * Camera selector.
 *
 * Filters cameras, applies search terms and sorts the alphabetically.
 */
const selectCameras = (cameras, searchText = '') => {
  const testSearch = createSearch(searchText, camera => camera.name);
  return flow([
    // Null camera filter
    filter(camera => camera?.name),
    // Optional search term
    searchText && filter(testSearch),
    // Slightly expensive, but way better than sorting in BYOND
    sortBy(camera => camera.name),
  ])(cameras);
};

export const NtosCameraMonitor = (props, context) => {
  const { act, data, config } = useBackend(context);
  const {
    camera_view_refs = [],
    active_view_data = [],
    selected_network,
    networks = [],
  } = data;
  const networkList = networks.map((network) => {
    return {name: network.tag}
  });
  const camerasByNetwork = Object.assign({}, ...networks.map((network) => {
    return {[network.tag]: network.cameras}
  }));

  const [
    selectedView,
    setSelectedView,
  ] = useSharedState(context, "selectedView", 0);

  return (
    <NtosWindow
      width={1440}
      height={850}
    >
      <NtosWindow.Content>
        <div className="CameraConsole__left">
          <Section fill scrollable>
            <Flex>
              <Flex.Item width="50%">
                <CameraConsoleContent
                  content={networkList}
                  selected={(entry) =>
                    entry.name === selected_network
                  }
                  emptySearchText={"Search for Network"}
                  format={(entry) => entry.name}
                  onClick={(entry) => act("switch_network", {
                    network: entry.name,
                  })}
                />
              </Flex.Item>
              <Flex.Item width="50%">
                <CameraConsoleContent
                  content={
                    camerasByNetwork[selected_network]
                    || []
                  }
                  selected={(entry) =>
                    entry.name ===
                    active_view_data[selectedView]?.camera?.name
                  }
                  emptySearchText={"Search for Camera"}
                  format={(entry) => entry.name}
                  onClick={(entry) => act("switch_camera", {
                    index: selectedView + 1,
                    camera: entry.camera
                  })}
                />
              </Flex.Item>
            </Flex>
          </Section>
        </div>
        <div className="CameraConsole__right">
          <div className="CameraConsole__toolbar">
            <div className="CameraConsole__viewselect">
              {active_view_data.length > 1 && active_view_data.map((view, index) => (
                <Button.Checkbox
                  key={index}
                  checked={selectedView === (index)}
                  onClick={() => setSelectedView(index)}
                >
                  View {index + 1}
                </Button.Checkbox>
              ))}
            </div>
          </div>
          <div className="CameraConsole__viewcontainer">
            <table width="100%" height="100%">
              <tr height="50%">
                <td
                  width="50%"
                  className={
                    selectedView === 0 && "CameraConsole__view--selected"
                  }
                >
                  <ByondUi
                    className="CameraConsole__viewmap"
                    params={{
                      id: camera_view_refs[0],
                      type: 'map',
                    }}
                  />
                  <div>
                    1: {
                      active_view_data[0]?.camera?.name
                      || "-"
                    }
                  </div>
                </td>
                <td
                  className={
                    selectedView === 1 && "CameraConsole__view--selected"
                  }
                >
                  <ByondUi
                    className="CameraConsole__viewmap"
                    params={{
                      id: camera_view_refs[1],
                      type: 'map',
                    }}
                  />
                  <div>
                    2: {
                      active_view_data[1]?.camera?.name
                      || "-"
                    }
                  </div>
                </td>
              </tr>
              <tr>
                <td
                  className={
                    selectedView === 2 && "CameraConsole__view--selected"
                  }
                >
                  <ByondUi
                    className="CameraConsole__viewmap"
                    params={{
                      id: camera_view_refs[2],
                      type: 'map',
                    }}
                  />
                  <div>
                    3: {
                      active_view_data[2]?.camera?.name
                      || "-"
                    }
                  </div>
                </td>
                <td
                  className={
                    selectedView === 3 && "CameraConsole__view--selected"
                  }
                >
                  <ByondUi
                    className="CameraConsole__viewmap"
                    params={{
                      id: camera_view_refs[3],
                      type: 'map',
                    }}
                  />
                  <div>
                    4: {
                      active_view_data[3]?.camera?.name
                      || "-"
                    }
                  </div>
                </td>
              </tr>
            </table>
          </div>
        </div>
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const CameraConsoleContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    content = [],
    selected = (v) => false,
    emptySearchText = "Placeholder",
    emptyListText = "This list is empty",
    format = (v) => {},
    onClick = () => {},
  } = props;
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  return (
    <Stack vertical>
      <Stack.Item>
        <Input
          autoFocus
          fluid
          mb={1}
          placeholder={emptySearchText}
          onInput={(e, value) => setSearchText(value)} />
      </Stack.Item>
      <Stack.Item grow>
        {!!content.length && content.map((entry, index) => (
          // We're not using the component here because performance
          // would be absolutely abysmal (50+ ms for each re-render).
          <div
            key={index}
            className={classes([
              'Button',
              'Button--fluid',
              'Button--color--transparent',
              'Button--ellipsis',
              selected(entry) && 'Button--selected',
            ])}
            onClick={() => onClick(entry)}>
            {format(entry)}
          </div>
        )) || (
          <b>{emptyListText}</b>
        )}
      </Stack.Item>
    </Stack>
  );
};
