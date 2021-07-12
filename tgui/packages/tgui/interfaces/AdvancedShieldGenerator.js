import { Fragment } from 'inferno';
import { useBackend } from 'tgui/backend';
import {
  Button, Flex, LabeledControls, LabeledList,
  NumberInput, ProgressBar, Section, Table, Tooltip } from 'tgui/components';
import { round } from 'common/math';
import { formatSiUnit } from 'tgui/format';
import { Window } from 'tgui/layouts';

export const AdvancedShieldGenerator = (props, context) => {
  const { act, data } = useBackend(context);

  const modes = data.modes || [];

  const mitigations = [
    { name: "EM", value: data.mitigationEm },
    { name: "Physical", value: data.mitigationPhysical },
    { name: "Thermal", value: data.mitigationHeat },
    { name: "Max", value: data.mitigationMax },
  ];

  return (
    <Window
      width={600}
      height={370}>
      <Window.Content>
        <Flex
          spacing={1}>
          <Flex.Item maxWidth={20}>
            <Section
              title="System Status"
              buttons={(
                <Button
                  icon="power-off"
                  content="Power"
                  selected={data.running === 2}
                  onClick={() => data.running === 2
                    ? act("begin_shutdown")
                    : act("start_generator")}
                />
              )}>
              <LabeledList>
                <LabeledList.Item
                  label="Status"
                  color={
                    data.running === 2 && !data.overloaded ? "good"
                      : data.running === 1 || (data.running === 2 && data.overloaded) ? "average"
                        : "normal"
                  }>
                  {data.running === 2 ? (
                    data.overloaded ? (
                      "Recovering"
                    ) : (
                      "Online"
                    )) : data.running === 1 ? (
                    "Shutting down"
                  ) : (
                    "Offline"
                  )}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Capacity">
                  <ProgressBar>
                    {formatSiUnit(data.currentEnergy, 0)} / {formatSiUnit(data.maxEnergy, 0, 'J')}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item
                  label="Upkeep">
                  <ProgressBar
                    value={data.upKeepPowerUsage}
                    maxValue={data.inputCap}>
                    {formatSiUnit(data.upkeepPowerUsage, 0, data.inputCap ? '' : 'W')} {data.inputCap > 0
                      ? "/ " + formatSiUnit(data.inputCap, 0, "W") : "(No limit)"}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item
                  label="Power use">
                  <ProgressBar
                    value={data.powerUsage}
                    maxValue={data.inputCap}>
                    {formatSiUnit(data.powerUsage, 0, data.inputCap ? '' : 'W')} {data.inputCap > 0
                      ? "/ " + formatSiUnit(data.inputCap, 0, "W") : "(No limit)"}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item
                  label="Coverage">
                  <ProgressBar
                    value={data.functionalSegments}
                    maxValue={data.totalSegments}>
                    {data.functionalSegments} / {data.totalSegments} m2
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item
                  label="Mitigation">
                  <LabeledList>
                    {mitigations.map(mitigation => (
                      <LabeledList.Item
                        key={mitigation.name}
                        label={mitigation.name}>
                        {mitigation.value} %
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Section
              title="Configuration">
              <LabeledControls>
                <LabeledControls.Item
                  label="Field Radius">
                  <NumberInput
                    value={data.fieldRadius}
                    minValue={1}
                    maxValue={200}
                    width={8}
                    onChange={(e, value) => act("set_range", {
                      set_range: value,
                    })}
                  />
                </LabeledControls.Item>
                <LabeledControls.Item
                  label="Power Limit">
                  <NumberInput
                    value={data.inputCap}
                    minValue={0}
                    maxValue={Infinity}
                    step={100000}
                    width={8}
                    format={value => formatSiUnit(value, 0, 'W')}
                    onDrag={(e, value) => act("set_input_cap", {
                      set_input_cap: round(value),
                    })}
                    onChange={(e, value) => act("set_input_cap", {
                      set_input_cap: round(value),
                    })}
                  />
                </LabeledControls.Item>
              </LabeledControls>
            </Section>
          </Flex.Item>
          <Flex.Item
            grow={1}
            style={{
              overflow: "visible",
            }}>
            <Section
              title="Mode Settings"
              style={{
                overflowX: "visible",
                overflowY: "scroll",
              }}
              fill>
              <Table>
                <Table.Row color="label">
                  <Table.Cell>
                    Mode
                  </Table.Cell>
                  <Table.Cell>
                    Mult
                  </Table.Cell>
                  <Table.Cell>
                    Status
                  </Table.Cell>
                </Table.Row>
                {modes
                  .filter(mode => mode.hacked ? data.hacked : 1)
                  .map(mode => (
                    <Table.Row key={mode.flag}>
                      <Table.Cell position="relative">
                        {mode.name}
                        <Tooltip
                          position="bottom"
                          content={mode.desc}
                        />
                      </Table.Cell>
                      <Table.Cell>
                        x{mode.multiplier}
                      </Table.Cell>
                      <Table.Cell>
                        <Button
                          width={5.5}
                          textAlign="center"
                          selected={mode.status > 0}
                          content={mode.status > 0 ? "Enabled" : "Disabled"}
                          onClick={() => act("toggle_mode", {
                            toggle_mode: mode.flag,
                          })}
                        />
                      </Table.Cell>
                    </Table.Row>
                  ))}
              </Table>
            </Section>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
