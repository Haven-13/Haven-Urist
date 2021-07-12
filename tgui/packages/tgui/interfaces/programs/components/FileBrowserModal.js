import { useSharedState } from "tgui/backend";
import { Modal, Section, Stack, Button, Flex, Tabs, LabeledList } from "tgui/components";

export const FileBrowserModal = (props, context) => {
  const {
    currentFileName,
    files={
      local: [],
      usb: null,
    },
    onAccept=(file) => {},
    onCancel=() => {},
    ...rest
  } = props;

  const DEVICES = {
    LOCAL: "local",
    USB: "usb",
  };

  const [
    selectedDevice,
    setSelectedDevice,
  ] = useSharedState(context, "selectedDevice", DEVICES.LOCAL);

  const [
    selectedFile,
    setSelectedFile,
  ] = useSharedState(context, "selectedFile", null);

  const changeTab = (selected) => {
    setSelectedFile(null);
    setSelectedDevice(selected);
  };

  const filesToDisplay = () => {
    switch (selectedDevice) {
      default:
      case DEVICES.LOCAL:
        return files.local;
      case DEVICES.USB:
        return files.usb;
    }
  };

  return (
    <Modal
      p={0}
      {...rest}
    >
      <Section
        fill
        title="Open document file"
        buttons={
          <Button
            icon="times"
            onClick={() => onCancel()}
          />
        }
      >
        <Stack
          vertical
          fill
          justify="space-between"
        >
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                selected={selectedDevice === DEVICES.LOCAL}
                onClick={() => changeTab(DEVICES.LOCAL)}
              >
                Local
              </Tabs.Tab>
              {!!files.usb && (
                <Tabs.Tab
                  selected={selectedDevice === DEVICES.USB}
                  onClick={() => changeTab(DEVICES.USB)}
                >
                  USB device
                </Tabs.Tab>
              )}
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              <Stack vertical>
                {filesToDisplay().map((entry, index) => (
                  <Stack.Item key={index} mt={0}>
                    <Button.Checkbox
                      fluid
                      lineHeight={2}
                      disabled={entry.name === currentFileName}
                      checked={selectedFile === entry.name}
                      onClick={() => setSelectedFile(entry.name)}
                    >
                      <Flex
                        inline
                        width="95%"
                        direction="row"
                        justify="space-between"
                      >
                        <Flex.Item>
                          {entry.name}
                        </Flex.Item>
                        <Flex.Item>
                          {entry.size}
                        </Flex.Item>
                      </Flex>
                    </Button.Checkbox>
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Flex
              direction="row"
              justify="space-between"
            >
              <Flex.Item grow>
                <LabeledList>
                  <LabeledList.Item
                    label="Selected"
                  >
                    {!!selectedFile && selectedFile}
                  </LabeledList.Item>
                </LabeledList>
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Open"
                  disabled={!selectedFile}
                  onClick={() => onAccept(selectedFile)}
                />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  );
};
