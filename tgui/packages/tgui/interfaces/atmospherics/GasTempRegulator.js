import { useBackend } from 'tgui/backend';
import { Button, Knob, LabeledControls, LabeledList, NumberInput, ProgressBar, Section} from 'tgui/components';
import { formatSiUnit } from 'tgui/format';
import { Window } from 'tgui/layouts';
import { round } from "common/math"

export const GasTempRegulator = (props, context) => {
  const {act, data} = useBackend(context);
  const {
    on,
    gasPressure,
    gasTemperature,
    minGasTemperature,
    maxGasTemperature,
    targetGasTemperature,
    powerSetting,
    gasTemperatureClass
  } = data;

  return (
    <Window
      width={310}
      height={170}
    >
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="Temperature"
            >
              <ProgressBar
                value={gasTemperature}
                minValue={minGasTemperature}
                maxValue={maxGasTemperature}
              >
                {gasTemperature} &deg;K / {gasTemperature-273.15} &deg;C
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item
              label="Pressure"
            >
              <ProgressBar
                value={gasPressure}
                minValue={0}
                maxValue={15*101.325}
              >
                {formatSiUnit(round(gasPressure, 1), 1, 'Pa')}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <LabeledControls>
            <LabeledControls.Item
              label="Target Temperature"
            >
              <NumberInput
                width="100px"
                value={targetGasTemperature}
                minValue={minGasTemperature}
                maxValue={maxGasTemperature}
                unit="°K"
                onChange={(e, value) => act('temp', {
                  temp: value
                })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Power"
            >
              <Button
                selected={on}
                content="Toggle"
                onClick={() => act('toggleStatus')}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Power Setting"
            >
              <Knob
                value={powerSetting}
                minValue={20}
                maxValue={100}
                step={20}
                onDrag={(e,value) => act('setPower', {
                  setPower: value
                })}
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
