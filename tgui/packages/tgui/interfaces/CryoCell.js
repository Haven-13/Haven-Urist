import { Fragment } from 'inferno';
import { sanitizeText } from 'tgui/sanitize';
import { Box } from 'tgui/components';
import { useBackend } from 'tgui/backend';
import { AnimatedNumber, Button, LabeledList, ProgressBar, Section } from 'tgui/components';
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
    isBeakerLoaded,
    beakerLabel,
    beakerVolume,
    beakerCapacity,
  } = data;
  const hasOccupant = !!occupant;
  return (
    <Fragment>
      <Section
        title="Occupant"
        buttons={
          <Button
            icon="eject"
            disabled={!!!hasOccupant}
            onClick={() => act("ejectOccupant")}
            content="Eject"/>
        }>
          {hasOccupant &&
            /* Don't let a Baystation12 coder anywhere close to UI code.
            Because, holy fucking shit, this is dumb as fuck. */
            (<Box dangerouslySetInnerHTML={
              { __html: sanitizeText(occupant) }
            } />
          ) || (
            <Box italic>
              No Occupant
            </Box>
          )}
      </Section>
      <Section title="Cell">
        <LabeledList>
          <LabeledList.Item label="Power">
            <Button
              icon={data.isOperating ? "power-off" : "times"}
              disabled={data.isOpen}
              onClick={() => act('power')}
              color={data.isOperating && 'green'}>
              {data.isOperating ? "On" : "Off"}
            </Button>
          </LabeledList.Item>
          <LabeledList.Item label="Temperature">
            <AnimatedNumber value={data.cellTemperature} /> K
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section
        title="Beaker"
        buttons={(
          <Button
            icon="eject"
            disabled={!isBeakerLoaded}
            onClick={() => act('ejectbeaker')}
            content="Eject" />
        )}>
        <LabeledList>
          <LabeledList.Item label="Label">
            {(isBeakerLoaded && beakerLabel) || "None loaded"}
          </LabeledList.Item>
          <LabeledList.Item label="Volume">
            <ProgressBar
              value={beakerVolume}
              minValue={0}
              maxValue={beakerCapacity || Infinity}
            >
              {beakerVolume} / {beakerCapacity}u
            </ProgressBar>
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Fragment>
  );
};
