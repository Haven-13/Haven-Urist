import { useBackend, useLocalState } from 'tgui/backend';
import { Button, Box, Flex, LabeledList, Section, Stack, Table, Tabs } from 'tgui/components';
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
  const onBuy = props.onBuy;
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
                    onClick={
                      () => onBuy(item.name)
                    }
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


const HandItemPrompt = (props, context) => {
  const isEmpty = props.hand === null;
  const name = props.hand?.name;
  const icon = props.hand?.icon;
  const worth = props.hand?.worth;
  const sellable = props.hand?.sellable;
  const isStorage = props.hand?.isStorage;

  const onSell = props.onSell;

  return (
    <Flex direction="column" justify="space-even">
      <Flex.Item>
        {
          !!!isEmpty && (
            <Box>
              {capitalize(name)}
            </Box>
          ) || (
            <Box italic color="grey">
              This hand is empty
            </Box>
          )
        }
      </Flex.Item>
      <Flex.Item>
        {
          !!!isEmpty && (
            <Flex direction="row" justify="space-between">
              <Flex.Item>
                <Box
                  inline
                  verticalAlign="middle"
                  color={sellable ? 'good' : 'bad'}
                >
                  {
                    !sellable
                    ? (
                      "This trader is not interested"
                    ) : (
                      <Box color='good'>
                        This trader will give you {
                        <Box as="span" color="yellow">
                          {worth}
                        </Box>
                        } Cr
                      </Box>
                    )
                  }
                </Box>
              </Flex.Item>
              <Flex.Item>
                <Button
                  disabled={!sellable}
                  content="Sell"
                  onClick={() => onSell(worth)}
                />
              </Flex.Item>
            </Flex>
          )
        }
      </Flex.Item>
    </Flex>
  )
}

const TradingSellingScreen = (props, context) => {
  const {data, act} = useBackend(context);
  const onSell = props.onSell;
  return (
    <LabeledList>
      <LabeledList.Item
        verticalAlign="top"
        label="Left hand"
      >
        <HandItemPrompt
          hand={data.leftHand}
          onSell={
            (value) => onSell("sell_item_l", value)
          }
        />
      </LabeledList.Item>
      <LabeledList.Item
        verticalAlign="top"
        label="Right hand"
      >
        <HandItemPrompt
          hand={data.rightHand}
          onSell={
            (value) => onSell("sell_item_r", value)
          }
        />
      </LabeledList.Item>
    </LabeledList>
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
      onBuy={
        (item) => act("buy_item", {
          user: data.user,
          buy_item: item
        })
      }
    />),
    (<TradingSellingScreen
      key={ACTIONS.selling}
      onSell={
        (ref, value) => act(ref, {
          user: data.user,
          worth: value
        })
      }
    />)
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
              title={data.name}
              buttons={
                <Button
                  icon="running"
                  tooltip={
                    "Good bye!"
                  }
                  onClick={
                    () => act("close")
                  }
                />
              }>
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
