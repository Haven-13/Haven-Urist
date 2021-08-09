import { useBackend } from 'tgui/backend';
import { formatSiUnit } from 'tgui/format';
import { Section, LabeledList, Box, Button, ProgressBar } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { AnimatedNumber, LabeledControls } from 'tgui/components';
import { inRange } from 'common/math';

export const AirlockController = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={360}
      height={220}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="Status">
              {data.processing ? (
                <Box>
                  Cycling to {data.targetState === -1 ? 'Interior' : 'Exterior'}
                </Box>
              ) : "Idle"}
            </LabeledList.Item>
            <LabeledList.Item
              label="Chamber Pressure">
              <ProgressBar
                value={data.chamberPressure}
                maxValue={200}
                color={
                  inRange(data.chamberPressure, [95, 110]) ? "good"
                    : inRange(data.chamberPressure, [80, 120]) ? "average"
                      : "bad"
                }>
                <AnimatedNumber
                  value={data.chamberPressure * 1000}
                  format={value => formatSiUnit(value, 1, 'Pa')}
                />
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Controls">
          <LabeledControls>
            <LabeledControls.Item
              label="Emergency">
              <Button
                fluid
                icon="sign-out-alt"
                content="Force Exterior"
                color={data.interiorStatus.state === "open" ? 'red'
                  : data.processing ? 'yellow' : null}
                onClick={() => act("command", {
                  command: "force_ext",
                })}
              />
              <Button
                fluid
                icon="sign-in-alt"
                content="Force Interior"
                color={data.exteriorStatus.state === "open" ? 'red'
                  : data.processing ? 'yellow' : null}
                onClick={() => act("command", {
                  command: "force_int",
                })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Cycling">
              <Button
                fluid
                icon="sign-out-alt"
                content="Cycle to Exterior"
                disabled={data.processing}
                onClick={() => act("command", {
                  command: "cycle_ext",
                })}
              />
              <Button
                fluid
                icon="sign-in-alt"
                content="Cycle to Interior"
                disabled={data.processing}
                onClick={() => act("command", {
                  command: "cycle_int",
                })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Actions">
              <Button
                fluid
                icon="stop"
                content="Abort"
                disabled={!data.processing}
                onClick={() => act("command", {
                  command: "abort",
                })}
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
