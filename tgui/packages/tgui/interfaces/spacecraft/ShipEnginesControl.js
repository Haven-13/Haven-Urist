import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { round } from 'common/math';
import { AnimatedNumber, Button, LabeledList, Section, NumberInput, Slider, Table } from 'tgui/components';

export const ShipEnginesControl = (props, context) => {
  const { act, data } = useBackend(context);
  const enginesInfo = data.enginesInfo || [];
  return (
    <Window
      width={600}
      height={400}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="All Engines">
              <Button
                selected={data.globalState}
                content="Start"
                onClick={() => { act("global_set_state", {
                  state: 1,
                }); }}
              />
              <Button
                selected={!data.globalState}
                content="Shutdown"
                onClick={() => { act("global_set_state", {
                  state: 0,
                }); }}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="Throttle">
              <Slider
                value={data.globalThrustLimit}
                minValue={0}
                maxValue={1}
                step={0.05}
                stepPixelSize={10}
                format={value => (round(value * 100))}
                unit="%"
                onChange={(e, value) => { act("set_global_limit", {
                  set_global_limit: round(value, 2),
                }); }}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="Total Thrust">
              <AnimatedNumber
                value={data.totalThrust}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <Table>
            <Table.Row>
              <Table.Cell color="average">
                Id
              </Table.Cell>
              <Table.Cell>
                Type
              </Table.Cell>
              <Table.Cell>
                Location
              </Table.Cell>
              <Table.Cell>
                Thrust
              </Table.Cell>
              <Table.Cell>
                Throttle
              </Table.Cell>
              <Table.Cell>
                Power
              </Table.Cell>
            </Table.Row>
            {enginesInfo.map((engine, index) => (
              <Table.Row key={engine.reference}>
                <Table.Cell color="average">
                  #{index + 1}
                </Table.Cell>
                <Table.Cell>
                  {engine.type}
                </Table.Cell>
                <Table.Cell>
                  {engine.locationName}
                </Table.Cell>
                <Table.Cell color={engine.on ? "good" : "bad"}>
                  {engine.on ? engine.thrust : "Off"}
                </Table.Cell>
                <Table.Cell>
                  <NumberInput
                    width={5}
                    value={engine.thrustLimit}
                    minValue={0}
                    maxValue={1}
                    step={0.05}
                    format={value => (round(value*100))}
                    unit="%"
                    onChange={(e, value) => act("engine", {
                      engine: engine.reference,
                      action: "set_limit",
                      value: round(value, 2),
                    })}
                  />
                </Table.Cell>
                <Table.Cell>
                  <Button
                    selected={engine.on}
                    content="Toggle"
                    onClick={() => act("engine", {
                      engine: engine.reference,
                      action: "toggle",
                    })}
                  />
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
