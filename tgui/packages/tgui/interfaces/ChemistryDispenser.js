import { Fragment } from 'inferno';
import { useBackend } from 'tgui/backend';
import { AnimatedNumber, Box, Button, Icon, LabeledList, ProgressBar, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

export const ChemistryDispenser = (props, context) => {
  const { act, data } = useBackend(context);
  const beakerTransferAmounts = data.beakerTransferAmounts || [];
  const beakerContents = data.beakerContents || [];
  return (
    <Window
      width={600}
      height={620}
      resizable>
      <Window.Content scrollable>
        <Section
          title="Dispense"
          buttons={(
            beakerTransferAmounts.map(amount => (
              <Button
                key={amount}
                icon="plus"
                selected={amount === data.amount}
                content={amount}
                onClick={() => act('amount', {
                  target: amount,
                })} />
            ))
          )}>
          <Box mr={-1}>
            {data.chemicals.map(chemical => (
              <Button
                key={chemical.label}
                icon="tint"
                width="180px"
                lineHeight={1.75}
                content={
                  <Fragment>
                    <span>
                      {chemical.label}
                    </span>
                    <span style="float:right;text-align:right">
                      (<AnimatedNumber
                        initial={0}
                        value={chemical.amount} /> u)
                    </span>
                  </Fragment>
                }
                onClick={() => act('dispense', {
                  dispense: chemical.label,
                })} />
            ))}
          </Box>
        </Section>
        <Section
          title="Beaker"
          buttons={(
            beakerTransferAmounts.map(amount => (
              <Button
                key={amount}
                icon="minus"
                content={amount}
                onClick={() => act('remove', { amount })} />
            ))
          )}>
          <LabeledList>
            <LabeledList.Item
              label="Beaker"
              buttons={!!data.isBeakerLoaded && (
                <Button
                  icon="eject"
                  content="Eject"
                  disabled={!data.isBeakerLoaded}
                  onClick={() => act('eject_beaker')} />
              )}>
              {data.isBeakerLoaded
                  && (
                    <Fragment>
                      <AnimatedNumber
                        initial={0}
                        value={data.beakerCurrentVolume} />
                      /{data.beakerMaxVolume} units
                    </Fragment>
                  )
                || 'No beaker'}
            </LabeledList.Item>
            <LabeledList.Item
              label="Contents">
              <Box color="label">
                {(!data.isBeakerLoaded) && 'N/A'
                  || beakerContents.length === 0 && 'Nothing'}
              </Box>
              {beakerContents.map(chemical => (
                <Box
                  key={chemical.name}
                  color="label">
                  <AnimatedNumber
                    initial={0}
                    value={chemical.volume} />
                  {' '}
                  units of {chemical.name}
                </Box>
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
