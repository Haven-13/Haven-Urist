import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Box, Button, Section, LabeledList } from 'tgui/components';
import { Window } from '../layouts';
import { Table } from '../components';
import { TableCell, TableRow } from '../components/Table';

export const ToolCart = (props, context) => {
  const { act, data } = useBackend(context);
  const items = data.items || [];
  const stacks = data.stacks || [];
  return (
    <Window
      width={300}
      height={250}
      resizeable>
      <Window.Content >
        <Table>
          <TableRow
            bold={1}
            color="label">
            <TableCell>
              Label
            </TableCell>
            <TableCell>
              Content
            </TableCell>
            <TableCell
              width="30px"
            />
          </TableRow>
          {items.map(item => (
            <TableRow
              key={item.key}>
              <TableCell
                color="label">
                {item.label}
              </TableCell>
              <TableCell
                color={item.name ? "normal" : "grey"}>
                {item.name ? item.name : "None"}
              </TableCell>
              <TableCell>
                <Button
                  disabled={!item.name}
                  content="Take"
                  onClick={() => act("take", {
                    take: item.key,
                  })}
                />
              </TableCell>
            </TableRow>
          ))}
          {stacks.map(stack => (
            <TableRow
              key={stack.key}>
              <TableCell
                color="label">
                {stack.label}
              </TableCell>
              <TableCell>
                {stack.amount > 0 ? (
                  <Box>
                    {stack.amount} <i>left</i>
                  </Box>
                ) : (
                  <Box color="grey">
                    None
                  </Box>
                )}
              </TableCell>
              <TableCell>
                <Button
                  disabled={stack.amount <= 0}
                  content="Take"
                  onClick={() => act("take", {
                    take: stack.key,
                  })}
                />
              </TableCell>
            </TableRow>
          ))}
        </Table>
      </Window.Content>
    </Window>
  );
};
