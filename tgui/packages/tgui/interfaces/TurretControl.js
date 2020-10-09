import { useBackend } from 'tgui/backend';
import { Fragment } from 'inferno';
import { Button, Box, LabeledList, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { InterfaceLockNoticeBox } from './common/InterfaceLockNoticeBox';

export const TurretControl = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    access,
    locked,
    enabled,
    lethal,
    settings,
  } = data;

  return (
    <Window
      width={305}
      height={310}>
      <Window.Content>
        <InterfaceLockNoticeBox />
        <Section>
          <LabeledList>
            <LabeledList.Item label="Turret Status">
              <Button
                icon={enabled ? 'power-off' : 'times'}
                content={enabled ? 'Enabled' : 'Disabled'}
                selected={enabled}
                disabled={locked}
                onClick={() => act('command', {
                  command: "enable",
                  value: !enabled,
                })} />
            </LabeledList.Item>
            <LabeledList.Item label="Turret Mode">
              <Button
                icon={lethal ? 'exclamation-triangle' : 'minus-circle'}
                content={lethal ? 'Lethal' : 'Stun'}
                color={lethal ? "bad" : "average"}
                disabled={locked}
                onClick={() => act('command', {
                  command: "lethal",
                  value: !lethal,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section>
          <LabeledList>
            {settings.map(setting => (
              <LabeledList.Item
                key={setting.setting}
                label={setting.category}>
                <Button
                  selected={setting.value}
                  content="Toggle"
                  onClick={() => act('command', {
                    command: setting.setting,
                    value: !setting.value,
                  })}
                />
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
