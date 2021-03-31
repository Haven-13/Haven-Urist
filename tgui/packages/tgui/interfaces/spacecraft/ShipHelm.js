import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { DIRECTIONS } from 'tgui/constants';
import { round } from 'common/math';
import { AnimatedNumber, Icon, Button, LabeledList, Flex, Section, NumberInput, Slider, Table } from 'tgui/components';
import { ShipNavigationInfo } from './ShipComputerCommon';

export const ShipHelm = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={380}
      height={420}>
      <Window.Content>
        <Flex
          direction="row"
          spacing={1}
          wrap="nowrap"
          justify="space-evenly"
          mb={1}>
          <Flex.Item>
            <ShipNavigationInfo />
          </Flex.Item>
          <Flex.Item>
            <Section
              title="Control"
              height="100%"
              buttons={(
                <Button
                  icon="eye"
                  selected={data.viewing}
                  content="Toggle"
                  onClick={() => act("view")}
                />
              )}>
              <Table>
                <Table.Row height={3.8}>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("move", {
                        move: DIRECTIONS.northwest,
                      })}>
                      <Icon name="arrow-up"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={-45} />
                    </Button>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("move", {
                        move: DIRECTIONS.north,
                      })}>
                      <Icon name="arrow-up"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={0} />
                    </Button>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("move", {
                        move: DIRECTIONS.northeast,
                      })}>
                      <Icon name="arrow-up"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={45} />
                    </Button>
                  </Table.Cell>
                </Table.Row>
                <Table.Row height={3.8}>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("move", {
                        move: DIRECTIONS.west,
                      })}>
                      <Icon name="arrow-left"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={0} />
                    </Button>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("brake")}>
                      <Icon name="times-circle"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={0} />
                    </Button>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("move", {
                        move: DIRECTIONS.east,
                      })}>
                      <Icon name="arrow-right"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={0} />
                    </Button>
                  </Table.Cell>
                </Table.Row>
                <Table.Row>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("move", {
                        move: DIRECTIONS.southwest,
                      })}>
                      <Icon name="arrow-down"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={45} />
                    </Button>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("move", {
                        move: DIRECTIONS.south,
                      })}>
                      <Icon name="arrow-down"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={0} />
                    </Button>
                  </Table.Cell>
                  <Table.Cell>
                    <Button
                      style={{ width: "40px", height: "40px" }}
                      onClick={() => act("move", {
                        move: DIRECTIONS.southeast,
                      })}>
                      <Icon name="arrow-down"
                        style={{
                          position: "relative",
                          top: "3px",
                        }}
                        size={3}
                        rotation={-45} />
                    </Button>
                  </Table.Cell>
                </Table.Row>
              </Table>
            </Section>
          </Flex.Item>
        </Flex>
        <ShipOvermapSectorInfo />
      </Window.Content>
    </Window>
  );
};
