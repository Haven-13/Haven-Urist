import { classes } from 'common/react';
import { uniqBy } from 'common/collections';
import { useBackend, useSharedState } from 'tgui/backend';
import { formatSiUnit, formatMoney } from 'tgui/format';
import { Flex, Section, Tabs, Box, Button, Fragment, ProgressBar, NumberInput, Icon, Input } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { createSearch } from 'common/string';

const MATERIAL_KEYS = {
  "steel": "sheet-metal",
  "glass": "sheet-glass",
  "plasteel": "sheet-plasteel",
  "silver": "sheet-silver",
  "gold": "sheet-gold",
  "diamond": "sheet-diamond",
  "phoron": "sheet-phoron",
  "uranium": "sheet-uranium",
  "titanium": "sheet-titanium",
  "plastic": "sheet-plastic",
};

const COLOR_NONE = 0;
const COLOR_AVERAGE = 1;
const COLOR_BAD = 2;

const COLOR_KEYS = {
  [COLOR_NONE]: false,
  [COLOR_AVERAGE]: "average",
  [COLOR_BAD]: "bad",
};

const materialArrayToObj = materials => {
  let materialObj = {};

  materials.forEach(m => {
    materialObj[m.name] = m.amount; });

  return materialObj;
};

const partBuildColor = (cost, tally, material) => {
  if (cost > material) {
    return { color: COLOR_BAD, deficit: (cost - material) };
  }

  if (tally > material) {
    return { color: COLOR_AVERAGE, deficit: cost };
  }

  if (cost + tally > material) {
    return { color: COLOR_AVERAGE, deficit: ((cost + tally) - material) };
  }

  return { color: COLOR_NONE, deficit: 0 };
};

const partCondFormat = (materials, tally, part) => {
  let format = { "textColor": COLOR_NONE };

  Object.keys(part.cost).forEach(mat => {
    format[mat] = partBuildColor(part.cost[mat], tally[mat], materials[mat]);

    if (format[mat].color > format["textColor"]) {
      format["textColor"] = format[mat].color;
    }
  });

  return format;
};

const queueCondFormat = (materials, queue) => {
  let materialTally = {};
  let matFormat = {};
  let missingMatTally = {};
  let textColors = {};

  queue.forEach((part, i) => {
    textColors[i] = COLOR_NONE;
    Object.keys(part.cost).forEach(mat => {
      materialTally[mat] = materialTally[mat] || 0;
      missingMatTally[mat] = missingMatTally[mat] || 0;

      matFormat[mat] = partBuildColor(
        part.cost[mat], materialTally[mat], materials[mat]
      );

      if (matFormat[mat].color !== COLOR_NONE) {
        if (textColors[i] < matFormat[mat].color) {
          textColors[i] = matFormat[mat].color;
        }
      }
      else {
        materialTally[mat] += part.cost[mat];
      }

      missingMatTally[mat] += matFormat[mat].deficit;
    });
  });
  return { materialTally, missingMatTally, textColors, matFormat };
};

const searchFilter = (search, allparts) => {
  let searchResults = [];

  if (!search.length) {
    return;
  }

  const resultFilter = createSearch(search, part => (
    (part.name || "")
    + (part.desc || "")
    + (part.searchMeta || "")
  ));

  Object.keys(allparts).forEach(category => {
    allparts[category]
      .filter(resultFilter)
      .forEach(e => { searchResults.push(e); });
  });

  searchResults = uniqBy(part => part.name)(searchResults);

  return searchResults;
};

export const ExosuitFabricator = (props, context) => {
  const { act, data } = useBackend(context);

  const brands = data.brands || [];
  const categories = data.categories || [];
  const queue = data.queue || [];
  const materialAsObj = materialArrayToObj(data.materials || []);

  const {
    materialTally,
    missingMatTally,
    textColors,
  } = queueCondFormat(materialAsObj, queue);

  const [
    displayMatCost,
    setDisplayMatCost,
  ] = useSharedState(context, "display_mats", false);

  return (
    <Window
      title="Exosuit Fabricator"
      width={950}
      height={540}>
      <Window.Content>
        <Flex
          spacing={1}
          direction="column"
          height="100%">
          <Flex.Item>
            <Flex
              width="100%"
              direction="row">
              <Flex.Item
                grow={1}
                width="100%">
                <Section
                  fill
                  width="100%"
                  title="Materials">
                  <Materials />
                </Section>
              </Flex.Item>
              <Flex.Item
                ml={1}
                grow={1}
                basis="content">
                <Section
                  title="Settings"
                  height="100%"
                  width="250px"
                  buttons={(
                    <Button
                      content="R&D Sync"
                      onClick={() => act("sync_rnd")} />
                  )}>
                  <Button.Checkbox
                    onClick={() => setDisplayMatCost(!displayMatCost)}
                    checked={displayMatCost}>
                    Display Material Costs
                  </Button.Checkbox>
                </Section>
              </Flex.Item>
            </Flex>
          </Flex.Item>
          <Flex.Item mt={1} height="100%">
            <Flex
              spacing={1}
              direction="row"
              height="100%">
              <Flex.Item>
                <Section
                  height="100%"
                  fill
                  fitted
                  width={15}
                  title="Brands">
                  <Brands
                    height="100%"
                    overflowY="auto"
                  />
                </Section>
              </Flex.Item>
              <Flex.Item>
                <Section
                  height="100%"
                  fill
                  fitted
                  width={15}
                  title="Categories">
                  <Categories
                    height="100%"
                    overflowY="auto"
                  />
                </Section>
              </Flex.Item>
              <Flex.Item grow={1}>
                <PartLists
                  height="100%"
                  queueMaterials={materialTally}
                  materials={materialAsObj} />
              </Flex.Item>
              <Flex.Item width="250px">
                <Queue
                  queueMaterials={materialTally}
                  missingMaterials={missingMatTally}
                  textColors={textColors} />
              </Flex.Item>
            </Flex>
          </Flex.Item>
        </Flex>
      </Window.Content>
    </Window>
  );
};

const EjectMaterial = (props, context) => {
  const { act } = useBackend(context);

  const { material } = props;

  const {
    name,
    removable,
    sheets,
    ref,
  } = material;

  const [
    removeMaterials,
    setRemoveMaterials,
  ] = useSharedState(context, "remove_mats_" + name, 1);

  if ((removeMaterials > 1) && (sheets < removeMaterials)) {
    setRemoveMaterials(sheets || 1);
  }

  return (
    <Fragment>
      <NumberInput
        width="30px"
        animated
        value={removeMaterials}
        minValue={1}
        maxValue={sheets || 1}
        initial={1}
        onDrag={(e, val) => {
          const newVal = parseInt(val, 10);
          if (Number.isInteger(newVal)) {
            setRemoveMaterials(newVal);
          }
        }} />
      <Button
        icon="eject"
        disabled={!removable}
        onClick={() => act("eject_material", {
          eject_material: ref,
          amount: removeMaterials,
        })} />
    </Fragment>
  );
};

const Materials = (props, context) => {
  const { data } = useBackend(context);

  const materials = data.materials || [];

  return (
    <Flex
      wrap="wrap">
      {materials.map(material => (
        <Flex.Item
          width="80px"
          key={material.ref}>
          <MaterialAmount
            name={material.name}
            amount={material.amount}
            reference={material.ref}
            formatsi />
          <Box
            mt={1}
            style={{ "text-align": "center" }}>
            <EjectMaterial
              material={material} />
          </Box>
        </Flex.Item>
      ))}
    </Flex>
  );
};

const MaterialAmount = (props, context) => {
  const {
    name,
    amount,
    reference,
    small,
    list,
    formatsi,
    formatmoney,
    color,
    style,
  } = props;

  return list ? (
    <Box height="15px">
      <Box textAlign="center" style={{ position: "relative", "z-index": 1, "line-height": 2 }}>{(formatsi && formatSiUnit(amount, 0)) || (formatmoney && formatMoney(amount)) || (amount)}</Box>
      <Box
        className={classes([
          'sheetmaterials32x32',
          MATERIAL_KEYS[reference ? reference : name],
        ])}
        style={style}
      />
    </Box>
  ) : (
    <Flex
      direction="column"
      align="center">
      <Flex.Item>
        <Box
          className={classes([
            'sheetmaterials32x32',
            MATERIAL_KEYS[reference ? reference : name],
          ])}
          style={style} />
      </Flex.Item>
      {!small && (
        <Flex.Item>
          {name}
        </Flex.Item>
      )}
      <Flex.Item>
        <Box
          textColor={color}
          style={{ "text-align": "center" }}>
          {(formatsi && formatSiUnit(amount, 0))
          || (formatmoney && formatMoney(amount))
          || (amount)}
        </Box>
      </Flex.Item>
    </Flex>
  );
};

const Brands = (props, context) => {
  const { act, data } = useBackend(context);

  const brands = data.brands || [];

  return (
    <Tabs
      vertical
      {...props}>
      {brands.map(brand => (
        <Tabs.Tab
          key={brand}
          selected={brand === data.brand}
          onClick={() => act("set_brand", {
            set_brand: brand,
          })}>
          {brand}
        </Tabs.Tab>
      ))}
    </Tabs>
  );
};

const Categories = (props, context) => {
  const { data } = useBackend(context);

  const categories = data.categories || [];
  const buildable = data.buildable || {};

  const [
    selectedCategory,
    setSelectedCategory,
  ] = useSharedState(
    context,
    "category",
    categories.length ? categories[0] : ""
  );

  return (
    <Tabs
      vertical
      {...props}>
      {categories.map(category => (
        !!(buildable[category]) && (
          <Tabs.Tab
            key={category}
            selected={category === selectedCategory}
            disabled={!(buildable[category])}
            onClick={() => setSelectedCategory(category)}>
            {category}
          </Tabs.Tab>
        )
      ))}
    </Tabs>
  );
};

const PartLists = (props, context) => {
  const { data } = useBackend(context);

  const getFirstValidCategory = (categories => {
    for (let category of categories) {
      if (buildable[category]) {
        return category;
      }
    }
    return null;
  });

  const categories = data.categories || [];
  const buildable = data.buildable || [];

  const {
    queueMaterials,
    materials,
  } = props;

  const [
    selectedCategory,
    setSelectedCategory,
  ] = useSharedState(
    context,
    "category",
    getFirstValidCategory(categories)
  );

  const [
    searchText,
    setSearchText,
  ] = useSharedState(context, "search_text", "");

  if (!selectedCategory || !buildable[selectedCategory]) {
    const validSet = getFirstValidCategory(categories);
    if (validSet) {
      setSelectedCategory(validSet);
    }
    else {
      return;
    }
  }

  let partsList;
  // Build list of sub-categories if not using a search filter.
  if (!searchText) {
    partsList = { "Parts": [] };
    buildable[selectedCategory].forEach(part => {
      part["format"] = partCondFormat(materials, queueMaterials, part);
      if (!part.subCategory) {
        partsList["Parts"].push(part);
        return;
      }
      if (!(part.subCategory in partsList)) {
        partsList[part.subCategory] = [];
      }
      partsList[part.subCategory].push(part);
    });
  }
  else {
    partsList = [];
    searchFilter(searchText, buildable).forEach(part => {
      part["format"] = partCondFormat(materials, queueMaterials, part);
      partsList.push(part);
    });
  }


  return (
    <Box {...props}>
      <Flex
        direction="column"
        height="100%">
        <Flex.Item basis="content">
          <Section fill height={3}>
            <Flex>
              <Flex.Item mr={1}>
                <Icon
                  name="search" />
              </Flex.Item>
              <Flex.Item
                grow={1}>
                <Input
                  fluid
                  placeholder="Search for..."
                  value={searchText}
                  onInput={(e, v) => setSearchText(v)} />
              </Flex.Item>
            </Flex>
          </Section>
        </Flex.Item>
        <Flex.Item mt={1} height="100%">
          {(!!searchText && (
            <PartCategory
              height="100%"
              name={"Search Results"}
              parts={partsList}
              forceShow
              placeholder="No matching results..." />
          )) || (
            Object.keys(partsList).map(category => (
              <PartCategory
                height="100%"
                key={category}
                name={category}
                parts={partsList[category]} />
            ))
          )}
        </Flex.Item>
      </Flex>
    </Box>
  );
};

const PartCategory = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    parts,
    name,
    forceShow,
    placeholder,
  } = props;

  const [
    displayMatCost,
  ] = useSharedState(context, "display_mats", false);

  return (
    ((!!parts.length || forceShow) && (
      <Section
        title={name}
        fitted
        fill
        buttons={
          <Button
            disabled={!parts.length}
            color="good"
            content="Queue All"
            icon="plus-circle"
            onClick={() => act("add_queue_set", {
              category: parts.map(part => part.id),
            })} />
        }
        {...props}>
        <Box
          mt={1}
          pl={1}
          pr={1}
          height="100%"
          overflow="auto">
          {(!parts.length) && (placeholder)}
          {parts.map(part => (
            <Fragment
              key={part.name}>
              <Flex
                align="center">
                <Flex.Item>
                  <Button
                    color="average"
                    height="20px"
                    mr={1}
                    icon="plus-circle"
                    onClick={() => act("add_queue_part", { id: part.id })} />
                </Flex.Item>
                <Flex.Item>
                  <Box
                    inline
                    textColor={COLOR_KEYS[part.format.textColor]}>
                    {part.name}
                  </Box>
                </Flex.Item>
                <Flex.Item
                  grow={1} />
                <Flex.Item>
                  <Button
                    icon="question-circle"
                    transparent
                    height="20px"
                    tooltip={
                      "Build Time: "
                      + part.time + "s. "
                      + (part.desc || "")
                    }
                    tooltipPosition="left" />
                </Flex.Item>
              </Flex>
              {(displayMatCost && (
                <Flex mb={2}>
                  {Object.keys(part.cost).map(material => (
                    <Flex.Item
                      width={"40px"}
                      key={material}
                      color={COLOR_KEYS[part.format[material].color]}>
                      <MaterialAmount
                        style={{
                          position: "relative",
                          opacity: 0.7,
                          transform: 'scale(0.8) translate(0%, -100%)',
                        }}
                        name={material}
                        reference={material}
                        small
                        list
                        formatsi
                        amount={part.cost[material]} />
                    </Flex.Item>
                  ))}
                </Flex>
              ))}
            </Fragment>
          ))}
        </Box>
      </Section>
    ))
  );
};

const Queue = (props, context) => {
  const { act, data } = useBackend(context);

  const { isProcessingQueue } = data;

  const queue = data.queue || [];

  const {
    queueMaterials,
    missingMaterials,
    textColors,
  } = props;

  return (
    <Flex
      height="100%"
      width="100%"
      direction="column">
      <Flex.Item
        height={0}
        grow={1}>
        <Section
          height="100%"
          title="Queue"
          overflowY="auto"
          buttons={
            <Fragment>
              <Button.Confirm
                disabled={!queue.length}
                color="bad"
                icon="minus-circle"
                content="Clear"
                onClick={() => act("clear_queue")}
                tooltip={"Clear the queue"}
                tooltipPosition="left"
              />
              {(!!isProcessingQueue && (
                <Button
                  disabled={!queue.length}
                  content="Stop"
                  icon="stop"
                  onClick={() => act("stop_queue")}
                  tooltip={"Stop building the queue"}
                  tooltipPosition="left"
                />
              )) || (
                <Button
                  disabled={!queue.length}
                  content="Start"
                  icon="play"
                  onClick={() => act("build_queue")}
                  tooltip={"Start building the queue"}
                  tooltipPosition="left"
                />
              )}
            </Fragment>
          }>
          <Flex
            direction="column"
            height="100%">
            <Flex.Item>
              <BeingBuilt />
            </Flex.Item>
            <Flex.Item>
              <QueueList
                textColors={textColors} />
            </Flex.Item>
          </Flex>
        </Section>
      </Flex.Item>
      {!!queue.length && (
        <Flex.Item mt={1}>
          <Section
            title="Material Cost">
            <QueueMaterials
              queueMaterials={queueMaterials}
              missingMaterials={missingMaterials} />
          </Section>
        </Flex.Item>
      )}
    </Flex>
  );
};

const QueueMaterials = (props, context) => {
  const {
    queueMaterials,
    missingMaterials,
  } = props;

  return (
    <Flex wrap="wrap">
      {Object.keys(queueMaterials).map(material => (
        <Flex.Item
          width="12%"
          key={material}>
          <MaterialAmount
            formatmoney
            name={material}
            reference={material}
            small
            formatsi
            amount={queueMaterials[material]} />
          {(!!missingMaterials[material] && (
            <Box
              textColor="bad"
              style={{ "text-align": "center" }}>
              {formatMoney(missingMaterials[material])}
            </Box>
          ))}
        </Flex.Item>
      ))}
    </Flex>
  );
};

const QueueList = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    textColors,
  } = props;

  const queue = data.queue || [];

  if (!queue.length) {
    return (
      <Fragment>
        No parts in queue.
      </Fragment>
    );
  }

  return (
    queue.map((part, index) => (
      <Box
        key={part.name}>
        <Flex
          mb={0.5}
          direction="column"
          justify="center"
          wrap="wrap"
          height="20px" inline>
          <Flex.Item
            basis="content">
            <Button
              height="20px"
              mr={1}
              icon="minus-circle"
              color="bad"
              onClick={() => act("del_queue_part", { index: index+1 })} />
          </Flex.Item>
          <Flex.Item>
            <Box
              inline
              textColor={COLOR_KEYS[textColors[index]]}>
              {part.name}
            </Box>
          </Flex.Item>
        </Flex>
      </Box>
    ))
  );
};

const BeingBuilt = (props, context) => {
  const { data } = useBackend(context);

  const {
    current,
    storedPart,
  } = data;

  if (storedPart) {
    const {
      name,
    } = storedPart;

    return (
      <Box>
        <ProgressBar
          minValue={0}
          maxValue={1}
          value={1}
          color="average">
          <Flex>
            <Flex.Item>
              {name}
            </Flex.Item>
            <Flex.Item
              grow={1} />
            <Flex.Item>
              {"Fabricator outlet obstructed..."}
            </Flex.Item>
          </Flex>
        </ProgressBar>
      </Box>
    );
  }

  if (current) {
    const {
      name,
      duration,
      time,
    } = current;

    const timeLeft = Math.ceil(duration);

    return (
      <Box>
        <ProgressBar
          minValue={0}
          maxValue={time}
          value={-(duration-time)}>
          <Flex>
            <Flex.Item>
              {name}
            </Flex.Item>
            <Flex.Item
              grow={1} />
            <Flex.Item>
              {((timeLeft >= 0) && (timeLeft + "s")) || ("Dispensing...")}
            </Flex.Item>
          </Flex>
        </ProgressBar>
      </Box>
    );
  }
};
