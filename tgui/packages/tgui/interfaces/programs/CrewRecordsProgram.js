import { createSearch } from "common/string"
import { useBackend, useSharedState } from "tgui/backend"
import { Box, Button, Flex, Input, LabeledList, Section, Stack } from "tgui/components"
import { NtosWindow } from "tgui/layouts"

const RecordContentView = (props, context) => {
  const {
    active,
    canUpdatePhotos,
    onClickClose = () => {},
    onClickPrint = (id) => {},
    onClickEditField = (id) => {},
    onClickUpdatePhoto = (target) => {},
    ...rest
  } = props;

  const {
    fields = [],
  } = active

  const fieldsMappedByName = Object.assign(
    {},
    ...fields.map((x) =>
      ({[x.name.toLowerCase()]: x})
    )
  );

  const createPhotoBox = (side)  => {
    let target = side.toLowerCase()
    return (
      <Stack vertical>
        <Stack.Item>
          <Box
            as="img"
            src={`${target}_${active.uid}.png`}
            width="128px"
            style={{
              '-ms-interpolation-mode': 'nearest-neighbor',
              'vertical-align': 'middle',
            }}
          />
        </Stack.Item>
        {!!canUpdatePhotos && (
          <Stack.Item>
            <Button
              icon="camera"
              content={`Update ${side}`}
              onClick={() => onClickUpdatePhoto(target)}
            />
          </Stack.Item>
        )}
      </Stack>
    );
  }

  return (
    <Section
      title={`Viewing Record: ${fieldsMappedByName.name.value}`}
      buttons={
        <Box>
          <Button
            icon="print"
            onClick={() => onClickPrint(active.uid)}
          />
          <Button
            icon="times"
            onClick={() => onClickClose()}
          />
        </Box>
      }
      {...rest}
    >
      <Section
        fill
        scrollable
      >
        <Stack vertical>
          <Stack.Item>
            <Flex
              direction="row"
              align="center"
              justify="space-around"
            >
              <Flex.Item>
                {createPhotoBox("Front")}
              </Flex.Item>
              <Flex.Item>
                {createPhotoBox("Side")}
              </Flex.Item>
            </Flex>
          </Stack.Item>
          <Stack.Item>
            <Section
              mt={1}
              fill
              title="General Information"
            >
              <Stack vertical>
                {
                  fields.map((x) => (
                    !!x.access && (
                      <Stack.Item
                        key={x.uid}
                      >
                        {!!x.needs_big_box && (
                          <Section
                            pt={2}
                            pb={2}
                            title={x.name}
                            buttons={
                              !!x.access_edit && (
                                <Button
                                  m={0}
                                  icon="pen"
                                  onClick={() => onClickEditField(x.ID)}
                                />
                              )
                            }
                          >
                            <Box>
                              {x.value}
                            </Box>
                          </Section>
                        ) || (
                          <Flex
                            direction="row"
                            justify="space-between"
                          >
                            <Flex.Item>
                              <Box bold mr={1}>
                                {x.name}:
                              </Box>
                            </Flex.Item>
                            <Flex.Item grow>
                              <Box>
                                {x.value}
                              </Box>
                            </Flex.Item>
                            <Flex.Item>
                              {!!x.access_edit && (
                                <Button
                                  m={0}
                                  icon="pen"
                                  onClick={() => onClickEditField(x.ID)}
                                />
                              )}
                            </Flex.Item>
                          </Flex>
                        )}
                      </Stack.Item>
                  )))
                }
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Section>
    </Section>
  )
}

const RecordsListViewEntry = (props, context) => {
  const {
    entry,
    extras = []
  } = props;

  return (
    <Flex
      direction="row"
      justify="space-between"
    >
      <Flex.Item
        width={22}
      >
        {entry.name}
      </Flex.Item>
      <Flex.Item
        width={16}
      >
        {entry.job}
      </Flex.Item>
      {extras.map((extra) => (
        <Flex.Item>
          {extra}
        </Flex.Item>
      ))}
    </Flex>
  )
}

const recordsSearchFilter = (search, records) => {
  let searchResults = [];

  if (!search.length) {
    return records;
  }

  records.filter(
    createSearch(search, record => {
      return (record.name || "") + (record.job || "") + (record.dna || "");
    })
  ).forEach(entry =>
    searchResults.push(entry)
  )

  return searchResults;
}

const RecordsListView = (props, context) => {
  const {
    records = {},
    access = {
      creation: false,
      dna: false,
      finger: false
    },
    onClickCreate = () => {},
    onClickPrint = (value) => {},
    onClickRecord = (value) => {},
    ...rest
  } = props;

  const [
    searchText,
    setSearchText
  ] = useSharedState(context, "searchText", "");

  const filteredRecords = recordsSearchFilter(searchText, records);

  const shouldShowCreateButton = () => {
    return access.creation && searchText.length < 1;
  }

  return (
    <Section
      title="Available Records"
      {...rest}
    >
      <Stack
        fill
        vertical
      >
        <Stack.Item>
          <LabeledList>
            <LabeledList.Item label="Search">
              <Input
                fluid
                placeholder="Search by Name / DNA hash / Fingerprint / Occupation..."
                value={searchText}
                onInput={(e, v) => setSearchText(v)}
              />
            </LabeledList.Item>
          </LabeledList>
        </Stack.Item>
        <Stack.Item>
          <RecordsListViewEntry
            entry={{
              name: "Name",
              job: "Job"
            }}
            extras={[
              (<Box width={6}>Actions</Box>)
            ]}
          />
        </Stack.Item>
        <Stack.Item grow>
          <Section fill scrollable>
            {!!filteredRecords.length && filteredRecords.map((entry) => (
              <Flex
                direction="row"
                justify="space-between"
              >
                <Flex.Item>
                  <Button
                    key={entry.id}
                    fluid
                    onClick={() => onClickRecord(entry.id)}
                  >
                    <RecordsListViewEntry
                      entry={entry}
                    />
                  </Button>
                </Flex.Item>
                <Flex.Item>
                  <Button
                    icon="print"
                    onClick={() => onClickPrint(entry.id)}
                  />
                </Flex.Item>
              </Flex>
            )) || (
              <Box
                italic
                color="grey"
              >
                There are no records matching your search
              </Box>
            )}
          </Section>
        </Stack.Item>
        <Stack.Item align="center" mt={1}>
          {!!shouldShowCreateButton() && (
            <Button
              icon="star"
              content="Create New Record"
              onClick={() => onClickCreate()}
            />
          )}
        </Stack.Item>
      </Stack>
    </Section>
  )
}

export const CrewRecordsProgram = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    message,
    pic_edit,
    creation,
    dnaSearch,
    fingerSearch,
    active = null,
    all_records = []
  } = data;

  return (
    <NtosWindow>
      <NtosWindow.Content>
        {!!active && (
          <RecordContentView
            fill
            active={active}
            canUpdatePhotos={pic_edit}
            onClickClose={() =>
              act("close_record")
            }
            onClickPrint={(uid) =>
              act("print_record", {
                record: uid
              })
            }
            onClickEditField={(field_id) =>
              act("update_record_field", {
                field: field_id
              })
            }
            onClickUpdatePhoto={(target) =>
              act("update_record_photo", {
                target: target
              })
            }
          />
        ) || (
          <RecordsListView
            fill
            records={all_records}
            access={{
              creation: creation,
              dna: dnaSearch,
              finger: fingerSearch,
            }}
            onClickRecord={(id) =>
              act("open_record", {
                record: id
              })
            }
            onClickPrint={(uid) =>
              act("print_record", {
                record: uid
              })
            }
            onClickCreate={() =>
              act("create_record")
            }
          />
        )}
      </NtosWindow.Content>
    </NtosWindow>
  )
}
