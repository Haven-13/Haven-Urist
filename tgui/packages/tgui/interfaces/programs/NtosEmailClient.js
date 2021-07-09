import { Fragment } from 'inferno';
import { sanitizeText } from 'tgui/sanitize';
import { useBackend, useLocalState, useSharedState } from "tgui/backend";
import { Box, Button, Flex, Icon, Input, LabeledList, Modal, ProgressBar, Section, Stack, Tabs, TextArea } from "tgui/components";
import { NtosWindow } from "tgui/layouts";
import { ErrorMessageModal, FileNamePromptModal } from './components';

const PasswordChangeModal = (props, context) => {
  const {
    onApply = (a,b,c) => {},
    onCancel = () => {},
    ...rest
  } = props;

  const [
    originalPassword,
    setOriginalPassword
  ] = useLocalState(context, "originalPassword", "");
  const [
    firstNewPassword,
    setFirstNewPassword
  ] = useLocalState(context, "firstNewPassword", "");
  const [
    secondNewPassword,
    setSecondNewPassword
  ] = useLocalState(context, "secondNewPassword", "");

  return (
    <Modal
      {...rest}
      p={0}
    >
      <Section title="Change Password">
        <Stack vertical>
          <Stack.Item>
            <LabeledList>
              <LabeledList.Item label="Original">
                <Input
                  fluid
                  value={originalPassword}
                  onInput={(e,v) => setOriginalPassword(v)}
                />
              </LabeledList.Item>
              <LabeledList.Item label="New">
                <Input
                  fluid
                  value={firstNewPassword}
                  onInput={(e,v) => setFirstNewPassword(v)}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Repeat New">
                <Input
                  fluid
                  value={secondNewPassword}
                  onInput={(e,v) => setSecondNewPassword(v)}
                />
              </LabeledList.Item>
            </LabeledList>
          </Stack.Item>
          <Stack.Item align="center">
            <Flex fill>
              <Flex.Item>
                <Button
                  icon="key"
                  disabled={
                    (originalPassword.length < 3) ||
                    (firstNewPassword.length < 3) ||
                    (secondNewPassword.length < 3)
                  }
                  content="Apply"
                  onClick={() => onApply(originalPassword, firstNewPassword, secondNewPassword)}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  icon="times"
                  content="Cancel"
                  onClick={() => onCancel()}
                />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  )
}


const NewMessageView = (props, context) => {
  const { act, data } = useBackend(context);

  const [
    isEditing,
    setIsEditing,
  ] = useSharedState(context, "isEditing", true);

  return (
    <Fragment>
      {!!data.addressbook && (
        <Modal width={30} height={30} p={0}>
          <Section
            title="Address Book"
            buttons={(
              <Button
                icon="times"
                content="Cancel"
                onClick={() => act("close_addressbook")}
              />
            )}
            scrollable
            fill
          >
            <Stack vertical fill>
              {data.accounts.map((account, index) => (
                <Stack.Item key={index}>
                  <Button
                    fluid
                    content={account.login}
                    onClick={() => act("set_recipient", {
                      value: account.login
                    })}
                  />
                </Stack.Item>
              ))}
            </Stack>
          </Section>
        </Modal>
      )}
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
                    onClick={() => act("addattachment")}
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
                      onClick={(e, v) => act("addressbook")}
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
              {!!data.msg_hasattachment && (
                <LabeledList.Item label="Attachment">
                  <Flex justify="space-between" fill>
                    <Flex.Item align="center" grow>
                      {data.msg_attachment_filename} ({data.msg_attachment_size} GQ)
                    </Flex.Item>
                    <Flex.Item align="center">
                      <Button
                        icon="times"
                        onClick={() => act("remove_attachment")}
                      />
                    </Flex.Item>
                  </Flex>
                </LabeledList.Item>
              )}
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
    </Fragment>
  );
};

const ViewMessageView = (props, context) => {
  const { act, data } = useBackend(context);

  const [
    isSavingFile,
    setSavingFile
  ] = useSharedState(context, "isSavingFile", false);

  return (
    <Fragment>
      {!!isSavingFile && (
        <FileNamePromptModal
          onAccept={(name) => {
            setSavingFile(false);
            act("save", {
              name: name,
              save: data.cur_uid
            });
          }}
          onCancel={() => setSavingFile(false)}
        />
      )}
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
                    onClick={() => act("reply", {
                      reply: data.cur_uid
                    })}
                  />
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="save"
                    content="Save"
                    onClick={() => setSavingFile(true)}
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
              {!!data.cur_hasattachment && (
                <LabeledList.Item label="Attachment">
                  <Button
                    onClick={() => act("downloadattachment")}
                  >
                    {data.cur_attachment_filename} ({data.cur_attachment_size} GQ)
                  </Button>
                </LabeledList.Item>
              )}
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
    </Fragment>
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

  const [
    isChangingPassword,
    setChangingPassowrd,
  ] = useSharedState(context, "isChangingPassword", false);

  return (
    <Fragment>
      {isChangingPassword && (
          <PasswordChangeModal
            width={40}
            onApply={(a,b,c) => {
              setChangingPassowrd(false);
              act("changepassword", {
                old: a,
                new: b,
                new_verify: c,
              })
            }}
            onCancel={() => setChangingPassowrd(false)}
          />
      )}
      <Stack vertical fill>
        <Stack.Item>
          <Section
            title={`User: ${data.current_account}`}
            buttons={
              <Fragment>
                <Button
                  icon="key"
                  content="Change Pass"
                  onClick={() =>
                    setChangingPassowrd(true)
                  }
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
            <Button
              content="New Message"
              onClick={() => act("new_message")}
            />
          </Section>
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
                          <Flex>
                            <Flex.Item grow>
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
                                  <Flex.Item width={2}>
                                    {!!message.attachment && (
                                      <Icon
                                        name="paperclip"
                                      />
                                    )}
                                  </Flex.Item>
                                  <Flex.Item grow>
                                    {message.title}
                                  </Flex.Item>
                                  <Flex.Item width={6}>
                                    {message.timestamp}
                                  </Flex.Item>
                                </Flex>
                              </Button>
                            </Flex.Item>
                            <Flex.Item>
                              <Button.Confirm
                                icon="trash"
                                onClick={() => act("delete", {
                                  delete: message.uid
                                })}
                              />
                            </Flex.Item>
                          </Flex>
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
    </Fragment>
  );
};

export const NtosEmailClient = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    downloading,
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
          <Stack vertical fill>
            {!!downloading && (
              <Stack.Item>
                <Section
                  title={`Downloading '${data.down_filename}'`}
                  buttons={(
                    <Button
                      icon="times"
                      onClick={() => act("canceldownload")}
                    />
                  )}
                >
                  <ProgressBar
                    value={data.down_progress}
                    maxValue={data.down_size}
                  >
                    {data.down_progress} / {data.down_size} GQ
                  </ProgressBar>
                </Section>
              </Stack.Item>
            )}
            <Stack.Item grow>
              {
                (!!new_message && (<NewMessageView />))
                || (!!view_message && (<ViewMessageView />))
                || <MessagesListView />
              }
            </Stack.Item>
          </Stack>
        )}
      </NtosWindow.Content>
    </NtosWindow>
  );
};
