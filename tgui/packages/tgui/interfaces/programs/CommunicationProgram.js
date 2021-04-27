import { NtosWindow } from "tgui/layouts";
import { Box, Button, Input, Icon, LabeledList, Modal, Section, Stack } from "tgui/components";
import { useBackend, useSharedState } from "tgui/backend";
import { toTitleCase } from "common/string"
import { sanitizeText } from "tgui/sanitize"

const MessageListView = (props, context) => {
  const {
    ...rest
  } = props;
  const messages = props.messageList;
  return (
    <Section
      {...rest}
      title="Message List"
      buttons={
        <Button
          icon='times'
          onClick={() => props.onClose()}
        />
      }
    >
      <Stack vertical>
        {messages.map(message => (
          <Stack.Item key={message.id}>
            <Button
              content={message.title}
              onClick={() => props.onClickMessage(message.id)}
            />
            <Button.Confirm
              icon='trash'
              onClick={() => props.onDeleteMessage(message.id)}
            />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  )
}

const MessageContentView = (props, context) => {
  const {
    ...rest
  } = props;
  const message = props.target || 0;
  const messages = props.messages || [];
  const currentMessage = messages.find(msg => {
    return msg.id === message;
  }) || {
    title: "None",
    contents: "Head empty."
  };
  return (
    <Section
      {...rest}
      title={currentMessage.title}
      buttons={
        <Stack>
          {!!props.hasPrinter && (
            <Stack.Item>
              <Button
                icon='print'
                tooltip="Print out"
                tooltipPosition='left'
                onClick={() => props.onPrint()}
              />
            </Stack.Item>
          )}
          <Stack.Item>
            <Button
              icon='times'
              tooltip="Close"
              tooltipPosition='left'
              onClick={() => props.onClose()}
            />
          </Stack.Item>
        </Stack>
      }
    >
      {(
        /* I HATE EXTERNAL HTML. I HATE EXTERNAL HTML */
        <Box dangerouslySetInnerHTML={{__html: sanitizeText(currentMessage.contents)}} />
      )}
    </Section>
  )
}

export const CommunicationProgram = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    all_security_levels,

    emagged,
    net_comms,
    net_syscont,
    have_printer,

    message_line1,
    message_line2,
    state,
    isAI,
    authenticated,
    boss_short,
    boss_name,

    cannot_change_security_level,
    current_security_level_is_high_security_level,
    security_levels = [],

    messages = [],
    message_deletion_allowed,
    message_current_id,
    has_central_command,
    evac_options
  } = data;
  const currentAlertLevel = all_security_levels.find(level => {
    return level.ref === data.current_security_level_ref
  });

  const MODES = {
    announcement: 0,
    alert_level: 1,
    status_editor: 2,
    view_messages_list: 3,
    view_message: 4,
    emergency_message: 5,
    evacuation: 6
  }

  const VIEW_MODES = [
    (<Box key={MODES.announcement} />),
    (<Box key={MODES.alert_level} />),
    (<Box key={MODES.status_editor} />),
    (<MessageListView
      fill
      scrollable
      key={MODES.view_messages_list}
      messageList={messages}
      onClose={() => setCurrentMode(-1)}
      onClickMessage={(id) => {
        setCurrentMode(MODES.view_message);
        act('viewmessage', {
          target: id
        })
      }}
      onDeleteMessage={(id) =>
        act('delmessage', {
          target: id
        })
      }
    />),
    (<MessageContentView
      fill
      scrollable
      key={MODES.view_message}
      target={message_current_id}
      messages={messages}
      hasPrinter={have_printer}
      onClose={() => {
        setCurrentMode(MODES.view_messages_list)
        act('viewmessage', {
          target: 0
        })
      }}
      onPrint={() => act('printmessage')}
    />),
    (<Box key={MODES.emergency_message} />),
    (<Box key={MODES.evacuation} />),
  ];

  const [
    currentMode,
    setCurrentMode
  ] = useSharedState(context, 'currentMode', -1);

  const shouldShowModal = (state) => {
    return !!authenticated && state > -1;
  };

  return (
    <NtosWindow
      width={400}
      height={460}
    >
      <NtosWindow.Content>
        {!!!authenticated && (
          <Modal backgroundColor='bad'>
            <Stack vertical align="center" m={3}>
              <Stack.Item>
                <Icon
                  name="lock"
                  size={3}
                />
              </Stack.Item>
              <Stack.Item>
                <Box bold>
                  INSUFFICIENT ACCESS
                </Box>
              </Stack.Item>
            </Stack>
          </Modal>
        )}
        {shouldShowModal(currentMode) && (
          <Modal width={30} height={30} p={0}>
            {VIEW_MODES[currentMode]}
          </Modal>
        )}
        <Stack vertical>
          <Stack.Item>
            <Section
              title="Command"
            >
              <Section>
                <LabeledList>
                  <LabeledList.Item
                    label="Current Readiness Level"
                  >
                    <Box bold color={currentAlertLevel.colour}>
                      {toTitleCase(currentAlertLevel.title)}
                    </Box>
                  </LabeledList.Item>
                </LabeledList>
              </Section>
              <Button
                content="Make an Announcement"
                disabled={!authenticated}
                fluid
                onClick={() => setCurrentMode(MODES.announcement)}
              />
              <Button
                content="Change Readiness Level"
                disabled={!authenticated}
                fluid
                onClick={() => setCurrentMode(MODES.alert_level)}
              />
              <Button
                content="Set Status Display Message"
                disabled={!authenticated}
                fluid
                onClick={() => setCurrentMode(MODES.status_editor)}
              />
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section
              title="Communication"
            >
              <Section>
                <LabeledList>
                  <LabeledList.Item
                    label="No. Messages"
                  >
                    <Box bold>
                      {messages.length}
                    </Box>
                  </LabeledList.Item>
                </LabeledList>
              </Section>
              <Button
                content="View Messages"
                disabled={!authenticated}
                fluid
                onClick={() => setCurrentMode(MODES.view_messages_list)}
              />
              <Button
                content="Broadcast Emergency Message"
                disabled={!authenticated}
                fluid
                onClick={() => setCurrentMode(MODES.emergency_message)}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  )
};
