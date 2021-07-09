import { Fragment } from 'inferno';
import { useBackend } from "tgui/backend";
import { Box, Button, Flex, Icon, Input, LabeledList, Modal, ProgressBar, Section, Stack, Tabs } from "tgui/components";
import { NtosWindow } from "tgui/layouts";

export const NtosEmailClient = (props, context) => {
  const {act, data} = useBackend(context);

  const {
    error,
    current_account,
  } = data;
  return (
    <NtosWindow
      width={600}
      height={550}
    >
      <NtosWindow.Content>
        {!!error && (
          <Modal>
            <Section title="An error has occured">
              <Stack vertical>
                <Stack.Item>
                  {error}
                </Stack.Item>
                <Stack.Item>
                  <Button
                    content="OK"
                    onClick={() =>
                      act("clear_error")
                    }
                  />
                </Stack.Item>
              </Stack>
            </Section>
          </Modal>
        )}
        {!!!current_account && (
          <Stack vertical fill>
            <Stack.Item>
              <Section>
                <Stack>
                  <Stack.Item>
                    <LabeledList>
                      <LabeledList.Item
                        label="Address"
                      >
                        <Input
                          value={data.stored_login}
                        />
                      </LabeledList.Item>
                      <LabeledList.Item
                        label="Password"
                      >
                        <Input
                          placeholder={data.stored_passowrd}
                        />
                      </LabeledList.Item>
                    </LabeledList>
                  </Stack.Item>
                  <Stack.Item>
                    <Button
                      content="Login"
                      icon="key"
                      onClick={() =>
                        act("login")
                      }
                    />
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        ) || (
          <Stack vertical fill>
            <Stack.Item>
              <Section
                title={`User: ${current_account}`}
                buttons={
                  <Fragment>
                    <Button
                      content="Change Pass"
                    />
                    <Button
                      content="Log Out"
                      onClick={() => act("logout")}
                    />
                  </Fragment>
                }
              />
            </Stack.Item>
            <Stack.Item>
              <Tabs>
                <Tabs.Tab>
                  <Icon name="inbox"/> {data.label_inbox}
                </Tabs.Tab>
                <Tabs.Tab>
                  <Icon name="reply"/> {data.label_outbox}
                </Tabs.Tab>
                <Tabs.Tab>
                  <Icon name="ban"/> {data.label_spam}
                </Tabs.Tab>
                <Tabs.Tab>
                  <Icon name="trash"/> {data.label_deleted}
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
            <Stack.Item>

            </Stack.Item>
          </Stack>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
