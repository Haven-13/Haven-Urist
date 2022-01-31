import { useBackend } from "tgui/backend";
import { Section, Stack, Tabs, Button, Icon } from "tgui/components";
import { NtosWindow } from "tgui/layouts";
import { ShieldGeneratorStatus, ShieldModes } from "../AdvancedShieldGenerator";

export const ShieldsMonitorProgram = (props, context) => {
  const { act, data } = useBackend(context);

  const SHIELD_STATUS = [
    { // Completely offline
      icon: "circle-notch",
      color: "bad",
    },
    { // Discharging (shutting down)
      icon: "bullseye",
      color: "average",
    },
    { // Running
      icon: "circle",
      color: "good",
    },
  ];

  return (
    <NtosWindow
      width={860}
      height={440}
    >
      <NtosWindow.Content>
        <Stack fill direction="row" justify="space-between">
          <Stack.Item>
            <Section
              fill
              width={20}
              title="Available"
              buttons={(
                <Button
                  icon="redo"
                  onClick={() => act("refresh")}
                />
              )}
            >
              <Tabs vertical>
                {data.shields.map(shield => (
                  <Tabs.Tab
                    key={shield.shield_ref}
                    selected={shield.shield_ref === data.active}
                    onClick={() => act("ref", { ref: shield.shield_ref })}
                  >
                    <Icon
                      name={SHIELD_STATUS[shield.shield_status].icon}
                      color={SHIELD_STATUS[shield.shield_status].color}
                      mr={2}
                    />
                    {shield.area}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item maxWidth={20}>
            <ShieldGeneratorStatus />
          </Stack.Item>
          <Stack.Item grow>
            <ShieldModes />
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
