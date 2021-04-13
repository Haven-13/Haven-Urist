import { Fragment } from 'inferno';
import { useBackend } from 'tgui/backend';
import { Button, Flex, LabeledControls, LabeledList, NoticeBox, NumberInput, ProgressBar, Section, Table, Tooltip } from 'tgui/components';
import { round } from 'common/math';
import { formatSiUnit } from 'tgui/format';
import { Window } from 'tgui/layouts';

export const NpcInteraction = (props, context) => {
  const { data, act } = useBackend(context);

  return (
    <Window>
      <Window.Content>

      </Window.Content>
    </Window>
  )
}
