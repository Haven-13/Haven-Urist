import { Fragment } from 'inferno';
import { sanitizeText } from 'tgui/sanitize';
import { useBackend } from 'tgui/backend';
import { AnimatedNumber, Box, Button, Flex, LabeledControls, ProgressBar, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

const damageTypes = [
  {
    label: "Brute",
    type: "bruteLoss",
  },
  {
    label: "Respiratory",
    type: "oxyLoss",
  },
  {
    label: "Toxin",
    type: "toxLoss",
  },
  {
    label: "Burn",
    type: "fireLoss",
  },
];

export const CryoCell = () => {
  return (
    <Window
      width={400}
      height={550}
      resizable>
      <Window.Content scrollable>
        <CryoContent />
      </Window.Content>
    </Window>
  );
};

const CryoContent = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    occupant = null,
    cellTemperature,
    cellTemperatureStatus,
    beakerLabel,
    beakerVolume,
    beakerCapacity,
  } = data;
  const hasOccupant = !!occupant;
  const isBeakerLoaded = !!beakerLabel;
  return (
    <Fragment>
      <Section>
        <LabeledControls>
          <LabeledControls.Item label="Temperature">
            <ProgressBar
              value={cellTemperature}
              minValue={0}
              maxValue={294}
              width={20}
              color={cellTemperatureStatus}
            >
              <AnimatedNumber value={cellTemperature} /> &deg;K
            </ProgressBar>
          </LabeledControls.Item>
          <LabeledControls.Item label="Power">
            <Button
              icon={data.isOperating ? "power-off" : "times"}
              disabled={data.isOpen}
              onClick={() => act('power')}
              color={data.isOperating && 'green'}>
              {data.isOperating ? "On" : "Off"}
            </Button>
          </LabeledControls.Item>
        </LabeledControls>
      </Section>
      <Section
        title="Beaker"
        buttons={(
          <Button
            icon="eject"
            disabled={!isBeakerLoaded}
            onClick={() => act('ejectBeaker')}
            content="Eject" />
        )}>
        <ProgressBar
          value={beakerVolume}
          minValue={0}
          maxValue={beakerCapacity || Infinity}
        >
          <Flex
            justify="space-between"
          >
            <Flex.Item>
              {(isBeakerLoaded && beakerLabel) || "None loaded"}
            </Flex.Item>
            <Flex.Item>
              {beakerVolume} / {beakerCapacity}u
            </Flex.Item>
          </Flex>
        </ProgressBar>
      </Section>
      <Section
        title="Occupant"
        buttons={
          <Button
            icon="eject"
            disabled={!hasOccupant}
            onClick={() => act("ejectOccupant")}
            content="Eject" />
        }>
        {hasOccupant
        /* Don't let a Baystation12 coder anywhere close to UI code.
            Because, holy fucking shit, this is dumb as fuck. */
          && (
            <Box dangerouslySetInnerHTML={
              { __html: sanitizeText(occupant) }
            } />
          ) || (
          <Box italic>
            No Occupant
          </Box>
        )}
      </Section>
    </Fragment>
  );
};
