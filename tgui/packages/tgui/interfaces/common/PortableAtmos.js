import { useBackend } from "tgui/backend";
import { Fragment } from 'inferno';
import { Box, Section, LabeledList, Button, AnimatedNumber } from "tgui/components";

export const PortableBasicInfo = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    port_connected,
    holding_tank,
    on,
    pressure,
  } = data;

  return (
    <Fragment>
      <Section
        title="Status"
        buttons={(
          <Button
            icon={on ? 'power-off' : 'times'}
            content={on ? 'On' : 'Off'}
            selected={on}
            onClick={() => act('power')} />
        )}>
        <LabeledList>
          <LabeledList.Item label="Pressure">
            <AnimatedNumber value={pressure} />
            {' kPa'}
          </LabeledList.Item>
          <LabeledList.Item
            label="Port"
            color={port_connected ? 'good' : 'average'}>
            {port_connected ? 'Connected' : 'Not Connected'}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Holding Tank"
        minHeight="82px"
        buttons={(
          <Button
            icon="eject"
            content="Eject"
            disabled={!holding_tank}
            onClick={() => act('eject')} />
        )}>
        {holding_tank ? (
          <LabeledList>
            <LabeledList.Item label="Label">
              {holding_tank.name}
            </LabeledList.Item>
            <LabeledList.Item label="Pressure">
              <AnimatedNumber
                value={holding_tank.pressure} />
              {' kPa'}
            </LabeledList.Item>
          </LabeledList>
        ) : (
          <Box color="average">
            No holding tank
          </Box>
        )}
      </Section>
    </Fragment>
  );
};
