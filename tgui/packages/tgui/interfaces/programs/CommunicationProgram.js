import { NtosWindow } from "tgui/layouts";
import { Box, Button, ColorBox, Flex, Input, Icon, LabeledList, Modal, Section, Stack, TextArea, TimeDisplay } from "tgui/components";
import { useBackend, useSharedState } from "tgui/backend";
import { toTitleCase } from "common/string";
import { sanitizeText } from "tgui/sanitize";

const AnnouncementPrompt = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    value,
    lengthRequired,
    lengthLimit,
    cooldown,
    onClose=() => {},
    onInput=(value) => {},
    onSend=(message) => {},
    ...rest
  } = props;

  const canSendMessage = () => {
    return !cooldownIsActive()
      && !messageIsEmpty()
      && !messageIsTooShort();
  }

  const cooldownIsActive = () => {
    return !!cooldown && cooldown > 0;
  }
  const messageIsEmpty = () => {
    return !!!value || value?.length == 0;
  }
  const messageIsTooShort = () => {
    if (lengthRequired === undefined)
      return false;
    return lengthRequired > (value?.length || 0);
  }
  return (
    <Section
      buttons={
        <Button
          icon="times"
          onClick={() => onClose()}
        />
      }
      {...rest}
    >
      <LabeledList>
        <LabeledList.Item
          label="Announcing as"
        >
          {data.user.name}{!!data.user.job && `, ${data.user.job}`}
        </LabeledList.Item>
      </LabeledList>
      <TextArea
        value={value}
        height={15}
        mt={2}
        mb={2}
        fluid
        onInput={(e, v) => onInput(v)}
      />
      <Flex
        direction="row"
        justify="space-between"
      >
        <Flex.Item>
          {cooldownIsActive() && (
            <Box>
              <Icon name="times" color="bad"/>
              <Box ml={1} inline>
                Cooldown active: <TimeDisplay
                  value={cooldown}
                  auto="down"
                  format={(h,m,s) => `${m}:${s}`}
                />
              </Box>
            </Box>
          ) || (
            messageIsEmpty() && (
              <Box>
                <Icon name="times" color="bad"/>
                <Box ml={1} inline>
                  Empty
                </Box>
              </Box>
            )
            ) || (
            messageIsTooShort() && (
              <Box>
                <Icon name="times" color="bad"/>
                <Box ml={1} inline>
                  Too short
                </Box>
              </Box>
            )
          )}
        </Flex.Item>
        <Flex.Item>
          <Button
            content="Announce"
            disabled={!canSendMessage()}
            onClick={() => onSend(value)}
          />
        </Flex.Item>
      </Flex>
    </Section>
  );
};

const AlertLevelPrompt = (props, context) => {
  const {
    current = {
      index: -1,
      ref: null,
      title: "Undefined",
      colour: 'white',
    },
    available = [],
    selected = {},

    onClose = () => {},
    onSelect = (obj) => {},
    onApply = (obj) => {},

    ...rest
  } = props;

  return (
    <Section
      {...rest}
      buttons={
        <Button
          icon="times"
          onClick={() => onClose()}
        />
      }
    >
      <Stack
        vertical
        justify="space-even"
      >
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item
              label="Current"
            >
              <Box color={current.colour}>
                {toTitleCase(current.title)}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item grow>
          <Section
            fill
            height={12}
            scrollable
          >
            {available.map(level => (
              <Button.Checkbox
                fluid
                disabled={level.ref === current.ref}
                checked={level.ref === selected?.ref || level.ref === current.ref}
                onClick={() => onSelect(level)}
              >
                <ColorBox
                  color={level.colour}
                  mr={1}
                />
                <Box inline>
                  {toTitleCase(level.title)}
                </Box>
              </Button.Checkbox>
            ))}
          </Section>
        </Stack.Item>
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item
              label="Next"
              buttons={
                <Button
                  content="Apply"
                  disabled={!selected || selected?.ref === current.ref}
                  onClick={() => onApply(selected)}
                />
              }
            >
              {(!!selected && selected?.ref !== current.ref) && (
                <Box inline color={selected.colour}>
                  {toTitleCase(selected.title)}
                </Box>
              ) || (
                <Box inline italic color="grey">
                  None
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
      </Stack>
    </Section>
  );
};

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
          icon="times"
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
              icon="trash"
              onClick={() => props.onDeleteMessage(message.id)}
            />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

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
    contents: "Head empty.",
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
                icon="print"
                tooltip="Print out"
                tooltipPosition="left"
                onClick={() => props.onPrint(currentMessage.id)}
              />
            </Stack.Item>
          )}
          <Stack.Item>
            <Button
              icon="times"
              tooltip="Close"
              tooltipPosition="left"
              onClick={() => props.onClose()}
            />
          </Stack.Item>
        </Stack>
      }
    >
      {(
        /* I HATE EXTERNAL HTML. I HATE EXTERNAL HTML */
        <Box dangerouslySetInnerHTML={
          { __html: sanitizeText(currentMessage.contents) }
        } />
      )}
    </Section>
  );
};

export const CommunicationProgram = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    all_security_levels,

    emagged,
    net_comms,
    net_syscont,
    have_printer,

    isAI,
    authenticated,
    boss_short,
    boss_name,

    cooldown_announcement,

    cannot_change_security_level,
    is_high_security_level,
    security_levels = [],

    messages = [],
    message_deletion_allowed,
    has_central_command,
    evac_options,
  } = data;

  const currentAlertLevel = all_security_levels.find(level => {
    return level.ref === data.current_security_level_ref;
  });
  const availableAlertLevels = all_security_levels.filter(level => {
    return !!security_levels.find(option => option.ref === level.ref);
  });

  const [
    currentMode,
    setCurrentMode,
  ] = useSharedState(context, 'currentMode', -1);

  const [
    announcement,
    setAnnouncement
  ] = useSharedState(context, 'announcement', null)

  const [
    selectedAlertLevel,
    setSelectedAlertLevel
  ] = useSharedState(context, 'selectedAlertLevel', null)

  const [
    selectedMessage,
    setSelectedMessage,
  ] = useSharedState(context, 'selectedMessage', 0);

  const MODES = {
    announcement: 0,
    alert_level: 1,
    view_messages_list: 2,
    view_message: 3,
    emergency_message: 4,
    evacuation: 5,
  };

  const VIEW_MODES = [
    (<AnnouncementPrompt
      key={MODES.announcement}
      fill
      title="Make an announcement"
      value={announcement}
      cooldown={cooldown_announcement*10}
      onClose={() => {
        setCurrentMode(-1);
        setAnnouncement(null);
      }}
      onInput={(v) => setAnnouncement(v)}
      onSend={(v) => {
        act('announce', {
          message: v,
        });
        setAnnouncement(null);
      }}
    />),
    (<AlertLevelPrompt
      key={MODES.alert_level}
      fill
      title="Change Readiness"
      current={currentAlertLevel}
      selected={selectedAlertLevel}
      available={availableAlertLevels}
      onClose={() => {
        setCurrentMode(-1)
        setSelectedAlertLevel(null);
      }}
      onSelect={(level) => {
        if (level.ref === selectedAlertLevel?.ref) {
          setSelectedAlertLevel(null);
        }
        else {
          setSelectedAlertLevel(level)
        }
      }}
      onApply={(selection) =>
        act('setalert', {
          target: selection.ref,
        })}
    />),
    (<MessageListView
      fill
      width={30}
      height={30}
      scrollable
      key={MODES.view_messages_list}
      messageList={messages}
      onClose={() => setCurrentMode(-1)}
      onClickMessage={(id) => {
        setSelectedMessage(id);
        setCurrentMode(MODES.view_message);
      }}
      onDeleteMessage={(id) =>
        act('delmessage', {
          target: id,
        })}
    />),
    (<MessageContentView
      fill
      width={30}
      height={30}
      scrollable
      key={MODES.view_message}
      target={selectedMessage}
      messages={messages}
      hasPrinter={have_printer}
      onClose={() => {
        setCurrentMode(MODES.view_messages_list);
        setSelectedMessage(0);
      }}
      onPrint={(id) => act('printmessage', {
        target: id,
      })}
    />),
    (<Box key={MODES.emergency_message} />),
    (<Box key={MODES.evacuation} />),
  ];

  const shouldShowModal = (state) => {
    return !!authenticated && state > -1;
  };

  return (
    <NtosWindow
      width={400}
      height={460}
    >
      <NtosWindow.Content>
        {!authenticated && (
          <Modal backgroundColor="bad">
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
          <Modal maxWidth={30} maxHeight={30} p={0}>
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
                disabled={
                  !authenticated
                  || cannot_change_security_level
                }
                fluid
                onClick={() => setCurrentMode(MODES.alert_level)}
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
  );
};
