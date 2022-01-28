import { round } from "common/math";
import { useBackend } from "tgui/backend";
import { Box, Button, Knob, LabeledControls, LabeledList, ProgressBar, Section } from "tgui/components";
import { Window } from "tgui/layouts";

export const GasTank = (props, context) => {
  const { data, act } = useBackend(context);
  return (
    <Window
      width={300}
      height={210}
    >
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Status">
              {(!!data.maskConnected && (
                <Box color="good">Connected to Internals</Box>
              )) || (
                <Box color="average">Not connected to Internals</Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Pressure">
              <ProgressBar
                value={data.tankPressure}
                minValue={0}
                maxValue={data.maxTankPressure}
                ranges={{
                  average: [-Infinity, data.defaultReleasePressure],
                  good: [data.defaultReleasePressure, data.maxTankPressure],
                  yellow: [data.maxTankPressure, data.badTankPressure/2],
                  bad: [data.badTankPressure/2, Infinity],
                }}
              >
                {round(data.tankPressure, 1)} kPa
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Release">
              <ProgressBar
                value={data.releasePressure}
                minValue={0}
                maxValue={data.maxReleasePressure}
              >
                {round(data.releasePressure, 1)} kPa
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <LabeledControls>
            <LabeledControls.Item label="Regulator">
              <Knob
                size={1.5}
                color={!!data.valveOpen && 'yellow'}
                unit="kPa"
                value={data.releasePressure}
                minValue={0}
                maxValue={data.maxReleasePressure}
                step={5}
                stepPixelSize={1}
                onDrag={(e, value) => act('set_release', {
                  value: value,
                })} />
            </LabeledControls.Item>
            <LabeledControls.Item label="Set Pressure">
              <Button
                icon=""
                content="Max"
                onClick={() => act("set_release", { value: "max" })}
              />
              <Button
                icon=""
                content="Reset"
                onClick={() => act("set_release", { value: "reset" })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item label="Valve">
              <Button.Checkbox
                checked={!!data.valveOpen}
                content="Open"
                onClick={() => act("toggle_valve")}
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
