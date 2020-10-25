import { useBackend } from "tgui/backend";
import { Button, LabeledList, NumberInput, ProgressBar, Section } from "tgui/components";
import { Window } from "tgui/layouts";
import { round } from "common/math";

export const Pump = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={310}
      height={135}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon={data.on ? 'power-off' : 'times'}
                content={data.on ? 'On' : 'Off'}
                selected={data.on}
                onClick={() => act('power')} />
            </LabeledList.Item>
            <LabeledList.Item label="Power Load">
              <ProgressBar
                value={data.lastPowerDraw}
                maxValue={data.maxPowerDraw}
              >
                {data.lastPowerDraw} W
              </ProgressBar>
            </LabeledList.Item>
            {data.max_rate ? (
              <LabeledList.Item label="Transfer Rate">
                <NumberInput
                  animated
                  value={round(parseFloat(data.rate))}
                  width="63px"
                  unit="L/s"
                  minValue={0}
                  maxValue={200}
                  onChange={(e, value) => act('rate', {
                    rate: value,
                  })} />
                <Button
                  ml={1}
                  icon="plus"
                  content="Max"
                  disabled={data.rate === data.max_rate}
                  onClick={() => act('rate', {
                    rate: 'max',
                  })} />
              </LabeledList.Item>
            ) : (
              <LabeledList.Item label="Output Pressure">
                <NumberInput
                  animated
                  width="85px"
                  value={round(parseFloat(data.setPressure))}
                  unit="kPa"
                  minValue={0}
                  maxValue={data.maxPressure}
                  step={10}
                  onChange={(e, value) => act('pressure', {
                    pressure: value,
                  })} />
                <Button
                  ml={1}
                  content="Min"
                  disabled={data.setPressure === data.minPressure}
                  onClick={() => act('pressure', {
                    pressure: 'min',
                  })} />
                <Button
                  ml={1}
                  content="Max"
                  disabled={data.setPressure === data.maxPressure}
                  onClick={() => act('pressure', {
                    pressure: 'max',
                  })} />
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
