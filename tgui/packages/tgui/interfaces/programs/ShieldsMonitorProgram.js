import { useBackend } from "tgui/backend";
import { Stack, LabeledList, Section, Tabs } from "tgui/components";
import { Window } from "tgui/layouts";

export const ShieldsMonitorProgram = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={600}
      height={400}
    >
      <Window.Content>
        <Stack fill direction="row" justify="space-between">
          <Stack.Item>
            <Section
              fill
              width={16}
              title="Available"
            >
              <Tabs vertical>
                {data.shields.map(shield => (
                  <Tabs.Tab
                    key={shield.shield_ref}
                    selected={shield.shield_ref === data.active}
                  >
                    {shield.area}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item />
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <Section>
              <LabeledList>
                <LabeledList.Item />
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
