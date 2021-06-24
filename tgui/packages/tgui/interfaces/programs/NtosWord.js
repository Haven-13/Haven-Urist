import { useBackend, useSharedState } from "tgui/backend";
import { Box, Button, Flex, Icon, Input, LabeledList, Modal, Section, Stack, Tabs, TextArea } from "tgui/components";
import { NtosWindow } from "tgui/layouts";

const ErrorMessageModal = (props, context) => {
  const {
    message,
    onClick = () => {},
    ...rest
  } = props;

  return (
    <Modal
      {...rest}
    >
      <Section
        fitted
        title="Error"
      >
        <Stack vertical>
          <Stack.Item>
            <Flex>
              <Flex.Item>
                <Icon
                  name="times"
                />
              </Flex.Item>
              <Flex.Item>
                <Box>
                  {message}
                </Box>
              </Flex.Item>
            </Flex>
          </Stack.Item>
          <Stack.Item align="right">
            <Button
              content="OK"
              onClick={() => onClick()}
            />
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  );
};

const FileBrowserView = (props, context) => {
  const {
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
        title="Open document file"
        buttons={
          <Button
            icon="times"
            onClick={() => onCancel()}
          />
        }
      >
        <Stack vertical>
          <Stack.Item>
            <Tabs>
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
          <Stack.Item>
            <Stack vertical>
              {filesToDisplay().map((entry, index) => (
                <Stack.Item key={index}>
                  <Button.Checkbox
                    fluid
                    checked={selectedFile === entry.name}
                    onClick={() => setSelectedFile(entry.name)}
                  >
                    <Flex
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

const UnsavedWarningModal = (props, context) => {
  const {
    onYes = () => {},
    onNo = () => {},
    onCancel = () => {},
    ...rest
  } = props;

  return (
    <Modal
      p={0}
      {...rest}
    >
      <Section
        title="Warning"
      >
        <Stack vertical>
          <Stack.Item>
            You have unsaved progress on your file. Do you want to save?
          </Stack.Item>
          <Stack.Item>
            <Flex>
              <Flex.Item>
                <Button
                  content="Yes"
                  onClick={() => onYes()}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="No"
                  onClick={() => onNo()}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Cancel"
                  onClick={() => onCancel()}
                />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  );
};

const FileNamePromptModal = (props, context) => {
  const {
    title = "Enter a file name",
    value,
    onCancel,
    onAccept,
    ...rest
  } = props;

  const [
    currentInput,
    setCurrentInput,
  ] = useSharedState(context, "currentInput", value);

  return (
    <Modal
      p={0}
      {...rest}
    >
      <Section
        title={currentInput}
      >
        <Stack vertical>
          <Stack.Item>
            <Input
              value={currentInput}
              onInput={(e, v) => setCurrentInput(v)}
            />
          </Stack.Item>
          <Stack.Item>
            <Flex>
              <Flex.Item>
                <Button
                  content="Proceed"
                  onClick={() => onAccept(currentInput)}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Cancel"
                  onClick={() => onCancel()}
                />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  );
};

export const NtosWord = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    error = null,
    usbconnected,
    files = [],
    usbfiles = [],
    filename,
    filedata,
    fileexists,
    is_edited,
  } = data;

  const [
    currentFileName,
    setCurrentFileName,
  ] = useSharedState(context, "currentFileName", filename);

  const [
    nextOpenFileName,
    setNextOpenFileName,
  ] = useSharedState(context, "nextOPenFileName", null);

  const [
    isWarningPromptOpen,
    setIsWarningPromptOpen,
  ] = useSharedState(context, "isWarningPromptOpen", false);

  const [
    isFilenamePromptOpen,
    setIsFileNamePromptOpen,
  ] = useSharedState(context, "isFilenamePromptOpen", false);

  const [
    isFileBrowserOpen,
    setIsFileBrowserOpen,
  ] = useSharedState(context, "isFileBrowserOpen", false);

  const openWarningPrompt = () => setIsWarningPromptOpen(true);
  const closeWarningPrompt = () => setIsWarningPromptOpen(false);

  const openFileBrowser = () => setIsFileBrowserOpen(true);
  const closeFileBrowser = () => setIsFileBrowserOpen(false);

  const openFileNamePrompt = () => setIsFileNamePromptOpen(true);
  const closeFileNamePrompt = () => setIsFileNamePromptOpen(false);

  /*
  * Messy? Yes.
  * Insecure? Probably.
  * Is it necessary? Very yes.
  * Why? Because fuck you. And you, Bay, for thinking having a fucking
  * Word Processor ingame, like holy shit why.
  *
  * And fuck you JSON and Javascript for not supporting function signatures,
  * so anonymous or functions cannot be stored then executed.
  * It is more secure this way, but still. Holy shit.
  */
  const NEXT_ACTION = {
    noOperation: {
      function: () => {}
    },
    createNewFile: {
      function: (newFileName) => {
        act("create_file", {file_name: newFileName});
      }
    },
    saveAsFile: {
      function: (newFileName) => {
        act("save_as_file", {file_name: newFileName});
      }
    },
    openFileAfterWarning: {
      function: (nextOpenFileName) => {
        act("open_file", {file_name: nextOpenFileName});
        setNextOpenFileName(null);
      }
    }
  }

  function doNext(next) {
    let nextActionKey = Object.keys(NEXT_ACTION).filter((k) => {
      return NEXT_ACTION[k] === next;
    })[0];
    setNextActionKey(nextActionKey);
  };

  function callNextAction(...params) {
    NEXT_ACTION[nextActionKey].function(...params);
    doNext(NEXT_ACTION.noOperation);
  };

  const [
    nextActionKey,
    setNextActionKey,
  ] = useSharedState(context, "nextActionKey", NEXT_ACTION.noOperation);

  function saveFile() {
    if (!fileexists) {
      openFileNamePrompt();
      doNext(NEXT_ACTION.saveAsFile)
    } else {
      act("save_file");
    }
  }

  return (
    <NtosWindow
      width={550}
      height={650}
    >
      <NtosWindow.Content>
        {!!error && (
          <ErrorMessageModal
            message={error}
            onClick={() => act("clear_error")}
          />
        )}
        {!!isWarningPromptOpen && (
          <UnsavedWarningModal
            onYes={() => {
              saveFile();
              callNextAction(nextOpenFileName);
              closeWarningPrompt();
            }}
            onNo={() => {
              callNextAction(nextOpenFileName);
              closeWarningPrompt();
            }}
            onCancel={() => {
              closeWarningPrompt();
            }}
          />
        )}
        {!!isFileBrowserOpen && (
          <FileBrowserView
            width={40}

            files={{
              local: files,
              usb: usbconnected && usbfiles || null,
            }}
            onAccept={(file) => {
              closeFileBrowser();
              setNextOpenFileName(file);

              if (is_edited) {
                openWarningPrompt();
                doNext(NEXT_ACTION.openFileAfterWarning);
              } else {
                NEXT_ACTION.openFileAfterWarning.function();
              }
            }}
            onCancel={() => closeFileBrowser()}
          />
        )}
        {!!isFilenamePromptOpen && (
          <FileNamePromptModal
            value={currentFileName}
            onAccept={(value) => {
              setCurrentFileName(value);
              closeFileNamePrompt();
              callNextAction(value);
            }}
            onCancel={() => {
              closeFileNamePrompt();
            }}
          />
        )}
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <Flex>
                <Flex.Item>
                  <Box bold>
                    {filename}
                  </Box>
                </Flex.Item>
                <Flex.Item>
                  {!!is_edited && (
                    <Box italic color="average">
                      &#91; EDITED &#93;
                    </Box>
                  )}
                </Flex.Item>
                <Flex.Item>
                  {!fileexists && (
                    <Box italic color="bad">
                      &#91; NOT SAVED &#93;
                    </Box>
                  )}
                </Flex.Item>
              </Flex>
            </Stack.Item>
            <Stack.Item>
              <Flex
                direction="row"
              >
                <Flex.Item>
                  <Button
                    content="New"
                    onClick={() => {
                      openFileNamePrompt();
                      doNext(NEXT_ACTION.createNewFile);
                    }}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    content="Open"
                    onClick={() => openFileBrowser()}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    content="Save"
                    onClick={() => saveFile()}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    content="Save As"
                    onClick={() => {
                      openFileNamePrompt();
                      doNext(NEXT_ACTION.saveAsFile)
                    }}
                  />
                </Flex.Item>
                <Flex.Item />
                <Flex.Item>
                  <Button
                    content="Preview"
                    onClick={() => act("text_preview")}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    content="Help"
                    onClick={() => act("tag_help")}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    content="Print"
                    onClick={() => act("print_file")}
                  />
                </Flex.Item>
              </Flex>
            </Stack.Item>
            <Stack.Item grow basis={1}>
              <TextArea
                fluid
                height="100%"
                scrollable
                value={filedata}
                onInput={(e, v) =>
                  act("edit_file", {
                    text: v,
                  })}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
