import { map } from 'common/collections';
import { toFixed } from 'common/math';
import { useBackend } from 'tgui/backend';
import { Box, Button, ColorBox, LabeledList, NumberInput, Section } from 'tgui/components';
import { RADIO_CHANNELS } from 'tgui/constants';
import { Window } from 'tgui/layouts';

export const Radio = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    frequencyLock,
    frequency,
    frequencyMin,
    frequencyMax,
    microphone,
    speaker,
    subspace,
    canUseChannels,
  } = data;
  const tunedChannel = RADIO_CHANNELS
    .find(channel => channel.freq === frequency);
  const channels = map((value, key) => ({
    key: key,
    frequency: value.channel,
    name: value.displayName,
    status: value.listening,
  }))(data.channels);
  const showChannels = !frequencyLock && (subspace || canUseChannels);
  // Calculate window height
  let height = 106;
  if (showChannels) {
    if (channels.length > 0) {
      height += channels.length * 21 + 6;
    }
    else {
      height += 24;
    }
  }
  return (
    <Window
      width={360}
      height={height}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Frequency">
              {frequencyLock && (
                <Box inline color="light-gray">
                  {toFixed(frequency / 10, 1) + ' kHz'}
                </Box>
              ) || (
                <NumberInput
                  animate
                  unit="kHz"
                  step={1}
                  stepPixelSize={10}
                  minValue={frequencyMin}
                  maxValue={frequencyMax}
                  value={frequency}
                  format={value => toFixed(value/10, 1)}
                  onDrag={(e, value) => act('frequency', {
                    value: value,
                  })} />
              )}
              {tunedChannel && (
                <Box inline color={tunedChannel.color} ml={2}>
                  [{tunedChannel.name}]
                </Box>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Audio">
              <Button
                textAlign="center"
                width="37px"
                icon={speaker.status ? 'volume-up' : 'volume-mute'}
                selected={speaker.status}
                onClick={() => act('listen')} />
              <Button
                textAlign="center"
                width="37px"
                icon={microphone.status ? 'microphone' : 'microphone-slash'}
                selected={microphone.status}
                onClick={() => act('broadcast')} />
            </LabeledList.Item>
            {!!showChannels && (
              <LabeledList.Item label="Channels">
                {channels.length === 0 && (
                  <Box inline color="bad">
                    No encryption keys installed.
                  </Box>
                )}
                {channels.map(channel => (
                  <Box key={channel.name}>
                    <ColorBox
                      mr={1}
                      color={RADIO_CHANNELS.find(c => c.name === channel.name)?.color}
                    />
                    <Button
                      width={15}
                      icon={channel.status || channel.frequency == frequency ? 'check-square-o' : 'square-o'}
                      selected={channel.status || channel.frequency == frequency}
                      content={channel.name}
                      onClick={() => subspace ? act('channel', {
                        channel: channel.name,
                      }) : act('frequency', {
                        channel: channel.frequency,
                      })} />
                  </Box>
                ))}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
