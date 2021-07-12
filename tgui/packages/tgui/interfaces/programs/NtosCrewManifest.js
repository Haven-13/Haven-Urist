import { useBackend } from "tgui/backend";
import { Button, Section, Table } from "tgui/components";
import { NtosWindow } from "tgui/layouts";

export const NtosCrewManifest = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    has_printer,
    manifest = data.manifest || {},
  } = data;
  return (
    <NtosWindow
      width={420}
      height={480}
      resizable>
      <NtosWindow.Content scrollable>
        <Section
          title="Crew Manifest"
          buttons={(
            <Button
              icon="print"
              content="Print"
              disabled={!has_printer}
              onClick={() => act('PRG_print')} />
          )}>
          {Object.entries(manifest).map(([key, value]) => (
            <Section
              key={key}
              title={value.name}
            >
              <Table>
                {value.members.map((member, index) => (
                  <Table.Row key={index} className="candystripe">
                    <Table.Cell bold>
                      {member.name}
                    </Table.Cell>
                    <Table.Cell>
                      {member.job}
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          ))}
        </Section>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
