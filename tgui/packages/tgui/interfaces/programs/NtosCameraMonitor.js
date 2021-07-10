import { filter, map, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { Fragment } from 'inferno';
import { useBackend, useLocalState, useSharedState } from "tgui/backend";
import { Button, ByondUi, Flex, Input, Section, Stack } from "tgui/components";
import { NtosWindow, Window } from "tgui/layouts";

/**
 * Returns previous and next camera names relative to the currently
 * active camera.
 */
const prevNextCamera = (cameras, activeCamera) => {
  if (!activeCamera) {
    return [];
  }
  const index = cameras.findIndex(camera => (
    camera.name === activeCamera.name
  ));
  return [
    cameras[index - 1]?.name,
    cameras[index + 1]?.name,
  ];
};

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
      width={970}
      height={708}
      resizable>
      <NtosWindow.Content>
        <div className="CameraConsole__left">
          <Section fill scrollable>
            <Flex>
              <Flex.Item width="50%">
                <CameraConsoleContent
                  content={networkList}
                  selected={active_view_data[selectedView]?.network}
                  emptySearchText={"Search for Network"}
                  format={(entry) => entry.name}
                  onClick={(entry) => act("switch_network", {
                    index: selectedView + 1,
                    network: entry.name,
                  })}
                />
              </Flex.Item>
              <Flex.Item width="50%">
                <CameraConsoleContent
                  content={camerasByNetwork[active_view_data[selectedView]?.network] || []}
                  selected={active_view_data[selectedView]?.camera}
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
            <table width="100%">
              <tr>
                <td width="50%">
                  <b> Camera: </b> {
                    active_view_data[selectedView]?.camera?.name
                    || "None"
                  }
                </td>
                <td>
                  <b> Network: </b> {
                    active_view_data[selectedView]?.network
                    || "None"
                  }
                </td>
              </tr>
            </table>
          </div>
          <div className="CameraConsole__viewcontainer">
            <table width="100%" height="100%">
              <tr height="50%">
                <td width="50%">
                  <ByondUi
                    height="100%"
                    params={{
                      id: camera_view_refs[0],
                      type: 'map',
                    }}
                  />
                </td>
                <td>
                  <ByondUi
                    height="100%"
                    params={{
                      id: camera_view_refs[1],
                      type: 'map',
                    }}
                  />
                </td>
              </tr>
              <tr>
                <td width="50%">
                  <ByondUi
                    height="100%"
                    params={{
                      id: camera_view_refs[2],
                      type: 'map',
                    }}
                  />
                </td>
                <td>
                  <ByondUi
                    height="100%"
                    params={{
                      id: camera_view_refs[3],
                      type: 'map',
                    }}
                  />
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
            ])}
            onClick={() => onClick(entry)}>
            {format(entry)}
          </div>
        ))}
      </Stack.Item>
    </Stack>
  );
};
