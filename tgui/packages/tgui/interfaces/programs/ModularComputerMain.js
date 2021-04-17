import { useBackend } from "tgui/backend";
import { Button, ColorBox, Section, Table } from "tgui/components";
import { NtosWindow } from "tgui/layouts";

const PROGRAM_ICONS = {
  compconfig: 'cog',
  ntndownloader: 'download',
  filemanager: 'folder',
  smmonitor: 'radiation',
  alarmmonitor: 'bell',
  cardmod: 'id-card',
  arcade: 'gamepad',
  ntnrc_client: 'comment-alt',
  nttransfer: 'exchange-alt',
  powermonitor: 'plug',
  job_manage: 'address-book',
  crewmani: 'clipboard-list',
  robocontrol: 'robot',
  atmosscan: 'thermometer-half',
  shipping: 'tags',
};

export const ModularComputerMain = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    deviceTheme,
    programs = [],
    hasLight,
    lightOn,
    removableMedia = [],
  } = data;
  const canShowCard = data.PC_hascardslot && data.PC_boardcastcard;
  const login = data.PC_card || [];
  return (
    <NtosWindow
      title={deviceTheme === 'syndicate'
        && 'Syndix Main Menu'
        || 'NtOS Main Menu'}
      theme={deviceTheme}
      width={400}
      height={500}
      resizable>
      <NtosWindow.Content scrollable>
        {!!hasLight && (
          <Section>
            <Button
              width="144px"
              icon="lightbulb"
              selected={lightOn}
              onClick={() => act('PC_toggle_light')}>
              Flashlight: {lightOn ? 'ON' : 'OFF'}
            </Button>
          </Section>
        )}
        {!!canShowCard && (
          <Section
            title="User Login"
            buttons={(
              <Button
                icon="eject"
                content="Eject ID"
                disabled={!login.IDName}
                onClick={() => act('PC_eject_item', { name: "id_card" })}
              />
            )}>
            <Table>
              <Table.Row>
                ID Name: {login.IDName}
              </Table.Row>
              <Table.Row>
                Assignment: {login.IDJob}
              </Table.Row>
            </Table>
          </Section>
        )}
        {!!removableMedia.length && (
          <Section title="Media Eject">
            <Table>
              {removableMedia.map(device => (
                <Table.Row key={device}>
                  <Table.Cell>
                    <Button
                      fluid
                      color="transparent"
                      icon="eject"
                      content={device}
                      onClick={() => act('PC_Eject_Disk', { name: device })}
                    />
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table>
          </Section>
        )}
        <Section title="Programs">
          <Table>
            {programs.map(program => (
              <Table.Row key={program.name}>
                <Table.Cell>
                  <Button
                    fluid
                    color="transparent"
                    icon={PROGRAM_ICONS[program.name]
                      || 'window-maximize-o'}
                    content={program.desc}
                    onClick={() => act('PC_runprogram', {
                      PC_runprogram: program.name,
                    })} />
                </Table.Cell>
                <Table.Cell collapsing width="18px">
                  {!!program.running && (
                    <Button
                      color="transparent"
                      icon="times"
                      tooltip="Close program"
                      tooltipPosition="left"
                      onClick={() => act('PC_killprogram', {
                        name: program.name,
                      })} />
                  )}
                </Table.Cell>
              </Table.Row>
            ))}
          </Table>
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
