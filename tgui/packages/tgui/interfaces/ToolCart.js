import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, Section, LabeledList } from 'tgui/components';
import { Window } from '../layouts';

export const ToolCart = (props, context) => {
  const {act, data} = useBackend(context);
  const items = data.items || [];
  const stacks = data.stacks || [];
  return (
    <Window
      width={250}
      height={350}
    >
      <Window.Content>
        <LabeledList>
          {items.map(item => (
            <LabeledList.Item
              key={item.key}
              label={item.label}
            >
              {item.name ? item.name : "None"}
            </LabeledList.Item>
          ))}
        </LabeledList>
      </Window.Content>
    </Window>
  );
}
