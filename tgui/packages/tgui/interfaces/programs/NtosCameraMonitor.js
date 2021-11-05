import { filter, sortBy } from 'common/collections';
import { flow } from 'common/fp';
import { classes } from 'common/react';
import { createSearch } from 'common/string';
import { useBackend, useLocalState, useSharedState } from "tgui/backend";
import { Button, ByondUi, Dropdown, Input, Section, Stack } from "tgui/components";
import { NtosWindow } from "tgui/layouts";

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
  const networkList = networks
    .filter((network) => !!network.has_access)
    .map((network) => network.tag);
  const camerasByNetwork = Object.assign({}, ...networks.map((network) => {
    return { [network.tag]: network.cameras };
  }));

  const [
    selectedView,
    setSelectedView,
  ] = useSharedState(context, "selectedView", 0);

  return (
    <NtosWindow
      width={1020}
      height={750}
      resizable
    >
      <NtosWindow.Content>
        <div className="CameraConsole__left">
          <Section fill scrollable>
            <CameraConsoleContent
              networks={networkList}
              cameras={
                camerasByNetwork[selected_network]
                || []
              }
              selected={(entry) =>
                entry.name
                === active_view_data[selectedView]?.camera?.name}
              onClick={(entry) => act("switch_camera", {
                index: selectedView + 1,
                camera: entry.camera,
              })}
            />
          </Section>
        </div>
        <div className="CameraConsole__right">
          <div className="CameraConsole__toolbar">
            <div className="CameraConsole__viewselect">
              {active_view_data.length > 1
              && active_view_data.map((view, index) => (
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
    networks = [],
    cameras = [],
    disabled = (v) => false,
    selected = (v) => false,
    onClick = () => {},
  } = props;
  const [
    searchText,
    setSearchText,
  ] = useLocalState(context, 'searchText', '');
  const displayCameras = selectCameras(cameras, searchText);
  return (
    <Stack vertical>
      <Stack.Item>
        <Dropdown
          mb={0.5}
          options={networks}
          selected={data.selected_network}
          width="100%"
          onSelected={(v) => act("switch_network", {
            network: v,
          })}
        />
      </Stack.Item>
      <Stack.Item>
        <Input
          autoFocus
          fluid
          mb={0.5}
          placeholder="Search for Camera"
          onInput={(e, value) => setSearchText(value)} />
      </Stack.Item>
      <Stack.Item grow>
        {!!displayCameras.length && displayCameras.map((entry, index) => (
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
            {entry.name}
          </div>
        )) || (
          <b>There are no cameras {
            !!searchText.length && "matching your search"
          }
          </b>
        )}
      </Stack.Item>
    </Stack>
  );
};
