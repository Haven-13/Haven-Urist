import { useBackend } from "tgui/backend";
import { Button, LabeledList, NumberInput, Section } from "tgui/components";
import { Window } from "tgui/layouts";

export const OmniFilter = (props, context) => {
  const { act, data } = useBackend(context);
  const ports = data.ports || [];
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
            <LabeledList.Item label="Transfer Rate">
              <NumberInput
                animated
                value={parseFloat(data.setFlowRate)}
                width="80px"
                unit="L/s"
                minValue={0}
                maxValue={data.maxFlowRate}
                onChange={(e, value) => act('set_flow_rate', {
                  set_flow_rate: value,
                })} />
              <Button
                ml={1}
                icon="plus"
                content="Max"
                disabled={
                  data.setFlowRate === data.maxFlowRate
                }
                onClick={() => act('set_flow_rate', {
                  set_flow_rate: data.maxFlowRate,
                })} />
            </LabeledList.Item>
            <LabeledList.Item label="Filter">
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
                    <Button
                      width="110px"
                      selected={port.isFilter}
                      content={port.fType || "Filter"}
                      onClick={() => act('switch_filter', {
                        dir: port.dir,
                        mode: port.fType,
                      })} />
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
