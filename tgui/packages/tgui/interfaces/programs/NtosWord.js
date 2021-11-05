import { useBackend, useSharedState } from "tgui/backend";
import { Box, Button, Flex, Modal, Section, Stack, TextArea } from "tgui/components";
import { NtosWindow } from "tgui/layouts";
import { ErrorMessageModal, FileBrowserModal, FileNamePromptModal } from "tgui/interfaces/programs/components";

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
            <Flex
              fluid
              direction="row"
              justify="space-between"
            >
              <Flex.Item>
                <Button
                  width={8}
                  content="Yes"
                  onClick={() => onYes()}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  width={8}
                  content="No"
                  onClick={() => onNo()}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  width={8}
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
      function: () => {},
    },
    createNewFile: {
      function: (newFileName) => {
        act("create_file", { file_name: newFileName });
      },
    },
    saveAsFile: {
      function: (newFileName) => {
        act("save_as_file", { file_name: newFileName });
      },
    },
    openFileAfterWarning: {
      function: (nextOpenFileName) => {
        act("open_file", { file_name: nextOpenFileName });
        setNextOpenFileName(null);
      },
    },
  };

  const doNext = (next) => {
    let nextActionKey = Object.keys(NEXT_ACTION).filter((k) => {
      return NEXT_ACTION[k] === next;
    })[0];
    setNextActionKey(nextActionKey);
  };

  const callNextAction = (...params) => {
    NEXT_ACTION[nextActionKey].function(...params);
    doNext(NEXT_ACTION.noOperation);
  };

  const [
    nextActionKey,
    setNextActionKey,
  ] = useSharedState(context, "nextActionKey", NEXT_ACTION.noOperation);

  const saveFile = () => {
    if (!fileexists) {
      openFileNamePrompt();
      doNext(NEXT_ACTION.saveAsFile);
    } else {
      act("save_file");
    }
  };

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
            width={30}
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
          <FileBrowserModal
            width={40}
            height={35}
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
                NEXT_ACTION.openFileAfterWarning.function(file);
              }
            }}
            onCancel={() => closeFileBrowser()}
          />
        )}
        {!!isFilenamePromptOpen && (
          <FileNamePromptModal
            width={30}
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
              <Flex pl={2} pr={2}>
                <Flex.Item grow>
                  <Box bold>
                    {filename}{!!is_edited && "*"}
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
                justify="space-between"
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
                      doNext(NEXT_ACTION.saveAsFile);
                    }}
                  />
                </Flex.Item>
                <Flex.Item width={10} />
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
