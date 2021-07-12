import { classes } from 'common/react';
import { useBackend } from 'tgui/backend';
import { Box, Button, Dimmer, Flex, Icon, Section, Table } from 'tgui/components';
import { TableCell, TableRow } from 'tgui/components/Table';
import { Window } from 'tgui/layouts';

const VendingRow = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    product,
    productStock,
    custom,
  } = props;
  const free = (
    product.price === 0
  );
  return (
    <Table.Row>
      <Table.Cell collapsing>
        {product.base64 && (
          <img
            src={`data:image/jpeg;base64,${product.img}`}
            style={{
              'vertical-align': 'middle',
              'horizontal-align': 'middle',
            }} />
        ) || (
          <span
            className={classes([
              'vending32x32',
              product.path,
            ])}
            style={{
              'vertical-align': 'middle',
              'horizontal-align': 'middle',
            }} />
        )}
      </Table.Cell>
      <Table.Cell bold>
        {product.name}
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        <Box
          color={(
            custom && 'good'
            || productStock <= 0 && 'bad'
            || productStock <= (product.max_amount / 2) && 'average'
            || 'good'
          )}>
          {productStock} in stock
        </Box>
      </Table.Cell>
      <Table.Cell collapsing textAlign="center">
        {custom && (
          <Button
            fluid
            content={data.access ? 'FREE' : product.price + ' cr'}
            onClick={() => act('dispense', {
              'item': product.name,
            })} />
        ) || (
          <Button
            fluid
            disabled={(
              productStock === 0
            )}
            content={free ? 'FREE' : product.price + ' cr'}
            onClick={() => act('dispense', {
              'ref': product.key,
            })} />
        )}
      </Table.Cell>
    </Table.Row>
  );
};

export const VendingMachine = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    mode,
    product_records = [],
    coin_records = [],
    hidden_records = [],
  } = data;
  let inventory;
  let custom = false;
  if (data.vending_machine_input) {
    inventory = data.vending_machine_input || [];
    custom = true;
  }
  else {
    inventory = [
      ...product_records,
      ...coin_records,
    ];
    if (data.extended_inventory) {
      inventory = [
        ...inventory,
        ...hidden_records,
      ];
    }
  }
  // Just in case we still have undefined values in the list
  inventory = inventory.filter(item => !!item);
  return (
    <Window
      title="Vending Machine"
      width={450}
      height={600}
      resizable>
      {!!mode && (
        <Dimmer>
          {(mode === 1 && (
            <Section
              title={"Purchasing"}
              height={12}
              width={30}
              pl={1}
              pr={1}>
              <Flex
                height={8}
                direction={"column"}
                justify={"space-between"}>
                <Flex.Item>
                  <Table>
                    <TableRow>
                      <TableCell bold>
                        Item
                      </TableCell>
                      <TableCell bold textAlign="right">
                        Price
                      </TableCell>
                    </TableRow>
                    <TableRow>
                      <TableCell>
                        {data.product}
                      </TableCell>
                      <TableCell textAlign="right">
                        {data.price} cr
                      </TableCell>
                    </TableRow>
                  </Table>
                </Flex.Item>
                <Flex.Item>
                  <Box color={data.message_err ? 'bad' : null}>
                    {data.message}
                  </Box>
                </Flex.Item>
                <Flex.Item align="center">
                  <Button
                    content={"Cancel"}
                    onClick={() => act("cancel_purchase")} />
                </Flex.Item>
              </Flex>
            </Section>
          )) || (mode === 2 && (
            <Section>
              <Icon name="cog" spin={1} />
              {'Vending...'}
            </Section>
          ))}
        </Dimmer>
      )}
      <Window.Content scrollable>
        <Section
          title="Products"
          buttons={
            <Box>
              {!!data.coin && (<Button
                content="Remove coin"
                onClick={() => act("remove_coin")} />)}
              {!!data.panel && (<Button
                icon={data.speaker ? 'check-square-o' : 'square-o'}
                selected={data.speaker}
                content="Speaker"
                onClick={() => act("toggle_voice")}
              />)}
            </Box>
          }>
          <Table>
            {inventory.map(product => (
              <VendingRow
                key={product.name}
                custom={custom}
                product={product}
                productStock={product.amount} />
            ))}
          </Table>
        </Section>
      </Window.Content>
    </Window>
  );
};
