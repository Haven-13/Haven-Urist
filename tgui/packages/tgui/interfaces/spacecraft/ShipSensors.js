import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { round } from 'common/math';
import { Button, LabeledList, Section, LabeledControls, NumberInput, ProgressBar } from 'tgui/components';

export const ShipSensors = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <Window
      width={300}
      height={250}
    >
      <Window.Content>
        <Section
          title="Status"
        >
          <LabeledList>
            <LabeledList.Item
              label="Status"
            >
              {data.status ? data.status : "Hardware Error"}
            </LabeledList.Item>
            <LabeledList.Item
              label="Integrity"
            >
              <ProgressBar
                value={data.health}
                minValue={0}
                maxValue={data.maxHealth}
                ranges={{
                  good: [data.maxHealth/3*2, Infinity],
                  average: [data.maxHealth/3, data.maxHealth/3*2],
                  bad: [-Infinity, data.maxHealth/3]
                }}
              >
                {data.health} ({data.health/data.maxHealth * 100} %)
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item
              label="Temperature"
            >
              <ProgressBar
                value={data.heat}
                maxValue={data.criticalHeat}
                ranges={{
                  good: [0, round(data.criticalHeat/2)],
                  average: [round(data.criticalHeat/2), data.criticalHeat],
                  bad: [data.criticalHeat, Infinity]
                }}
              >
                {round(data.heat)} K
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Actions"
        >
          <LabeledControls>
            <LabeledControls.Item
              label="Power"
            >
              <Button
                selected={data.on}
                content={data.on ? "Switch On" : "Switch Off"}
                onClick={() => {act("toggle")}}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Range"
            >
              <NumberInput
                width={4}
                value={data.range}
                minValue={data.minRange}
                maxValue={data.maxRange}
                onChange={(e, value) => {act("range",{
                  range: round(value)
                })}}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Map View"
            >
              <Button
                icon="eye"
                selected={data.viewing}
                content={"Toggle"}
                onClick={() => {act("viewing")}}
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  )
}
