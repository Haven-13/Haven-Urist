import { Fragment } from 'inferno';
import { useBackend, useLocalState } from 'tgui/backend';
import { Box, Button, Dimmer, Icon, LabeledList, Section, Table } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { range } from 'common/math';

export const PathogenicCentrifuge = (props, context) => {
  const { act, data } = useBackend(context);

  const antibodies = data.antibodies || [];
  const pathogens = data.pathogens || [];

  const indices = antibodies.length > 0 || pathogens.length > 0
    ? range(0, Math.max(antibodies.length, pathogens.length)-1) : [];

  const [
    isolateTarget,
    setIsolateTarget,
  ] = useLocalState(context, "isolateTarget", null);

  return (
    <Window
      width={320}
      height={300}
      resizable>
      {!!data.busy && (
        <Dimmer fontSize="32px" textAlign="center">
          <Icon name="cog" spin mr={2} />
          {data.busy}
        </Dimmer>
      )}
      <Window.Content scrollable>
        <Section
          title="Sample"
          buttons={(
            <Fragment>
              <Button
                content="Isolate"
                disabled={!data.sampleInserted || data.isAntibodySample || !isolateTarget}
                onClick={() => isolateTarget == "antibodies"
                  ? act("antibody") : act("isolate", {
                    isolate: isolateTarget,
                  })}
              />
              <Button
                icon="eject"
                content="Eject"
                disabled={!data.sampleInserted}
                onClick={() => act("eject")}
              />
              <Button
                icon="print"
                content="Print"
                onClick={() => act("print")}
              />
            </Fragment>
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Sample type">
              {data.sampleInserted ? (
                <Box>
                  {data.isAntibodySample ? "Antibody" : "Blood"} sample
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
              color="label">
              <Table.Cell width="50%">
                Antigens
              </Table.Cell>
              <Table.Cell width="50%">
                Pathogens
              </Table.Cell>
            </Table.Row>
            {indices.length > 0 ? indices.map(idx => (
              <Table.Row key={idx}>
                <Table.Cell>
                  {idx < antibodies.length ? (
                    <Fragment>
                      {!data.isAntibodySample ? (
                        <Button
                          width={2}
                          selected={isolateTarget == "antibodies"}
                          textAlign="center"
                          content={antibodies[idx]}
                          onClick={() => setIsolateTarget("antibodies")}
                        />) : (
                        <Box
                            width={2}
                            textAlign="center">
                            {antibodies[idx]}
                          </Box>
                      )}
                    </Fragment>
                  ) : antibodies.length || idx ? null : (
                    <Box color="grey">
                      None detected
                    </Box>
                  )}
                </Table.Cell>
                <Table.Cell>
                  {idx < pathogens.length ? (
                    <Button
                      width="100%"
                      selected={pathogens[idx].reference == isolateTarget}
                      content={
                        <Box>
                          {pathogens[idx].name} ({pathogens[idx].spreadType})
                        </Box>
                      }
                      onClick={() => setIsolateTarget(pathogens[idx].reference)}
                    />
                  ) : pathogens.length || idx ? null : (
                    <Box color="grey">
                      None detected
                    </Box>
                  )}
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
  );
};
