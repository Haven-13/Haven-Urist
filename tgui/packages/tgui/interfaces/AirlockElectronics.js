import { useBackend } from 'tgui/backend';
import { Box, Button, Dimmer, Icon, LabeledList, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { AccessList } from './common/AccessList';

export const AirlockElectronics = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    oneAccess,
    lockRequiredAccesses,
  } = data;
  const regions = data.regions || [];
  const accesses = data.accesses || [];
  return (
    <Window
      width={420}
      height={485}>
      {!!data.locked && (
        <Dimmer align="center">
          <Icon name="lock" />
          <Box
            bold
            mb={1}
            pl={6}
            pr={6}>
            To unlock, swipe a card containing following accesses
          </Box>
          <Box>{lockRequiredAccesses.join(', ')}</Box>
        </Dimmer>
      )}
      <Window.Content>
        <Section title="Main">
          <LabeledList>
            <LabeledList.Item
              label="Access Required">
              <Button
                icon={oneAccess ? 'unlock' : 'lock'}
                content={oneAccess ? 'One' : 'All'}
                onClick={() => act('one_access')} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <AccessList
          accesses={regions}
          selectedList={accesses}
          accessMod={ref => act('set', {
            access: ref,
          })}
          grantAll={() => act('grant_all')}
          denyAll={() => act('deny_all')}
          grantDep={ref => act('grant_region', {
            region: ref,
          })}
          denyDep={ref => act('deny_region', {
            region: ref,
          })} />
      </Window.Content>
    </Window>
  );
};
