import { useBackend } from 'tgui/backend';
import { NoticeBox } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { LaunchpadControl } from './LaunchpadConsole';

export const LaunchpadRemote = (props, context) => {
  const { data } = useBackend(context);
  const {
    has_pad,
    pad_closed,
  } = data;
  return (
    <Window
      title="Briefcase Launchpad Remote"
      width={300}
      height={240}
      theme="syndicate">
      <Window.Content>
        {!has_pad && (
          <NoticeBox>
            No Launchpad Connected
          </NoticeBox>
        ) || pad_closed && (
          <NoticeBox>
            Launchpad Closed
          </NoticeBox>
        ) || (
          <LaunchpadControl topLevel />
        )}
      </Window.Content>
    </Window>
  );
};
