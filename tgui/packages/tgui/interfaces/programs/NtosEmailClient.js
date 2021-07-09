import { Fragment } from 'inferno';
import { sanitizeText } from 'tgui/sanitize';
import { useBackend, useSharedState } from "tgui/backend";
import { Box, Button, Flex, Icon, Input, LabeledList, Modal, ProgressBar, Section, Stack, Tabs, TextArea } from "tgui/components";
import { NtosWindow } from "tgui/layouts";
import { ErrorMessageModal } from './components';

const EmailClientToolbar = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Section
      title={`User: ${data.current_account}`}
      buttons={
        <Fragment>
          <Button
            icon="key"
            content="Change Pass"
          />
          <Button
            content="Log Out"
            icon="sign-out-alt"
            onClick={() =>
              act("logout")}
          />
        </Fragment>
      }
    >
      {props.children}
    </Section>
  );
};


const NewMessageView = (props, context) => {
  const { act, data } = useBackend(context);

  const [
    isEditing,
    setIsEditing,
  ] = useSharedState(context, "isEditing", true);

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section
          title="New Message"
          buttons={(
            <Flex>
              <Flex.Item>
                <Button
                  icon="upload"
                  content="Send"
                  onClick={() => act("send")}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon="paperclip"
                  content="Add Attachment"
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon="times"
                  content="Cancel"
                  onClick={() => act("cancel")}
                />
              </Flex.Item>
            </Flex>
          )}
        >
          <LabeledList>
            <LabeledList.Item label="Recipient">
              <Flex>
                <Flex.Item grow>
                  <Input
                    fluid
                    value={data.msg_recipient}
                    onInput={(e, v) => act("edit_recipient", {
                      value: v,
                    })}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="address-book"
                  />
                </Flex.Item>
              </Flex>
            </LabeledList.Item>
            <LabeledList.Item label="Topic">
              <Input
                fluid
                value={data.msg_title}
                onInput={(e, v) => act("edit_title", {
                  value: v,
                })}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section
          title="Message Body"
          fill
          scrollable
          buttons={(
            <Button.Checkbox
              checked={isEditing}
              onClick={() => setIsEditing(!isEditing)}
            >
              {isEditing && "Editing" || "Edit"}
            </Button.Checkbox>
          )}
        >
          {isEditing && (
            <TextArea
              height="100%"
              value={data.msg_body}
              onInput={(e, v) => act("edit_body", {
                text: v,
              })}
            />
          ) || (
            /* I HATE EXTERNAL HTML. I HATE EXTERNAL HTML */
            <Box dangerouslySetInnerHTML={
              { __html: sanitizeText(data.msg_preview) }
            } />
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const ViewMessageView = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Stack vertical fill>
      <Stack.Item>
        <Section
          title="Viewing Message"
          buttons={(
            <Flex>
              <Flex.Item>
                <Button
                  icon="reply"
                  content="Reply"
                  onClick={() => act("send")}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon="times"
                  content="Cancel"
                  onClick={() => act("cancel")}
                />
              </Flex.Item>
            </Flex>
          )}
        >
          <LabeledList>
            <LabeledList.Item label="Sender">
              {data.cur_source}
            </LabeledList.Item>
            <LabeledList.Item label="Topic">
              {data.cur_title}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item grow>
        <Section title="Message Body" fill scrollable>
          {(
            /* I HATE EXTERNAL HTML. I HATE EXTERNAL HTML */
            <Box dangerouslySetInnerHTML={
              { __html: sanitizeText(data.cur_body) }
            } />
          )}
        </Section>
      </Stack.Item>
    </Stack>
  );
};

const MessagesListView = (props, context) => {
  const { act, data } = useBackend(context);

  const FOLDERS = {
    inbox: {
      label: "Inbox",
      dataKey: "label_inbox",
      icon: 'inbox',
    },
    sent: {
      label: "Sent",
      dataKey: "label_outbox",
      icon: 'reply',
    },
    spam: {
      label: "Spam",
      dataKey: "label_spam",
      icon: 'trash',
    },
    deleted: {
      label: "Deleted",
      dataKey: "label_deleted",
      icon: 'ban',
    },
  };

  return (
    <Stack vertical fill>
      <Stack.Item>
        <EmailClientToolbar>
          <Button
            content="New Message"
            onClick={() => act("new_message")}
          />
        </EmailClientToolbar>
      </Stack.Item>
      <Stack.Item grow>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <Tabs fluid>
                {
                  Object.keys(FOLDERS).map((folder) => {
                    let f = FOLDERS[folder];
                    return (
                      <Tabs.Tab
                        key={folder}
                        selected={f.label === data.folder}
                        onClick={() => act("set_folder", {
                          folder: f.label,
                        })}
                      >
                        <Icon name={f.icon} /> {data[f.dataKey]}
                      </Tabs.Tab>
                    );
                  })
                }
              </Tabs>
            </Stack.Item>
            <Stack.Item grow>
              <Section fill scrollable>
                {!!data.messages.length && (
                  <Stack vertical>
                    {data.messages.map((message, index) => (
                      <Stack.Item key={index}>
                        <Button
                          fluid
                          onClick={() => act("view", {
                            message: message.uid,
                          })}
                        >
                          <Flex justify="space-between" >
                            <Flex.Item bold width={22}>
                              {message.source}
                            </Flex.Item>
                            <Flex.Item grow>
                              {message.title}
                            </Flex.Item>
                            <Flex.Item width={6}>
                              {message.timestamp}
                            </Flex.Item>
                          </Flex>
                        </Button>
                      </Stack.Item>
                    ))}
                  </Stack>
                ) || (
                  <Box italic fluid>
                    There are no messages in {data.folder}
                  </Box>
                )}
              </Section>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};

export const NtosEmailClient = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    error,
    current_account,
    new_message,
    view_message,
  } = data;

  return (
    <NtosWindow
      width={650}
      height={550}
    >
      <NtosWindow.Content>
        {!!error && (
          <ErrorMessageModal
            message={error}
            onClick={() => act("clear_error")}
          />
        )}
        {!current_account && (
          <Stack vertical fill justify="space-around">
            <Stack.Item>
              <Section title="Welcome">
                <Stack vertical>
                  <Stack.Item grow>
                    <LabeledList>
                      <LabeledList.Item
                        label="Address"
                      >
                        <Input
                          value={data.stored_login}
                          onInput={(e, v) => act("edit_login", {
                            value: v,
                          })}
                          fluid
                        />
                      </LabeledList.Item>
                      <LabeledList.Item
                        label="Password"
                      >
                        <Input
                          placeholder={data.stored_password}
                          onInput={(e, v) => act("edit_password", {
                            value: v,
                          })}
                          fluid
                        />
                      </LabeledList.Item>
                    </LabeledList>
                  </Stack.Item>
                  <Stack.Item align="center">
                    <Button
                      content="Login"
                      icon="key"
                      onClick={() =>
                        act("login")}
                    />
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        ) || (
          (!!new_message && (<NewMessageView />))
          || (!!view_message && (<ViewMessageView />))
          || <MessagesListView />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
