import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

export const GlandDispenser = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    glands = [],
  } = data;
  return (
    <Window
      width={300}
      height={338}
      theme="abductor">
      <Window.Content>
        <Section>
          {glands.map(gland => (
            <Button
              key={gland.id}
              width="60px"
              height="60px"
              m={0.75}
              textAlign="center"
              lineHeight="55px"
              icon="eject"
              backgroundColor={gland.color}
              content={gland.amount || "0"}
              disabled={!gland.amount}
              onClick={() => act('dispense', {
                gland_id: gland.id,
              })} />
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
