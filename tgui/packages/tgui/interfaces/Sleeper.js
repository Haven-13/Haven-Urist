import { useBackend } from 'tgui/backend';
import { AnimatedNumber, Box, Flex, Section, LabeledList, Button, ProgressBar, Table } from 'tgui/components';
import { round } from 'common/math';
import { Fragment } from 'inferno';
import { Window } from 'tgui/layouts';
import { MedicalScanInfo } from './common/MedicalScans';

const MedicineInjection = (props, context) => {
  const {act} = useBackend(context);
  const amounts = [5,10,15];
  const {medicine} = props;
  return (
    <Fragment>
      {amounts.map(x => (
        <Button
          key={x}
          content={x + "u"}
          onClick={() => act('chemical', {
            chemical: medicine,
            amount: x,
          })}
        />
      ))}
    </Fragment>
  )
}

export const Sleeper = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    occupant = {name},
    filtering,
    pump,
    stasis,
    beaker
  } = data;
  const preSortReagents = data.reagents || [];
  const reagents = preSortReagents.sort((a, b) => {
    const descA = a.name.toLowerCase();
    const descB = b.name.toLowerCase();
    if (descA < descB) {
      return -1;
    }
    if (descA > descB) {
      return 1;
    }
    return 0;
  });
  return (
    <Window
      width={620}
      height={465}>
      <Window.Content>
        <Section
          title={<Box inline="true">Occupant:&emsp;
            {occupant ?
              occupant.name :
              (<Box color="grey" inline="true"><i>None</i></Box>)}
            </Box>}
          buttons={
            <Button
              disabled={!occupant}
              content="Eject Occupant"
              onClick={() => act('eject')}
            />
          }
        >
          <Flex
            direction="row"
            spacing={1}
            justify="space-evenly">
            <Flex.Item
              maxWidth="300px"
            >
              <MedicalScanInfo />
            </Flex.Item>
            <Flex.Item
              maxWidth="300px"
            >
              <Section
                title="Actions"
              >
                <Table>
                  <Table.Row>
                    <Table.Cell
                      textAlign="center"
                    >
                      <Button
                        selected={stasis > 1}
                        content="Toggle"
                        onClick={()=>act('stasis', {stasis: stasis > 1 ? 1 : 5})}
                      />
                    </Table.Cell>
                    <Table.Cell
                      textAlign="center"
                    >
                      <Button
                        selected={filtering}
                        content="Toggle"
                        onClick={()=>act('filter')}
                      />
                    </Table.Cell>
                    <Table.Cell
                      textAlign="center"
                    >
                      <Button
                        selected={pump}
                        content="Toggle"
                        onClick={()=>act('pump')}
                      />
                    </Table.Cell>
                    <Table.Cell
                      textAlign="center"
                    >
                      <Button
                        disabled={beaker < 0}
                        content="Eject"
                        onClick={()=> act('beaker')}
                      />
                    </Table.Cell>
                  </Table.Row>
                  <Table.Row>
                  <Table.Cell
                      color="label"
                      width="25%"
                      textAlign="center"
                    >
                      Stasis
                    </Table.Cell>
                    <Table.Cell
                      color="label"
                      width="25%"
                      textAlign="center"
                    >
                      Dialysis
                    </Table.Cell>
                    <Table.Cell
                      color="label"
                      width="25%"
                      textAlign="center"
                    >
                      Stomach Pump
                    </Table.Cell>
                    <Table.Cell
                      color="label"
                      width="25%"
                      textAlign="center"
                    >
                      Beaker
                    </Table.Cell>
                  </Table.Row>
                </Table>
                <hr/>
                <LabeledList>
                  <LabeledList.Item label="Loaded container">
                    {beaker ? beaker.name : (<Box color="grey"><i>None</i></Box>)}
                  </LabeledList.Item>
                </LabeledList>
                <ProgressBar
                  value = {round(beaker.total - beaker.free, 1)}
                  minValue={0}
                  maxValue={beaker.total}
                  children={
                    <Fragment>
                      <AnimatedNumber value={round(beaker.total - beaker.free, 1)}/> / {beaker.total} u
                    </Fragment>
                  }
                />
              </Section>
              <Section
                title="Medicines"
                minHeight="205px"
              >
                <LabeledList style="width:100%">
                  {reagents.map(reagent => (
                    <LabeledList.Item
                      style="width:100%"
                      key={reagent.name}
                      label={reagent.name}
                    >
                      <MedicineInjection
                        medicine={reagent.name}
                      />
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              </Section>
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
