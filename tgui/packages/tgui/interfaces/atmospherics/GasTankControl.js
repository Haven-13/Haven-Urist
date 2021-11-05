import { useBackend } from "tgui/backend";
import { Button, LabeledList, NumberInput, Section } from "tgui/components";
import { Window } from "tgui/layouts";
import { LabeledControls } from "../../components";

export const GasTankControl = (props, context) => {
  const { act, data } = useBackend(context);
  const sensors = data.sensors;
  const input = data.input_info;
  const output = data.output_info;
  return (
    <Window
      width={550}
      height={400}>
      <Window.Content>
        <Section title="Sensor Data">
          <LabeledList>
            {sensors.length > 0 && (
              sensors.map(sensor => {
                return (
                  <LabeledList.Item
                    key={sensor.name}
                    label={sensor.name}>
                    <LabeledList>
                      <LabeledList.Item label="Temperature">
                        {sensor.temperature} K
                      </LabeledList.Item>
                      <LabeledList.Item label="Pressure">
                        {sensor.pressure} kPa
                      </LabeledList.Item>
                    </LabeledList>
                  </LabeledList.Item>
                );
              })
            ) || (
              <LabeledList.Item
                label="Warning"
                color="bad">
                Could not find any sensors.
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
        <Section title="Tank Control System">
          <LabeledList>
            <LabeledList.Item label="Input">
              <LabeledControls>
                <LabeledControls.Item
                  label="Status"
                  width="80px">
                  {input.found && (
                    input.power ? "Injecting" : "On hold"
                  ) || (
                    "Not found"
                  )}
                </LabeledControls.Item>
                <LabeledControls.Item label="Actions">
                  <Button
                    content="Refresh"
                    disabled={input.found}
                    onClick={() => act('in_refresh_status')}
                  />
                  <Button
                    content="Toggle"
                    disabled={!input.found}
                    onClick={() => act('in_toggle_injector')}
                  />
                </LabeledControls.Item>
                <LabeledControls.Item label="Flow Rate">
                  <Button
                    icon="plus"
                    content="Min"
                    disabled={
                      !input.found
                      || input.value === input.min_value
                    }
                    onClick={() => act('in_set_value', {
                      new_value: input.min_value,
                    })} />
                  <NumberInput
                    animated
                    value={input.found
                      ? parseFloat(input.value)
                      : "----"}
                    width="100px"
                    unit="L/s"
                    minValue={input.min_value}
                    maxValue={input.max_value}
                    disabled={!input.found}
                    onChange={(e, value) => act('in_set_value', {
                      new_value: value,
                    })}
                  />
                  <Button
                    icon="plus"
                    content="Max"
                    disabled={
                      !input.found
                      || input.value === input.max_value
                    }
                    onClick={() => act('in_set_value', {
                      new_value: input.max_value,
                    })} />
                </LabeledControls.Item>
              </LabeledControls>
            </LabeledList.Item>
            <LabeledList.Item label="Output">
              <LabeledControls>
                <LabeledControls.Item
                  label="Status"
                  width="80px">
                  {output.found && (
                    output.power ? "Open" : "On hold"
                  ) || (
                    "Not found"
                  )}
                </LabeledControls.Item>
                <LabeledControls.Item label="Actions">
                  <Button
                    content="Refresh"
                    disabled={output.found}
                    onClick={() => act('out_refresh_status')}
                  />
                  <Button
                    content="Toggle"
                    disabled={!output.found}
                    onClick={() => act('out_toggle_power')}
                  />
                </LabeledControls.Item>
                <LabeledControls.Item label="Pressure">
                  <Button
                    icon="plus"
                    content="Min"
                    disabled={
                      !output.found
                      || output.value === output.min_value
                    }
                    onClick={() => act('out_set_value', {
                      new_value: output.min_value,
                    })} />
                  <NumberInput
                    animated
                    value={output.found
                      ? parseFloat(output.value)
                      : "----"}
                    width="100px"
                    unit="kPa"
                    minValue={output.min_value}
                    maxValue={output.max_value}
                    disabled={!output.found}
                    onChange={(e, value) => act('out_set_value', {
                      new_value: value,
                    })}
                  />
                  <Button
                    icon="plus"
                    content="Max"
                    disabled={
                      !output.found
                      || output.value === output.max_value
                    }
                    onClick={() => act('out_set_value', {
                      new_value: output.max_value,
                    })} />
                </LabeledControls.Item>
              </LabeledControls>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
