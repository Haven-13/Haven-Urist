import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { round } from 'common/math';
import { Button, Flex, LabeledList, Section, LabeledControls, NumberInput, ProgressBar } from 'tgui/components';
import { ShipOvermapNavigationInfo, ShipOvermapSectorInfo } from './ShipComputerCommon';

export const ShipNavigation = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={450}
      height={300}>
      <Window.Content>
        <Section
          buttons={(
              <Button
                icon="eye"
                selected={data.viewing}
                content="Toggle"
                onClick={() => act("view")}
              />
            )}
          title="Sector Info">
          <Flex
          spacing={1}>
            <Flex.Item>
              <ShipOvermapNavigationInfo />
            </Flex.Item>
            <Flex.Item>
              <ShipOvermapSectorInfo />
            </Flex.Item>
          </Flex>
        </Section>
      </Window.Content>
    </Window>
  );
};
