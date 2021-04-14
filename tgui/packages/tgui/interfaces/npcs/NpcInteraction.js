import { useBackend, useLocalState } from 'tgui/backend';
import { Button, Box, Flex, Section, Stack, Table, Tabs } from 'tgui/components';
import { capitalize } from 'common/string';
import { Window } from 'tgui/layouts';

const NpcDialogueInteraction = (props, context) => {
  const { data, act } = useBackend(context);

  const {
    ...rest
  } = props;

  const topics = props.topics || [];

  return (
    <Section
      title={"Let's talk about..."}
      fill>
      {topics.map((topic) => (
        <Button
          key={topic.id}
          onClick={() => act("ask_question", {
            topic: topic.key,
          })}
        >
          {capitalize(topic.name)}
        </Button>
      ))}
    </Section>
  );
};

const TradingBuyingList = (props, context) => {
  const inventory = props.inventory;
  return(
    <Stack vertical>
      <Stack.Item>
        <Table ml={1} mr={1}>
          <Table.Row
            bold
            lineHeight={2}
            color="yellow"
          >
            <Table.Cell width={20}>
              Item
            </Table.Cell>
            <Table.Cell>
              Stock
            </Table.Cell>
            <Table.Cell>
              Price
            </Table.Cell>
            <Table.Cell />
          </Table.Row>
        </Table>
      </Stack.Item>
      <Stack.Item>
        <Box fitted ml={1} height={22} overflowY="auto">
          <Table>
            {inventory.map((item) => (
              <Table.Row key={item.name}>
                <Table.Cell width={21}>
                  {capitalize(item.name)}
                </Table.Cell>
                <Table.Cell textAlign="right">
                  {item.quantity}
                </Table.Cell>
                <Table.Cell textAlign="right">
                  {item.value > 0 ? (
                    <Box>
                      {item.value} Cr
                    </Box>
                  ) : (
                    <Box italic>
                      Free
                    </Box>
                  )}
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="shopping-cart"
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Box>
      </Stack.Item>
    </Stack>
  )
}

const TradingSellingScreen = (props, context) => {
  return(
    <Stack>

    </Stack>
  )
}

const NpcTradingInteraction = (props, context) => {
  const { data, act } = useBackend(context);

  const {
    ...rest
  } = props;

  const inventory = props.inventory || [];

  const ACTIONS = {
    buying: 0,
    selling: 1,
  };

  const ACTION_SCREENS = [
    (<TradingBuyingList
      key={ACTIONS.buying}
      inventory={inventory}
    />),
    (<TradingSellingScreen
      key={ACTIONS.selling}
    />),
  ];

  const [
    currentAction,
    setCurrentAction,
  ] = useLocalState(context, 'currentAction', ACTIONS.buying);

  return (
    <Stack vertical>
      <Stack.Item>
        <Tabs fluid textAlign="center">
          <Tabs.Tab
            selected={currentAction === ACTIONS.buying}
            onClick={() => setCurrentAction(ACTIONS.buying)}
          >
            Buying
          </Tabs.Tab>
          <Tabs.Tab
            selected={currentAction === ACTIONS.selling}
            onClick={() => setCurrentAction(ACTIONS.selling)}
          >
            Selling
          </Tabs.Tab>
        </Tabs>
      </Stack.Item>
      <Stack.Item>
        {ACTION_SCREENS[currentAction]}
      </Stack.Item>
    </Stack>
  );
};

export const NpcInteraction = (props, context) => {
  const { data, act } = useBackend(context);

  const INTERACTIONS = {
    dialogue: 0,
    trading: 1,
  };

  const INTERACTION_SCREENS = [
    (<NpcDialogueInteraction
      key={INTERACTIONS.dialogue}
      topics={data.speechTopics}
    />),
    (<NpcTradingInteraction
      key={INTERACTIONS.trading}
      inventory={data.interactInventory}
    />),
  ];

  const [
    currentInteraction,
    setCurrentInteraction,
  ] = useLocalState(context, 'currentInteraction', INTERACTIONS.trading);

  return (
    <Window
      width={400}
      height={500}
    >
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section
              title={data.name}>
              <Box italic textAlign="right">
                &#34;{data.greeting}&#34;
              </Box>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Tabs
                fluid
                textAlign="center"
              >
                <Tabs.Tab
                  selected={currentInteraction === INTERACTIONS.dialogue}
                  onClick={
                    () => setCurrentInteraction(INTERACTIONS.dialogue)
                  }
                >
                  Dialogue
                </Tabs.Tab>
                <Tabs.Tab
                  selected={currentInteraction === INTERACTIONS.trading}
                  onClick={
                    () => setCurrentInteraction(INTERACTIONS.trading)
                  }
                >
                  Trading
                </Tabs.Tab>
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill>
              {INTERACTION_SCREENS[currentInteraction]}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
