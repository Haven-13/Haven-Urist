import { toFixed } from 'common/math';
import { Fragment } from 'inferno';
import { useBackend } from 'tgui/backend';
import { AnimatedNumber, Box, Button, Icon, Knob, LabeledControls, LabeledList, Section, Tooltip } from 'tgui/components';
import { formatSiUnit } from 'tgui/format';
import { Window } from 'tgui/layouts';

export const Canister = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    portConnected,
    pressure,
    releasePressure,
    defaultReleasePressure,
    minReleasePressure,
    maxReleasePressure,
    valveOpen,
    isPrototype,
    holdingTank,
    restricted,
    canLabel,
  } = data;
  const hasHoldingTank = !!holdingTank;
  return (
    <Window
      width={300}
      height={232}>
      <Window.Content>
        <Section
          title="Canister"
          buttons={(
            <Fragment>
              {!!isPrototype && (
                <Button
                  mr={1}
                  icon={restricted ? 'lock' : 'unlock'}
                  color="caution"
                  content={restricted
                    ? 'Engineering'
                    : 'Public'}
                  onClick={() => act('restricted')} />
              )}
              <Button
                icon="pencil-alt"
                content="Relabel"
                disabled={!canLabel}
                onClick={() => act('relabel')} />
            </Fragment>
          )}>
          <LabeledControls>
            <LabeledControls.Item
              minWidth="66px"
              label="Pressure">
              <AnimatedNumber
                value={pressure}
                format={value => {
                  if (value < 10000) {
                    return toFixed(value) + ' kPa';
                  }
                  return formatSiUnit(value * 1000, 1, 'Pa');
                }} />
            </LabeledControls.Item>
            <LabeledControls.Item label="Regulator">
              <Box
                position="relative"
                left="-8px">
                <Knob
                  size={1.25}
                  color={!!valveOpen && 'yellow'}
                  value={releasePressure}
                  unit="kPa"
                  minValue={minReleasePressure}
                  maxValue={maxReleasePressure}
                  step={5}
                  stepPixelSize={1}
                  onDrag={(e, value) => act('pressure', {
                    pressure: value,
                  })} />
                <Button
                  fluid
                  position="absolute"
                  top="-2px"
                  right="-20px"
                  color="transparent"
                  icon="fast-forward"
                  onClick={() => act('pressure', {
                    pressure: maxReleasePressure,
                  })} />
                <Button
                  fluid
                  position="absolute"
                  top="16px"
                  right="-20px"
                  color="transparent"
                  icon="undo"
                  onClick={() => act('pressure', {
                    pressure: defaultReleasePressure,
                  })} />
              </Box>
            </LabeledControls.Item>
            <LabeledControls.Item label="Valve">
              <Button
                my={0.5}
                width="50px"
                lineHeight={2}
                fontSize="11px"
                color={valveOpen
                  ? (holdingTank ? 'caution' : 'danger')
                  : null}
                content={valveOpen ? 'Open' : 'Closed'}
                onClick={() => act('valve')} />
            </LabeledControls.Item>
            <LabeledControls.Item
              mr={1}
              label="Port">
              <Box position="relative">
                <Icon
                  size={1.25}
                  name={portConnected ? 'plug' : 'times'}
                  color={portConnected ? 'good' : 'bad'} />
                <Tooltip
                  content={portConnected
                    ? 'Connected'
                    : 'Disconnected'}
                  position="top" />
              </Box>
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
        <Section
          title="Holding Tank"
          buttons={!!holdingTank && (
            <Button
              icon="eject"
              color={valveOpen && 'danger'}
              content="Eject"
              onClick={() => act('eject')} />
          )}>
          {!!hasHoldingTank && (
            <LabeledList>
              <LabeledList.Item label="Label">
                {holdingTank.name}
              </LabeledList.Item>
              <LabeledList.Item label="Pressure">
                <AnimatedNumber value={holdingTank.pressure} /> kPa
              </LabeledList.Item>
            </LabeledList>
          )}
          {!holdingTank && (
            <Box color="average">
              No Holding Tank
            </Box>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
