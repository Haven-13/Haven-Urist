import { Fragment } from 'inferno';
import { useBackend, useLocalState } from 'tgui/backend';
import { Button, Box, Flex, LabeledControls, LabeledList, NoticeBox, NumberInput, ProgressBar, Section, Table, Tabs, Tooltip } from 'tgui/components';
import { round } from 'common/math';
import { formatSiUnit } from 'tgui/format';
import { capitalize } from 'common/string';
import { Window } from 'tgui/layouts';

export const NpcDialogueInteraction = (props, context) => {
  const { data, act } = useBackend(context);

  const {
    ...rest
  } = props;

  const topics = props.topics || [];

  return (
    <Section
      fill>
      <Box fluid>
        Tell me about...
      </Box>
      {topics.map((topic) => (
        <Button
          key={topic.id}
          onClick={() => act("ask_question", {
            topic: topic.key
          })}
          >
          {capitalize(topic.name)}
        </Button>
      ))}
    </Section>
  )
}

export const NpcTradingInteraction = (props, context) => {
  const { data, act } = useBackend(context);

  const {
    ...rest
  } = props;

  const ACTIONS = {
    buying: 0,
    selling: 1
  }

  const inventory = props.inventory || [];

  const [
    currentAction,
    setCurrentAction,
  ] = useLocalState(context, 'currentAction', ACTIONS.buying);

  return (
    <Section fill>
      <Flex direction="column" justify="space-between">
        <Flex.Item>
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
        </Flex.Item>
        <Flex.Item>
          <Table>
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
              <Table.Cell>

              </Table.Cell>
            </Table.Row>
          </Table>
        </Flex.Item>
        <Flex.Item
          height="100%"
          shrink={1}
          overflowY="auto"
        >
          <Table>
            {inventory.map((item) => (
              <Table.Row>
                <Table.Cell width={21}>
                  {capitalize(item.name)}
                </Table.Cell>
                <Table.Cell textAlign="right">
                  {item.quantity}
                </Table.Cell>
                <Table.Cell textAlign="right">
                  {item.value > 0 ? (<Box>
                    {item.value} Cr
                  </Box>) : (<Box italic>
                    Free
                  </Box>)}
                </Table.Cell>
                <Table.Cell>
                  <Button
                    icon="shopping-cart"
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Flex.Item>
      </Flex>
    </Section>
  )
}

export const NpcInteraction = (props, context) => {
  const { data, act } = useBackend(context);

  const INTERACTIONS = {
    dialogue: 0,
    trading: 1,
  }

  const INTERACTION_SCREENS = [
    (<NpcDialogueInteraction
      topics={data.speechTopics}
    />),
    (<NpcTradingInteraction
      inventory={data.interactInventory}
    />)
  ]

  const [
    currentInteraction,
    setCurrentInteraction,
  ] = useLocalState(context, 'currentInteraction', INTERACTIONS.trading);

  return (
    <Window
      width={400}
      height={500}
    >
      <Window.Content width="100%" height="100%">
        <Section
          title={data.name}>
          <Box italic textAlign="right">
            "{data.greeting}"
          </Box>
        </Section>
        <Section>
          <Tabs
            fluid
            textAlign="center"
          >
            <Tabs.Tab
              selected={currentInteraction === INTERACTIONS.dialogue}
              onClick={() => setCurrentInteraction(INTERACTIONS.dialogue)}
            >
              Dialogue
            </Tabs.Tab>
            <Tabs.Tab
              selected={currentInteraction === INTERACTIONS.trading}
              onClick={() => setCurrentInteraction(INTERACTIONS.trading)}
            >
              Trading
            </Tabs.Tab>
          </Tabs>
        </Section>
        <Section fitted height="60%">
          {INTERACTION_SCREENS[currentInteraction]}
        </Section>
      </Window.Content>
    </Window>
  )
}
