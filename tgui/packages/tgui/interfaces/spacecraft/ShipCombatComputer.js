import { useBackend } from 'tgui/backend';
import { Fragment } from 'inferno';
import { Box, Button, ColorBox, Section, Table } from 'tgui/components';
import { COLORS } from 'tgui/constants';
import { Window } from 'tgui/layouts';
import { Flex, LabeledList, ProgressBar } from '../../components';
import { TableCell, TableRow } from '../../components/Table';

const TargetInfoContent = (props, context) => {
  const { act, data } = useBackend(context);
  const target = props.target || {};
  const name = target.name || null;
  const type = target.type || null;
  const health = target.health || 0;
  const maxHealth = target.maxHealth || 1;
  const shields = target.shields || 0;
  const maxShields = target.maxShields || 1;
  const components = target.components || [];
  return (
    <Section
      title={(
        <Fragment>
          Target Info ({name ? name : "No target"})
        </Fragment>
      )}>
      <Flex
        direction="row"
        spacing={2}>
        <Flex.Item
          maxWidth="50%">
          <LabeledList>
            <LabeledList.Item
              label="Name"
              color={name ? "normal" : "grey"}>
              {name ? name : "Undefined"}
            </LabeledList.Item>
            <LabeledList.Item
              label="Type"
              color={type ? "normal" : "grey"}>
              {type ? type : "Undefined"}
            </LabeledList.Item>
            <LabeledList.Item
              label="Integrity">
              <ProgressBar
                value={health}
                maxValue={maxHealth}
              />
            </LabeledList.Item>
            <LabeledList.Item
              label="Shields">
              <ProgressBar
                value={shields}
                maxValue={maxShields}
              />
            </LabeledList.Item>
          </LabeledList>
        </Flex.Item>
        <Flex.Item
          width="50%">
          <Table>
            <TableRow bold={1}>
              <TableCell>
                Name
              </TableCell>
              <TableCell>
                Status
              </TableCell>
              <TableCell>
                Targeting
              </TableCell>
            </TableRow>
            {components.map(component => (
              <TableRow key={component.ref}>
                <TableCell>
                  {component.name}
                </TableCell>
                <TableCell>
                  {component.status}
                </TableCell>
                <TableCell>
                  <Button
                    content="Set"
                    selected={component.targeted}
                    onClick={() => act("set_target", {
                      set_target: component.ref,
                    })}
                  />
                  <Button
                    content="Unset"
                    disabled={!component.targeted}
                    onClick={() => act("unset_target", {
                      unset_target: component.ref,
                    })}
                  />
                </TableCell>
              </TableRow>
            ))}
          </Table>
        </Flex.Item>
      </Flex>
    </Section>
  );
};

export const ShipCombatComputer = (props, context) => {
  const { act, data } = useBackend(context);
  const target = data.target || [];
  const weapons = data.weapons || [];
  return (
    <Window
      width={800}
      height={500}>
      <Window.Content>
        <TargetInfoContent
          target={target}
        />
        <Section
          title="Available Weaponry">
          <Table>
            <TableRow
              bold={1}>
              <TableCell>
                Actions
              </TableCell>
              <TableCell>
                Weapon
              </TableCell>
              <TableCell>
                Status
              </TableCell>
              <TableCell>
                Anti-Armour
              </TableCell>
              <TableCell>
                Anti-Shield
              </TableCell>
              <TableCell>
                Ignores shields
              </TableCell>
              <TableCell>
                Location
              </TableCell>
            </TableRow>
            {weapons.map(weapon => (
              <TableRow key={weapon.ref}>
                <TableCell>
                  <Button
                    content="Fire"
                    onClick={() => act("fire", {
                      fire: weapon.ref,
                    })}
                  />
                </TableCell>
                <TableCell>
                  {weapon.name}
                </TableCell>
                <TableCell>
                  {weapon.status}
                </TableCell>
                <TableCell>
                  {weapon.strengthHull}
                </TableCell>
                <TableCell>
                  {weapon.strengthShield}
                </TableCell>
                <TableCell
                  color={weapon.shieldPass ? "good" : "average"}>
                  {weapon.shieldPass ? "Yes" : "No"}
                </TableCell>
                <TableCell>
                  {weapon.location}
                </TableCell>
              </TableRow>
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
