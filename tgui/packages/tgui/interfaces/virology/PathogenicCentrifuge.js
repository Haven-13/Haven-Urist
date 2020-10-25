import { Fragment } from 'inferno';
import { useBackend } from 'tgui/backend';
import { Box, Button, LabeledList, Section, Table } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { range } from 'common/math';

export const PathogenicCentrifuge = (props, context) => {
  const { act, data } = useBackend(context);

  const antigens = data.antigens || [];
  const pathogens = data.pathogens || [];

  const indices = antigens.length > 0 || pathogens > 0 ?
    range(0, Math.max(antigens.length, pathogens.length)-1) : [];

  return (
    <Window
      width={300}
      height={300}
      resizable
    >
      <Window.Content>
        <Section
          title="Sample"
          buttons={(
            <Fragment>
              <Button
                icon="eject"
                content="Eject"
                disabled={!data.sample_inserted}
                onClick={() => act("sample")}
              />
              <Button
                icon="print"
                content="Print"
                onClick={() => act("print")}
              />
            </Fragment>
          )}
        >
          <LabeledList>
            <LabeledList.Item
              label="Sample type"
            >
              {data.sample_inserted ? (
                <Box>
                  {data.is_antibody_sample ? "Antibody" : "Blood"} sample
                </Box>
              ):(
                <Box color="bad">
                  No vial detected
                </Box>
              )}
            </LabeledList.Item>
          </LabeledList>
          <Table mt={2}>
            <Table.Row
              color="label"
            >
              <Table.Cell>
                Antigens
              </Table.Cell>
              <Table.Cell>
                Pathogens
              </Table.Cell>
            </Table.Row>
            {indices.length > 0 ? indices.map(idx => (
              <Table.Row key={idx}>
                <Table.Cell>
                  {idx < antigens.length ? (
                    <Fragment>
                      <Button

                      />
                    </Fragment>
                  ) : null}
                </Table.Cell>
                <Table.Cell>
                  {idx < pathogens.length ? (
                    <Fragment>

                    </Fragment>
                  ) : null}
                </Table.Cell>
              </Table.Row>
            )) : (
              <Table.Row>
                <Table.Cell color="grey">
                  None detected
                </Table.Cell>
                <Table.Cell color="grey">
                  None detected
                </Table.Cell>
              </Table.Row>
            )}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  )
}
