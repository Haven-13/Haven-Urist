import { Fragment } from 'inferno';
import { useBackend, useLocalState } from "tgui/backend";
import { Box, Button, Flex, Input, LabeledList, NoticeBox, Section, Tabs } from "tgui/components";
import { NtosWindow } from "tgui/layouts";
import { AccessList } from 'tgui/interfaces/common/AccessList';

export const NtosCard = (props, context) => {
  return (
    <NtosWindow
      width={475}
      height={520}
      resizable>
      <NtosWindow.Content scrollable>
        <NtosCardContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};

export const NtosCardContent = (props, context) => {
  const { act, data } = useBackend(context);
  const [tab, setTab] = useLocalState(context, 'tab', 1);
  const {
    authenticated,
    regions = {},
    jobs = {},
    id_rank,
    id_owner,
    has_id,
    have_printer,
    have_id_slot,
    id_name,
  } = data;
  const [
    selectedDepartment,
    setSelectedDepartment,
  ] = useLocalState(context, 'department', Object.keys(jobs)[0]);
  if (!have_id_slot) {
    return (
      <NoticeBox>
        This program requires an ID slot in order to function
      </NoticeBox>
    );
  }
  const departmentJobs = jobs[selectedDepartment] || [];
  const accessOnCard = regions
    ?.map(region => region.accesses)
    .reduce((previous, current) =>
      previous.concat(current.filter(area => area.allowed)), [])
    .map(area => area.ref);
  return (
    <Fragment>
      <Section
        title={has_id && authenticated
          ? (
            <Input
              value={id_owner}
              width="350px"
              onInput={(e, value) => act('PRG_edit', {
                name: value,
              })} />
          )
          : (id_owner || 'No Card Inserted')}
        buttons={(
          <Button
            icon="print"
            content="Print"
            disabled={!have_printer || !has_id}
            onClick={() => act('PRG_print')} />
        )}>
        <Button
          fluid
          icon="eject"
          content={id_name}
          onClick={() => act('PRG_eject')} />
      </Section>
      {(!!has_id && !!authenticated) && (
        <Box>
          <Tabs>
            <Tabs.Tab
              selected={tab === 1}
              onClick={() => setTab(1)}>
              Access
            </Tabs.Tab>
            <Tabs.Tab
              selected={tab === 2}
              onClick={() => setTab(2)}>
              Jobs
            </Tabs.Tab>
            <Tabs.Tab
              selected={tab === 3}
              onClick={() => setTab(3)}>
              Details
            </Tabs.Tab>
          </Tabs>
          {tab === 1 && (
            <AccessList
              accesses={regions}
              selectedList={accessOnCard}
              accessMod={ref => act('PRG_access', {
                access_target: ref,
              })}
              grantDep={dep => act('PRG_grantregion', {
                region: dep,
              })}
              denyDep={dep => act('PRG_denyregion', {
                region: dep,
              })} />
          )}
          {tab === 2 && (
            <Section
              title={id_rank}
              buttons={(
                <Button.Confirm
                  icon="exclamation-triangle"
                  content="Terminate"
                  color="bad"
                  onClick={() => act('PRG_terminate')} />
              )}>
              <Button.Input
                fluid
                content="Custom..."
                onCommit={(e, value) => act('PRG_assign', {
                  assign_target: 'Custom',
                  custom_name: value,
                })} />
              <Flex mt={2}>
                <Flex.Item mr={2}>
                  <Tabs vertical>
                    {Object.keys(jobs).map(department => (
                      <Tabs.Tab
                        key={department}
                        selected={department === selectedDepartment}
                        onClick={() => setSelectedDepartment(department)}>
                        {department}
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Flex.Item>
                <Flex.Item grow>
                  {departmentJobs.map(job => (
                    <Button
                      fluid
                      key={job.job}
                      content={job.display_name}
                      onClick={() => act('PRG_assign', {
                        assign_target: job.job,
                      })} />
                  ))}
                </Flex.Item>
              </Flex>
            </Section>
          )}
          {tab === 3 && (
            <Section>
              <LabeledList>
                <LabeledList.Item label="Account Number">
                  <Input
                    value={data.id_account_number}
                    fluid
                    onInput={(e, value) => act('PRG_edit', {
                      account: value,
                    })} />
                </LabeledList.Item>
                <LabeledList.Item label="Email Login">
                  <Input
                    value={data.id_email_login}
                    fluid
                    onInput={(e, value) => act('PRG_edit', {
                      login: value,
                    })} />
                </LabeledList.Item>
                <LabeledList.Item label="Email Pass">
                  <Input
                    value={data.id_email_password}
                    fluid
                    onInput={(e, value) => act('PRG_edit', {
                      pass: value,
                    })} />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          )}
        </Box>
      )}
    </Fragment>
  );
};
