import { useBackend } from "tgui/backend";
import { Button, LabeledList, Section } from "tgui/components";
import { Window } from "tgui/layouts";
import { AnimatedNumber, Knob, LabeledControls } from "../../components";

export const PassiveGate = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={260}
      height={240}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item
              label="Input Pressure">
              <AnimatedNumber
                value={data.inputPressure}
              /> kPa
            </LabeledList.Item>
            <LabeledList.Item
              label="Output Pressure">
              <AnimatedNumber
                value={data.outputPressure}
              /> kPa
            </LabeledList.Item>
            <LabeledList.Item
              label="Flow Rate">
              <AnimatedNumber
                value={data.lastFlowRate}
              /> L/s
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <LabeledControls>
            <LabeledControls.Item
              label="Valve Lock">
              <Button
                icon={data.on ? "unlock" : "lock"}
                content={data.on ? "Unlocked" : "Locked"}
                selected={data.on}
                width={7}
                onClick={() => act("toggle_valve")}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Regulation Mode">
              <Button
                content="Off"
                selected={data.regulateMode === 0}
                onClick={() => act("regulate_mode", {
                  regulate_mode: "off",
                })}
              />
              <Button
                content="Input"
                selected={data.regulateMode === 1}
                onClick={() => act("regulate_mode", {
                  regulate_mode: "input",
                })}
              />
              <Button
                content="Output"
                selected={data.regulateMode === 2}
                onClick={() => act("regulate_mode", {
                  regulate_mode: "output",
                })}
              />
            </LabeledControls.Item>
          </LabeledControls>
          <br />
          <LabeledControls>
            <LabeledControls.Item
              label="Target Pressure">
              <Knob
                value={data.pressureSet}
                minValue={data.minPressure}
                maxValue={data.maxPressure}
                step={100}
                unit="kPa"
                onDrag={(e, value) => act("set_pressure", {
                  set_pressure: value,
                })}
                onChange={(e, value) => act("set_pressure", {
                  set_pressure: value,
                })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Flow Rate Limit">
              <Knob
                value={data.setFlowRate}
                minValue={data.minFlowRate}
                maxValue={data.maxFlowRate}
                step={10}
                unit="L/s"
                onDrag={(e, value) => act("set_flow_rate", {
                  set_flow_rate: value,
                })}
                onChange={(e, value) => act("set_flow_rate", {
                  set_flow_rate: value,
                })}
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
