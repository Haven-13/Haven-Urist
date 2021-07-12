import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui/components';
import { getGasLabel } from 'tgui/constants';
import { Window } from 'tgui/layouts';
import { PortableBasicInfo } from 'tgui/interfaces/common/PortableAtmos';

export const PortableScrubber = (props, context) => {
  const { act, data } = useBackend(context);
  const filter_types = data.filters || [];
  return (
    <Window
      width={320}
      height={350}>
      <Window.Content>
        <PortableBasicInfo />
        <Section title="Filters">
          {filter_types.map(filter => (
            <Button
              key={filter.id}
              icon={filter.enabled ? 'check-square-o' : 'square-o'}
              content={getGasLabel(filter.name, filter.name)}
              selected={filter.val}
              onClick={() => act('toggle_filter', {
                val: filter.gas_id,
              })} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
