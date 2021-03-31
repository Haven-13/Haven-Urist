import { Fragment } from 'inferno';
import { useBackend, useLocalState } from 'tgui/backend';
import { Box, Button, Dimmer, Icon, LabeledList, ProgressBar, Section, Table } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { range } from 'common/math';

export const PathogenicIncubator = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={300}
      height={330}>
      <Window.Content>
        <Section>
          <Table width="100%">
            <Table.Row>
              <Table.Cell color="label" width="20%">
                Dish:
              </Table.Cell>
              <Table.Cell>
                {data.dishInserted ? (
                  <Box>
                    {data.virus}
                  </Box>
                ) : (
                  <Box color="average">
                    No dish inserted
                  </Box>
                )}
              </Table.Cell>
              <Table.Cell width="20%">
                <Button
                  icon="eject"
                  content="Eject"
                  disabled={!data.dishInserted}
                  onClick={() => act("eject_dish")}
                />
              </Table.Cell>
            </Table.Row>
            <Table.Row>
              <Table.Cell color="label">
                Beaker:
              </Table.Cell>
              <Table.Cell>
                <ProgressBar
                  value={data.chemicalVolume}
                  maxValue={data.maxChemicalVolume}
                  textAlign={data.chemicalsInserted ? "right" : "left"}>
                  {data.chemicalsInserted ? (
                    <Box>
                      {data.chemicalVolume} / {data.maxChemicalVolume} u
                    </Box>
                  ) : (
                    <Box color="average" textAlign="left">
                      No beaker inserted
                    </Box>
                  )}
                </ProgressBar>
              </Table.Cell>
              <Table.Cell>
                <Button
                  icon="eject"
                  content="Eject"
                  disabled={!data.chemicalsInserted}
                  onClick={() => act("eject_chem")}
                />
              </Table.Cell>
            </Table.Row>
          </Table>
        </Section>
        <Section
          title="Conditions"
          buttons={(
            <Fragment>
              <Button
                icon="radiation"
                content="Irradiate"
                onClick={() => act("rad")}
              />
              <Button
                icon="trash"
                content="Flush"
                disabled={!data.systemInUse}
                onClick={() => act("flush")}
              />
            </Fragment>
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Food">
              <ProgressBar
                value={data.foodSupply}
                minValue={data.minFood}
                maxValue={data.maxFood}
                ranges={{
                  good: [-Infinity, Infinity],
                }}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="Radiation">
              <ProgressBar
                value={data.radiation}
                minValue={data.minRadiation}
                maxValue={data.maxRadiation}
                ranges={{
                  good: [-Infinity, 25],
                  average: [25, 50],
                  bad: [50, Infinity],
                }}>
                {data.radiation} &micro;Sv
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item
              label="Toxicity">
              <ProgressBar
                value={data.toxins}
                minValue={data.minToxins}
                maxValue={data.maxToxins}
                ranges={{
                  good: [-Infinity, 25],
                  average: [25, 50],
                  bad: [50, Infinity],
                }}
              />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Virus"
          buttons={(
            <Button
              icon="power-off"
              content="Power"
              disabled={!data.dishInserted}
              selected={data.on}
              onClick={() => act("power")}
            />
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Growth">
              <ProgressBar
                value={data.growth}
                minValue={data.minGrowth}
                maxValue={data.maxGrowth}
                ranges={{
                  good: [50, Infinity],
                  average: [25, 50],
                  bad: [-Infinity, 25],
                }}>
                <Box color={data.virus ? "normal" : "average"}>
                  {data.virus ? data.growth + " %" : "No sample"}
                </Box>
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item
              label="Infectivity">
              <ProgressBar
                value={data.analysed ? data.infectionRate/100 : 0}>
                <Box color={data.virus && data.analysed ? "normal" : "average"}>
                  {data.virus ? data.analysed ? data.infectionRate + " %" : "Unknown" : "No sample"}
                </Box>
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
