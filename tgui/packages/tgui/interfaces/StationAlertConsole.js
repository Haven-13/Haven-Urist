import { Fragment } from 'inferno';
import { useBackend } from 'tgui/backend';
import { NoticeBox, Section } from 'tgui/components';
import { Window } from 'tgui/layouts';

export const StationAlertConsole = () => {
  return (
    <Window
      width={325}
      height={500}
      resizable>
      <Window.Content scrollable>
        <StationAlertConsoleContent />
      </Window.Content>
    </Window>
  );
};

export const StationAlertConsoleContent = (props, context) => {
  const { data } = useBackend(context);
  const categories = data.categories || [];
  return (
    <div>
      {categories.map(category => (
        <Section title={category.name} key={category.name}>
          <ul>
            {category.alarms.length === 0 && (
              <li className="color-good">
                Systems Nominal
              </li>
            ) || (category.alarms.map(alarm => (
              <li key={alarm.name} className="color-average">
                {alarm.name}
              </li>
            )))}
          </ul>
        </Section>
      ))}
    </div>
  );
};
