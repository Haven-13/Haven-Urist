import { useBackend } from 'tgui/backend';
import { Box, Button, Flex, Input, LabeledList, LabeledControls, ProgressBar, TimeDisplay, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

export const DestinationMenu = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    ...rest
  } = props;

  const selected = props.selected || [];
  const possible = props.possible || [];
  const change = props.onChange;

  const title = props.title || "Destinations";

  return (
    <Section
      title={title}
      {...rest}>
      <Box height={4}>
        <LabeledList>
          <LabeledList.Item label="Selected">
            {(selected.name) ? (
              <Fragment>
                <Box>
                  {selected.name}
                </Box>
                <Box>
                  {selected.areaName}
                </Box>
              </Fragment>
            ) : (<Box italic>
              None
            </Box>)}
          </LabeledList.Item>
        </LabeledList>
      </Box>
      {possible.length > 0
        ? possible.map(entry => (
          <Button.Checkbox
            fluid
            key={entry.ref}
            disabled={!data.canPick}
            checked={entry.ref === selected.ref}
            onClick={() => change(entry.ref === selected.ref ? null : entry.ref)}>
            <Box inline verticalAlign="middle">
              <Box>
                {entry.name}
              </Box>
              <Box>
                {entry.areaName}
              </Box>
            </Box>
          </Button.Checkbox>
        )):(
          <Box italic>
            There are currently no destinations within reach
          </Box>
        )}
    </Section>
  );
};

export const ShuttleConsole = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={600}
      height={350}>
      <Window.Content>
        <Flex
          direction="row"
          justify="space-between"
          width="100%"
          height="100%">
          <Flex.Item>
            <Flex
              height="100%"
              wrap="nowrap"
              direction="column"
              justify="space-between"
              width={22}>
              <Flex.Item>
                <Section align="center">
                  <Box fontSize={4} lineHeight={1.6}>
                    <TimeDisplay
                      disabled={!data.hasTimeLeft}
                      auto="down"
                      value={data.timeLeft*10}
                      format={(h, m, s) => `${m}:${s}`}
                    />
                  </Box>
                  <Box>
                    Time left
                  </Box>
                </Section>
              </Flex.Item>
              <Flex.Item>
                <Section>
                  <LabeledList>
                    <LabeledList.Item label="Status">
                      <Box inline>
                        {data.shuttleStatus}
                      </Box>
                    </LabeledList.Item>
                    <LabeledList.Item label="Location">
                      <Box inline>
                        {data.currentLocation}
                      </Box>
                    </LabeledList.Item>
                    {!!data.fuelConsumption && (<LabeledList.Item label="Fuel">
                      <ProgressBar
                        color={data.fuelPressureStatus}
                        value={data.fuelPressure}
                        minValue={0}
                        maxValue={data.fuelMaxPressure}
                      />
                    </LabeledList.Item>)}
                    <LabeledList.Item label="Code">
                      {data.hasDocking ? (<Input
                        fluid
                        value={data.dockingCodes}
                        placeholder={"None set"}
                        onChange={(e, v) => act("set_codes", {
                          code: v,
                        })}
                      />) : (
                        <Box italic>
                          This vessel has no docking protocols
                        </Box>
                      )}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              </Flex.Item>
              <Flex.Item>
                <Section title="Launch Control">
                  <LabeledControls>
                    <LabeledControls.Item label="Initiate">
                      <Button
                        icon="angle-up"
                        disabled={!data.canLaunch}
                        onClick={() => act("move", {})}
                      />
                    </LabeledControls.Item>
                    <LabeledControls.Item label="Force">
                      <Button.Confirm
                        icon="angle-double-up"
                        color="red"
                        disabled={!data.canForce}
                        onClick={() => act("force", {})}
                      />
                    </LabeledControls.Item>
                    <LabeledControls.Item label="Abort">
                      <Button.Confirm
                        icon="stop"
                        color="red"
                        disabled={!data.canCancel}
                        onClick={() => act("abort", {})}
                      />
                    </LabeledControls.Item>
                  </LabeledControls>
                </Section>
              </Flex.Item>
            </Flex>
          </Flex.Item>
          <Flex.Item>
            <DestinationMenu
              fill
              width={26}
              selected={data.selectedDestination}
              possible={data.possibleDestinations}
              onChange={value => act("set_destination", {
                destination: value,
              })}
            />
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};
