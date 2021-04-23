import { NtosWindow } from "tgui/layouts";
import { Box, Button, Input, LabeledList, Modal, Section, Stack } from "tgui/components";
import { useBackend, useLocalState } from "tgui/backend";
import { sanitizeText } from "tgui/sanitize.js"

export const ScannerProgram = (props, context) => {
  const {act, data} = useBackend(context);
  const [
    isWritingToFile,
    setIsWritingToFile
  ] = useLocalState(context, 'isWritingToFile', false);
  const [
    fileName,
    setFileName
  ] = useLocalState(context, 'fileName', '');

  const submitSave = () => {
    act('PRG_save', {
      name: fileName
    });
    closeSavePrompt();
  }
  const closeSavePrompt = () => {
    setIsWritingToFile(0);
    setFileName('');
  }
  return (
    <NtosWindow
      height={460}
      width={400}
    >
      {!!isWritingToFile && (
        <Modal width={24} p={0} justify="space-even">
          <Section title="Save to file" p={1}>
            <Stack vertical>
              <Stack.Item>
                <Input
                  fluid
                  mb={1}
                  placeholder={"File name"}
                  value={fileName}
                  onInput={(e,v) => setFileName(v)}
                  onEnter={(e,v) => submitSave()}
                />
              </Stack.Item>
              <Stack.Item align="right">
                <Button
                  icon='save'
                  content="Save"
                  onClick={() => submitSave()}
                />
                <Button
                  icon='times'
                  content="Cancel"
                  onClick={() => closeSavePrompt()}
                />
              </Stack.Item>
            </Stack>
          </Section>
        </Modal>
      )}
      <NtosWindow.Content>
        <Stack
          vertical
          fill
          justify="space-between"
        >
          <Stack.Item>
            <Section
              title="Driver"
              buttons={
                <Button
                  content="Scan"
                  disabled={!data.check_scanning}
                  onClick={() => act("PRG_scan")}
                />
              }
            >
              <LabeledList>
                <LabeledList.Item
                  label="Type"
                >
                  {data.scanner_name ? data.scanner_name : (
                    <Box italic colour="grey">
                      No installed scanning hardware detected
                    </Box>
                  )}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Status"
                >
                  {data.scanner_name ? (
                    <Box
                      color={data.scanner_enabled ? 'good' : 'bad'}
                    >
                      {data.scanner_enabled ? 'Enabled' : 'Disabled'}
                    </Box>
                  ) : ""}
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title="Buffer"
              fill
              scrollable
              backgroundColor={null}
              buttons={
                <Button
                  icon='save'
                  content="Save"
                  disabled={!data.can_save_scan}
                  onClick={() => setIsWritingToFile(true)}
                />
              }
            >
              {data.data_buffer && (
                // This is absolutely horrific and I don't understand why we still use paperwork in
                // this fucking game. Specially with the current state of the bloody game.
                // You may shoot me for making this illadvised design choice. But, please, do me a favor
                // and shoot the people who wrote the paperwork code too.
                //
                // If you have XSS issues and comes from this file. Nuke this line of code first, please.
                <Box dangerouslySetInnerHTML={{__html: sanitizeText(data.data_buffer)}} />
              ) || (
                <Box italic textAlign="center">
                  The buffer is empty
                </Box>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
