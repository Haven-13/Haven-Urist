import { useBackend } from "tgui/backend";
import { Fragment } from 'inferno';
import { Box, Section, LabeledList, AnimatedNumber } from "tgui/components";
import { round } from "common/math";

const VitalsContents = (propes, context) => {
  const { data } = useBackend(context);
  const {
    species,
    status,
    statusFlags,
    timeOfDeath,
    bodyTemperature,
    radiation,
    shockStage,
    toxinLoss,
    bruteLoss,
    fireLoss,
    oxyLoss,
    stack,
    brain,
    heart,
    hasBrokenBones,
    hasInfections,
    hasBleeding,
    hasTendonDamage,
    hasDislocation,
  } = data.occupant ? data.occupant : {};

  const brainDamage = [
    {
      min: 0,
      max: 0,
      colour: "normal",
      text: "Normal",
    },
    {
      min: 1,
      max: 2,
      colour: "normal",
      text: "Minor brain damage",
    },
    {
      min: 3,
      max: 5,
      colour: "average",
      text: "Weak",
    },
    {
      min: 6,
      max: 8,
      colour: "bad",
      text: "Extremely weak",
    },
    {
      min: 9,
      max: 32567,
      colour: "bad",
      text: "Fading",
    },
  ];

  const irradiation = [
    {
      min: 1,
      max: 30,
      text: "Trace",
    },
    {
      min: 31,
      max: 60,
      text: "Mild",
    },
    {
      min: 61,
      max: 90,
      text: "Advanced",
    },
    {
      min: 91,
      max: 120,
      text: "Severe",
    },
    {
      min: 121,
      max: 240,
      text: "Extreme",
    },
    {
      min: 241,
      max: 2147483647,
      text: "Acute",
    },
  ];

  const damageThreshold = 50;

  const between = (min, val, max) => {
    return (min <= val && val <= max);
  };

  const brainStatus = (status, brain) => {
    if (!brain.shouldHave)
    { return (<Box color="bad">Unknown biology</Box>); }
    if (!brain.hasOrgan || status === 2)
    { return (<Box color="bad">Brain-dead</Box>); }
    if (brain.damage >= 0)
    { for (let i = 0; i < brainDamage.length; i++) {
      let e = brainDamage[i];
      if (between(e.min, brain.damage, e.max))
      { return (<Box color={e.colour}>{e.text}</Box>); }
    } }
    return (<Box color="bad">ERROR - Hardware fault</Box>);
  };

  const heartStatus = heart => {
    if (!heart.shouldHave)
    { return (<Box color="bad">Unknown biology</Box>); }
    return (
      <Box>
        <AnimatedNumber
          value={heart.pulse}
        /> bpm
      </Box>
    );
  };

  const radiationStatus = radiation => {
    if (radiation < 1)
    { return null; }
    for (let i = 0; i < irradiation.length; i++) {
      let e = irradiation[i];
      if (between(e.min, radiation, e.max))
      { return (
        <Box color="green">{e.text} radiation sickness</Box>
      ); }
    }
  };

  return (
    <Fragment>
      <LabeledList>
        {status === 2 && (
          <LabeledList.Item label="Time of death">
            <span color="bad">
              {timeOfDeath}
            </span>
          </LabeledList.Item>
        )}
        <LabeledList.Item label="Brain activity">
          {brainStatus(status, brain)}
        </LabeledList.Item>
        <LabeledList.Item label="Blood pulse">
          {heartStatus(heart)}
        </LabeledList.Item>
        <LabeledList.Item label="Blood pressure">
          {heart.shouldHave && (
            <span>
              {heart.bloodPressure}
              (<AnimatedNumber
                value={heart.bloodOxygenation}
              />% oxygenation)
            </span>
          ) || "N/A"}
        </LabeledList.Item>
        <LabeledList.Item label="Body temperature">
          <AnimatedNumber value={bodyTemperature} /> &deg;C
        </LabeledList.Item>
      </LabeledList>
      <LabeledList>
        <LabeledList.Item label="Other">
          {stack && (
            <Box>Neural lace implant</Box>
          )}
          {shockStage > 80 && !heart.asystole && (
            <Box color="average">Intensive pain</Box>
          ) || (heart.asystole && (
            <Box color="bad">Cardiovascular shock</Box>
          )) || ""}
          {oxyLoss > damageThreshold && (
            <Box color="blue"><b>Severe oxygen deprivation</b></Box>
          )}
          {toxinLoss > damageThreshold && (
            <Box color="green"><b>Major systemic organ failure</b></Box>
          )}
          {fireLoss > damageThreshold && (
            <Box color="orange"><b>Severe burn damage</b></Box>
          )}
          {bruteLoss > damageThreshold && (
            <Box color="red"><b>Severe anatomical damage</b></Box>
          )}
          {hasBrokenBones && (
            <Box color="average">Bone fracture</Box>
          )}
          {hasInfections && (
            <Box color="green">Sepsis</Box>
          )}
          {hasBleeding && (
            <Box color="bad">Hemorrhage</Box>
          )}
          {hasTendonDamage && (
            <Box color="average">Tendon/ligament damage</Box>
          )}
          {hasDislocation && (
            <Box color="average">Joint dislocation</Box>
          )}
          {radiation ? (
            radiationStatus(radiation)
          ) : null}
        </LabeledList.Item>
      </LabeledList>
    </Fragment>
  );
};

export const MedicalScanInfo = (props, context) => {
  const { act, data } = useBackend(context);
  const occupant = data.occupant || null;
  const {
    reagents,
    ingested,
    chemTraces,
    pathogens,
  } = occupant ? occupant : {};

  return (
    <Fragment>
      <Section title="Vitals">
        {occupant ? <VitalsContents /> : "No data"}
      </Section>
      <Section title="Reagent Scan">
        <LabeledList>
          <LabeledList.Item label="Bloodstream">
            {occupant ? (reagents && reagents.length > 0
              ? reagents.map(reagent => {
                if (!reagent.scannable)
                { return null; }
                return (
                  <Box key={reagent.name}>
                    {reagent.name} ({round(reagent.amount)}u)
                  </Box>
                ); })
              : "No results") : "No results"}
          </LabeledList.Item>
          <LabeledList.Item label="Ingested">
            {occupant ? (ingested && ingested.length > 0
              ? ingested.map(reagent => {
                if (!reagent.scannable)
                { return null; }
                return (
                  <Box key={reagent.name}>
                    {reagent.name} ({round(reagent.amount)}u)
                  </Box>
                ); })
              : ("No results")) : "No results"}
          </LabeledList.Item>
          <LabeledList.Item label="Traces">
            {occupant ? (chemTraces && chemTraces.length > 0
              ? chemTraces.map(reagent => {
                if (!reagent.scannable)
                { return null; }
                return (
                  <Box key={reagent.name}>
                    {reagent.name} ({round(reagent.amount)}u)
                  </Box>
                ); })
              : ("No results")) : "No results"}
          </LabeledList.Item>
        </LabeledList>
      </Section>
    </Fragment>
  );
};
