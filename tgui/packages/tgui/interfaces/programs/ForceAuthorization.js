import { NtosWindow } from "tgui/layouts";
import { Box, Button, Dimmer, Flex, Icon, LabeledList, Section, Stack, Table } from "tgui/components";
import { useBackend, useSharedState } from "tgui/backend";
import { capitalize } from "common/string";

const WeaponEntry = (props, context) => {
  const {
    availableModes={},
    numberAvailableModes=Object.keys(availableModes).length,
    onModeClick=(target, ref, mode) => {},
    ...rest
  } = props;

  const {
    name,
    ref,
    owner,
    loc,
    type,
    canChange,
  } = props.weapon;

  const modes = props.weapon.modes?.reduce((a, b) => ({
    ...a,
    [b.mode_name]: b,
  }), {}) || {};

  const makeModeButton = (mode) => {
    const data = availableModes[mode.mode_name];
    return (
      <Button.Checkbox
        compact
        fluid
        p={0}
        checked={mode.authorized}
        backgroundColor={mode.authorized && data.colour || 'transparent'}
        tooltip={`${data.name} ${mode.authorized ? 'ENABLED' : 'DISABLED'}`}
        onClick={() => onModeClick(
          type, ref, mode
        )}
      />
    );
  };

  const locationFormat = (loc) => {
    return `${loc.x}, ${loc.y}, ${loc.z}`;
  };

  const shouldShowModes = () => {
    return canChange && !!props.weapon.modes.length;
  };

  return (
    <Table.Row
      {...rest}
    >
      <Table.Cell>
        {capitalize(name)}
      </Table.Cell>
      <Table.Cell>
        {owner}
      </Table.Cell>
      {!!shouldShowModes()
        && Object.entries(availableModes).map(([key, mode]) => (
          <Table.Cell
            key={key}
            p={0}
            align="center"
            position="relative"
            textAlign="center"
          >
            <Box
              width="100%"
              height="100%"
              position="absolute"
              backgroundColor={mode.colour}
              opacity={0.3}
            />
            {modes[key] && (
              !modes[key].always_authorized
              && makeModeButton(modes[key])
              || (
                <Button
                  compact
                  fluid
                  p={0}
                  backgroundColor={'transparent'}
                  icon="stop"
                  tooltip={`${mode.name} always enabled`}
                />
              )
            ) || (
              <Button
                compact
                fluid
                p={0}
                backgroundColor={'transparent'}
                icon="times"
                tooltip={`${mode.name} unavailable`}
              />
            )}
          </Table.Cell>
        ))
       || (
         <Table.Cell
           italic
           color={canChange ? 'grey' : 'bad'}
           textAlign="center"
           colspan={`${numberAvailableModes}`}
         >
           {canChange ? 'N/A' : 'Unauthorized'}
         </Table.Cell>
       )}
      <Table.Cell textAlign="center">
        {loc && (
          <Box>
            {locationFormat(loc)}
          </Box>
        ) || (
          <Box italic>
            In unit
          </Box>
        )}
      </Table.Cell>
    </Table.Row>
  );
};

export const ForceAuthorization = (props, context) => {
  const { data, act } = useBackend(context);

  const MODES = {
    stun: {
      colour: 'blue',
      icon: 'sun',
      name: 'Stun',
    },
    shock: {
      colour: 'yellow',
      icon: 'bolt',
      name: 'Shock',
    },
    kill: {
      colour: 'bad',
      icon: 'skull-crossbones',
      name: 'Lethal',
    },
  };
  const AMOUNT_MODES = Object.keys(MODES).length;

  const filterOptions = [
    {
      title: "Normal",
      key: 'showNormalGuns',
      dataName: 'guns',
      action: 'gun',
      accessCheck: () => {
        return true;
      },
    },
    {
      title: "Cyborg",
      key: 'showCyborgGuns',
      dataName: 'cyborg_guns',
      action: 'cyborg_gun',
      accessCheck: () => {
        return !data.is_silicon_usr;
      },
    },
  ];

  const [
    listFilter,
    setListFilter,
  ] = useSharedState(context, "listFilter", Object.assign(
    {},
    ...filterOptions.map((option) => {
      return { [option.key]: true };
    })
  )
  );

  const displayableData = filterOptions.filter((option) => {
    return listFilter[option.key];
  });

  const updateFilter = (key, value) => {
    listFilter[key] = value;
    setListFilter(listFilter);
  };

  const filteredData = [].concat.apply([], displayableData?.map(
    (set) => (data[set.dataName] || []).map((x) => {
      x.type = set.action;
      x.canChange = set.accessCheck();
      return x;
    })
  ));

  return (
    <NtosWindow
      width={650}
      height={400}
    >
      <NtosWindow.Content>
        <Stack
          fill
          vertical
          justify="space-between"
        >
          <Stack.Item>
            <Section
            >
              <LabeledList>
                <LabeledList.Item
                  verticalAlign="middle"
                  label="Filtering"
                >
                  <Flex
                    direction="row"
                  >
                    {filterOptions.map((option) => (
                      <Flex.Item key={option.key}>
                        <Button.Checkbox
                          compact
                          checked={listFilter[option.key]}
                          content={`Show ${option.title}`}
                          onClick={() => {
                            updateFilter(option.key, !listFilter[option.key]);
                          }}
                        />
                      </Flex.Item>
                    ))}
                  </Flex>
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              fill
              scrollable
            >
              <Table>
                <Table.Row bold>
                  <Table.Cell
                    rowspan="2"
                    textAlign="center"
                    verticalAlign="bottom"
                    width={14.5}
                  >
                    Name
                  </Table.Cell>
                  <Table.Cell
                    rowspan="2"
                    textAlign="center"
                    verticalAlign="bottom"
                  >
                    Registered User
                  </Table.Cell>
                  <Table.Cell
                    colspan={AMOUNT_MODES}
                    textAlign="center"
                    verticalAlign="bottom"
                  >
                    Modes
                  </Table.Cell>
                  <Table.Cell
                    rowspan="2"
                    textAlign="center"
                    verticalAlign="bottom"
                    width={9}
                  >
                    Location
                  </Table.Cell>
                </Table.Row>
                <Table.Row>
                  {Object.entries(MODES).map(([key, value]) => (
                    <Table.Cell
                      width={3}
                      maxWidth={3}
                      p={0}
                      key={value}
                      position="relative"
                      textAlign="center"
                      backgroundColor={value.colour}
                    >
                      <Icon m={0} name={value.icon} />
                    </Table.Cell>
                  ))}
                </Table.Row>
                {filteredData.map((weapon) => (
                  <WeaponEntry
                    key={weapon.ref}
                    weapon={weapon}
                    availableModes={MODES}
                    onModeClick={(type, ref, mode) => act(
                      'authorize', {
                        target: type,
                        ref: ref,
                        value: mode.authorized,
                        mode: mode.index,
                      }
                    )}
                  />
                ))}
              </Table>
              {!filteredData.length && (
                <Dimmer>
                  <Box italic textAlign="center">
                    No weapons registered
                  </Box>
                </Dimmer>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
