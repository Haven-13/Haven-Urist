import { useBackend, useSharedState } from "tgui/backend";
import { Box, Button, Flex, Icon, Input, Modal, Section, Stack, TextArea } from "tgui/components";
import { NtosWindow } from "tgui/layouts";

const ErrorMessageModal = (props, context) => {
  const {
    message,
    onClick = () => {},
  } = props;

  return (
    <Modal>
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
    onAccept=() => {},
    onCancel=() => {},
  } = props;

  const [
    selectedDevice,
    setSelectedDevice,
  ] = useSharedState(context, "selectedDevice", "local");

  const [
    selectedFile,
    setSelectedFile,
  ] = useSharedState(context, "selectedFile", null);

  return (
    <Modal />
  );
};

const UnsavedWarningModal = (props, context) => {
  const {
    onYes = () => {},
    onNo = () => {},
    onCancel = () => {},
  } = props;

  return (
    <Modal>
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
  } = props;

  const [
    currentInput,
    setCurrentInput,
  ] = useSharedState(context, "currentInput", value);

  return (
    <Modal>
      <Section
        title={title}
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
                  onClick={() => onAccept()}
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

  const [
    nextAction,
    setNextAction,
  ] = useSharedState(context, "nextAction", () => {});

  const openWarningPrompt = () => setIsWarningPromptOpen(true);
  const closeWarningPrompt = () => setIsWarningPromptOpen(false);

  const openFileBrowser = () => setIsFileBrowserOpen(true);
  const closeFileBrowser = () => setIsFileBrowserOpen(false);

  const openFileNamePrompt = () => setIsFileNamePromptOpen(true);
  const closeFileNamePrompt = () => setIsFileNamePromptOpen(false);

  const saveAsFile = () => act("save_as_file", { file_name: currentFileName });

  return (
    <NtosWindow
      width={400}
      height={450}
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
              saveAsFile();
              nextAction();
              closeWarningPrompt();
            }}
            onNo={() => {
              nextAction();
              closeWarningPrompt();
            }}
            onCancel={() => {
              closeWarningPrompt();
            }}
          />
        )}
        {!!isFileBrowserOpen && (
          <FileBrowserView
            onAccept={(file) => {
              closeFileBrowser();

              if (is_edited) {
                openWarningPrompt();
                setNextAction(() => act("open_file", { target: file }));
              } else {
                act("open_file", {
                  target: file,
                });
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
              nextAction();
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
                      setNextAction(() => {
                        act("create_file", {
                          file_name: currentFileName,
                        });
                      });
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
                    onClick={() => {
                      if (!fileexists) {
                        openFileNamePrompt();
                        saveAsFile();
                      } else {
                        act("save_file");
                      }
                    }}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    content="Save As"
                    onClick={() => {
                      openFileNamePrompt();
                      setNextAction(() => saveAsFile());
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
