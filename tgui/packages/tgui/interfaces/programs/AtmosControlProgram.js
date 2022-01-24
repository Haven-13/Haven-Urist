import { filter, sortBy } from "common/collections";
import { flow } from "common/fp";
import { createSearch } from "common/string";
import { useBackend, useSharedState } from "tgui/backend";
import { Button, Input, Section, Stack, Tabs } from "tgui/components";
import { NtosWindow } from "tgui/layouts";
import { AirAlarmContent } from "../terminals/AirAlarm";

export const AtmosControlProgram = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    alarms,
    selected,
  } = data;

  const [
    filterAlarmsToggle,
    setFilterAlarmsToggle,
  ] = useSharedState(context, "filterAlarmsToggle", false);

  const [
    filterInput,
    setFilterInput,
  ] = useSharedState(context, "filterInput", "");

  const selectAlarms = (alarms, alarmSelectText = "") => {
    const testSearch = createSearch(alarmSelectText, alarm => alarm.name);
    return flow([
      filter(alarm => alarm?.name),
      filterInput && filter(testSearch),
      filterAlarmsToggle && filter(alarm => !!alarm.alarm),
      sortBy(alarm => alarm.name),
    ])(alarms);
  };

  const displayableAlarms = selectAlarms(alarms, filterInput);

  return (
    <NtosWindow
      width={750}
      height={750}
      resizable>
      <NtosWindow.Content scrollable>
        <Stack fill>
          <Stack.Item width={25}>
            <Section fill>
              <Stack vertical fill>
                <Stack.Item>
                  <Input
                    fluid
                    value={filterInput}
                    onInput={(_, value) => setFilterInput(value)}
                  />
                  <Button.Checkbox
                    mt={1}
                    fluid
                    checked={filterAlarmsToggle}
                    onClick={() => setFilterAlarmsToggle(!filterAlarmsToggle)}
                    content="Show Active Alarms Only"
                  />
                </Stack.Item>
                <Stack.Item grow={1}>
                  <Section fill scrollable>
                    <Tabs vertical>
                      {displayableAlarms.map((alarm, index) => (
                        <Tabs.Tab
                          key={index}
                          selected={alarm.ref === selected.ref}
                          onClick={() => act("select", { ref: alarm.ref })}
                        >
                          {alarm.name}
                        </Tabs.Tab>
                      ))}
                    </Tabs>
                  </Section>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section fill scrollable title={selected.name || "Disconnected"}>
              {!!selected.ref && (<AirAlarmContent />)}
            </Section>
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
