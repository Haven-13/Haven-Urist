import { useBackend } from "tgui/backend";
import { Fragment } from 'inferno';
import { Box, Section, Table } from "tgui/components";
import { round } from "common/math";
import { Window } from "tgui/layouts";

export const NtosCrewMonitor = () => {
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
    if (sensor.sensor_type === 1) {
      return (
        <Box color={sensor.alert ? "bad" : "normal"}>
          {sensor.alert
            ? "Medical alert"
            : "No alert"}
        </Box>
      );
    }
    else {
      return (
        <Fragment>
          <Box color={sensor.pulse_span} inline>
            {sensor.pulse} bpm
          </Box>
          &emsp;/&emsp;
          <Box color={sensor.oxygenation_span} inline>
            {sensor.pressure} ({sensor.oxygenation})
          </Box>
          &emsp;/&emsp;
          <Box inline>
            {round(sensor.bodytemp)}&deg;C
          </Box>
        </Fragment>
      );
    }
  };

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
            {sensor.x !== null ? (
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
