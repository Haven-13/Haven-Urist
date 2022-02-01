import { sortBy } from "common/collections";
import { useBackend, useSharedState } from "tgui/backend";
import { LabeledList, ProgressBar, Section, Slider, Stack, Tabs } from "tgui/components";
import { Button } from "tgui/components/Button";
import { formatPower } from "tgui/format";
import { NtosWindow } from "tgui/layouts";

const SmesRconInfo = (props, context) => {
  const { act } = useBackend(context);
  const {
    rconTag,
    storedCapacity,
    storedCapacityAbs,
    storedCapacityMax,
    inputting,
    inputLevel,
    inputLevelMax,
    outputting,
    outputLevel,
    outputLevelMax,
  } = props.data;
  return (
    <Section title={rconTag}>
      <LabeledList>
        <LabeledList.Item label="Charge">
          <ProgressBar
            value={storedCapacity}
            maxValue={100}
          >
            {
              formatPower(storedCapacityAbs)
            } / {
              formatPower(storedCapacityMax)
            } ({storedCapacity} %)
          </ProgressBar>
        </LabeledList.Item>
        <LabeledList.Item label={
          <Button.Checkbox
            fluid
            checked={!!inputting}
            content="Input"
            onClick={() => act("smes_in_toggle", {
              tag: rconTag,
            })}
          />
        }>
          <Slider
            value={inputLevel}
            minValue={0}
            maxValue={inputLevelMax}
            onChange={(e, v) => act("smes_in_set", {
              tag: rconTag,
              target: v,
            })}
            step={1000}
            format={(value) => formatPower(value)}
          />
        </LabeledList.Item>
        <LabeledList.Item label={
          <Button.Checkbox
            fluid
            checked={!!outputting}
            content="Output"
            onClick={() => act("smes_out_toggle", {
              tag: rconTag,
            })}
          />
        }>
          <Slider
            value={outputLevel}
            minValue={0}
            maxValue={outputLevelMax}
            onChange={(e, v) => act("smes_out_set", {
              tag: rconTag,
              target: v,
            })}
            step={1000}
            format={(value) => formatPower(value)}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const RemoteControlProgram = (props, context) => {
  const { act, data } = useBackend(context);

  const [
    currentView,
    setCurrentView,
  ] = useSharedState(context, "currentView", 0);

  const smesUnits = data.smesUnits;
  const breakers = sortBy((breaker) => breaker.rconTag)(data.breakers);

  return (
    <NtosWindow
      width={400}
      height={600}
    >
      <NtosWindow.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Tabs fluid>
              <Tabs.Tab
                selected={currentView===0}
                onClick={() => setCurrentView(0)}
              >
                SMES Units
              </Tabs.Tab>
              <Tabs.Tab
                selected={currentView===1}
                onClick={() => setCurrentView(1)}
              >
                Breakers
              </Tabs.Tab>
              <Tabs.Tab>
                <Button
                  fluid
                  icon="redo"
                  content="Refresh"
                  onClick={() => act("refresh")}
                />
              </Tabs.Tab>
            </Tabs>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              {currentView === 0
              && smesUnits.map(unit => (
                <SmesRconInfo
                  key={unit.rconTag}
                  data={unit}
                />
              ))}
              {currentView === 1 && (
                <LabeledList fill>
                  {breakers.map(breaker => (
                    <LabeledList.Item
                      key={breaker.rconTag}
                      label={breaker.rconTag}
                    >
                      <Button.Checkbox
                        fluid
                        content={breaker.enabled && "Enabled" || "Disabled"}
                        checked={!!breaker.enabled}
                        onClick={() => act("toggle_breaker", {
                          tag: breaker.rconTag,
                        })}
                      />
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
