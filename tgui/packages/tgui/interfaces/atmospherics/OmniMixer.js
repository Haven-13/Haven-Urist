import { useBackend } from "tgui/backend";
import { round } from "common/math";
import { Button, LabeledList, NumberInput, Section } from "tgui/components";
import { Window } from "tgui/layouts";

export const OmniMixer = (props, context) => {
  const { act, data } = useBackend(context);
  const ports = data.ports;
  return (
    <Window
      width={400}
      height={220}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon={data.power ? 'power-off' : 'times'}
                content={data.power ? 'On' : 'Off'}
                selected={data.power}
                onClick={() => act('power')} />
            </LabeledList.Item>
            <LabeledList.Item label="Output Flow">
              <NumberInput
                animated
                value={parseFloat(data.setFlowRate)}
                unit="L/s"
                width="75px"
                minValue={0}
                maxValue={data.maxFlowRate}
                step={10}
                onChange={(e, value) => act('set_flow_rate', {
                  set_flow_rate: value,
                })} />
              <Button
                ml={1}
                icon="plus"
                content="Max"
                disabled={
                  data.set_flow_rate === data.maxFlowRate
                }
                onClick={() => act('set_flow_rate', {
                  set_flow_rate: data.maxFlowRate,
                })} />
            </LabeledList.Item>
            <LabeledList.Item label="Mixing">
              <LabeledList>
                {ports.map(port => (
                  <LabeledList.Item
                    key={port.dir}
                    label={port.dir}>
                    <Button
                      selected={port.input}
                      content="Input"
                      onClick={() => act('switch_mode', {
                        dir: port.dir,
                        mode: "in",
                      })}
                    />
                    <Button
                      selected={port.output}
                      content="Output"
                      onClick={() => act('switch_mode', {
                        dir: port.dir,
                        mode: "out",
                      })}
                    />
                    <NumberInput
                      animated
                      width="60px"
                      value={round(port.concentration*100)}
                      unit="%"
                      minValue={0}
                      maxValue={100}
                      step={1}
                      onChange={(e, value) => act('switch_con', {
                        dir: port.dir,
                        switch_con: value/100,
                      })}
                    />
                    <Button
                      selected={port.lock}
                      icon={port.lock ? "lock" : "unlock"}
                      onClick={() => act('switch_conlock', {
                        dir: port.dir,
                      })}
                    />
                  </LabeledList.Item>
                ))}
              </LabeledList>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
