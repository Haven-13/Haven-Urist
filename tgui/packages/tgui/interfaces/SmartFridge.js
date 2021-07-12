import { map } from 'common/collections';
import { useBackend } from 'tgui/backend';
import { Button, NoticeBox, Section, Table } from 'tgui/components';
import { Window } from 'tgui/layouts';

export const SmartFridge = (props, context) => {
  const { act, data } = useBackend(context);
  const contents = data.contents || [];
  return (
    <Window
      width={440}
      height={550}
      resizable>
      <Window.Content scrollable>
        <Section
          title="Storage"
          buttons={!!data.isdryer && (
            <Button
              icon={data.drying ? 'stop' : 'tint'}
              onClick={() => act('Dry')}>
              {data.drying ? 'Stop drying' : 'Dry'}
            </Button>
          )}>
          {!!data.secure && (
            <NoticeBox>
              Secure Access: Please have your access card ready.
            </NoticeBox>
          )}
          {contents.length === 0 && (
            <NoticeBox>
              Unfortunately, this {data.name} is empty.
            </NoticeBox>
          ) || (
            <Table>
              <Table.Row header>
                <Table.Cell>
                  Item
                </Table.Cell>
                <Table.Cell collapsing>
                  Amount
                </Table.Cell>
                <Table.Cell collapsing textAlign="center">
                  {data.verb ? data.verb : 'Dispense'}
                </Table.Cell>
              </Table.Row>
              {map((value, key) => (
                <Table.Row key={key}>
                  <Table.Cell>
                    {value.display_name}
                  </Table.Cell>
                  <Table.Cell collapsing textAlign="right">
                    {value.quantity}
                  </Table.Cell>
                  <Table.Cell collapsing>
                    <Button
                      content="1"
                      disabled={value.amount < 1}
                      onClick={() => act('vend', {
                        vend: value.vend,
                        amount: 1,
                      })} />
                    <Button
                      content="5"
                      disabled={value.amount <= 1}
                      onClick={() => act('vend', {
                        vend: value.vend,
                        amount: 5,
                      })} />
                    <Button
                      content="10"
                      disabled={value.amount <= 1}
                      onClick={() => act('vend', {
                        vend: value.vend,
                        amount: 10,
                      })} />
                  </Table.Cell>
                </Table.Row>
              ))(data.contents)}
            </Table>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
