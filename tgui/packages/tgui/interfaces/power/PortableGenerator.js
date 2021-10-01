import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, LabeledList, NoticeBox, ProgressBar, Section } from 'tgui/components';
import { formatSiUnit } from 'tgui/format';
import { Window } from 'tgui/layouts';

export const PortableGenerator = (props, context) => {
  const { act, data } = useBackend(context);
  const stackPercent = data.fuel_stored / data.fuel_capacity * 100;
  const stackPercentState = (
    stackPercent > 50 && 'good'
    || stackPercent > 15 && 'average'
    || 'bad'
  );
  return (
    <Window
      width={450}
      height={340}
      resizable>
      <Window.Content scrollable>
        {!data.anchored && (
          <NoticeBox>Generator not anchored.</NoticeBox>
        )}
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Power switch">
              <Button
                icon={data.active ? 'power-off' : 'times'}
                onClick={() => act('toggle_power')}
                disabled={!data.ready_to_boot}>
                {data.active ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label={data.fuel_type + ' fuel'}>
              <Box inline color={stackPercentState}>{data.fuel_sheets}</Box>
              {data.fuel_sheets >= 1 && (
                <Button
                  ml={1}
                  icon="eject"
                  disabled={data.active}
                  onClick={() => act('eject')}>
                  Eject
                </Button>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Current fuel level">
              <ProgressBar
                value={stackPercent / 100}
                ranges={{
                  good: [0.1, Infinity],
                  average: [0.01, 0.1],
                  bad: [-Infinity, 0.01],
                }} />
            </LabeledList.Item>
            <LabeledList.Item label="Heat level">
              <ProgressBar
                value={data.temperature_current / data.temperature_max}
                ranges={{
                  good: [-Infinity, 0.6],
                  average: [0.6, 0.8],
                  bad: [0.8, Infinity],
                }}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            <LabeledList.Item label="Power setting">
              <Flex>
                <Flex.Item>
                  <Button
                    icon="minus"
                    onClick={() => act('lower_power')}
                  />
                </Flex.Item>
                <Flex.Item grow>
                  <ProgressBar
                    value={data.output_set}
                    maxValue={data.output_max}
                    ranges={{
                      default: [-Infinity, data.output_safe],
                      average: [data.output_safe, Infinity],
                    }}
                  >
                    {data.output_set} / {data.output_max}
                  </ProgressBar>
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="plus"
                    onClick={() => act('higher_power')}
                  />
                </Flex.Item>
              </Flex>
            </LabeledList.Item>
            <LabeledList.Item label="Power available">
              <Box inline color={!data.connected && 'bad'}>
                {data.connected ? formatSiUnit(data.output_watts, 1, 'W') : "Unconnected"}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
