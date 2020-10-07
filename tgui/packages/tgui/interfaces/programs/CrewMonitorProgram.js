import { useBackend } from "tgui/backend";
import { Box, Section, Table } from "tgui/components";
import { round } from "common/math";
import { Window } from "tgui/layouts";

export const CrewMonitorProgram = () => {
  return (
    <Window
      title="Crew Monitor"
      width={800}
      height={600}
      resizable>
      <Window.Content scrollable>
        <Section minHeight="540px">
          <CrewTable />
        </Section>
      </Window.Content>
    </Window>
  );
};

const CrewTable = (props, context) => {
  const { act, data } = useBackend(context);
  const sensors = data.sensors || [];

  const crewVitalsEnty = sensor => {
    if (sensor.sensor_type == 1) {
      return (
        <Fragment>
          {sensor.alert ?
          (<Box color="bad">Medical alert</Box>) :
          (<Box>No alert</Box>)}
        </Fragment>
      )
    }
    else {
      return (
        <Fragment>
          <Box color={sensor.pulse_span} inline={true}>
            {sensor.pulse} bpm
          </Box>
          &emsp;/&emsp;
          <Box color={sensor.oxygenation_span} inline={true}>
            {sensor.pressure} ({sensor.oxygenation})
          </Box>
          &emsp;/&emsp;
          <Box inline={true}>
            {round(sensor.bodytemp)}&deg;C
          </Box>
        </Fragment>
      )
    }
  }

  return (
    <Table>
      <Table.Row>
        <Table.Cell bold>
          Name
        </Table.Cell>
        <Table.Cell bold>
          Assignment
        </Table.Cell>
        <Table.Cell bold textAlign="center" width="260px">
          Vitals
        </Table.Cell>
        <Table.Cell bold width="200px">
          Position
        </Table.Cell>
      </Table.Row>
      {sensors.map(sensor => (
        <Table.Row key={sensor.name}>
          <Table.Cell color={sensor.alert > 0 ? "bad" : "normal"}>
            {sensor.name}
          </Table.Cell>
          <Table.Cell>
            {sensor.assignment}
          </Table.Cell>
          <Table.Cell>
            {crewVitalsEnty(sensor)}
          </Table.Cell>
          <Table.Cell>
            {sensor.x != null ? (
              <Box>{sensor.area}&emsp;({sensor.x}/{sensor.y}/{sensor.z})</Box>
            ) : (
              <Box color="grey"><i>N/A</i></Box>
            )}
          </Table.Cell>
        </Table.Row>
      ))}
    </Table>
  );
};
