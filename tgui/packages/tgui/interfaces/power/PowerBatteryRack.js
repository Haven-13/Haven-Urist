import { useBackend } from "tgui/backend";
import { Box, Button, Knob, LabeledControls, ProgressBar, Section } from "tgui/components";
import { formatSiUnit } from "tgui/format";
import { Window } from "tgui/layouts";

export const PowerBatteryRack = (props, context) => {
  const { data, act } = useBackend(context);
  const {
    mode,
    cells,
    equalise,
    input_load,
    output_load,
    transfer_max,
  } = data;
  const MODES = [
    "Offline",
    "Input only",
    "Output only",
    "Automatic",
  ];
  return (
    <Window>
      <Section>
        <LabeledControls>
          <LabeledControls.Item label="Input">
            <ProgressBar
              value={input_load}
              maxValue={transfer_max}
            >
              {formatSiUnit(input_load, 0, "W")}
            </ProgressBar>
          </LabeledControls.Item>
          <LabeledControls.Item label="Output">
            <ProgressBar
              value={output_load}
              maxValue={transfer_max}
            >
              {formatSiUnit(output_load, 0, "W")}
            </ProgressBar>
          </LabeledControls.Item>
          <LabeledControls.Item label="Mode">
            {MODES[mode]}
          </LabeledControls.Item>
          <LabeledControls.Item label="Control">
            <Knob
              animated
              minValue={0}
              maxValue={3}
              format={(v) => `${v} (${MODES[v]})`}
              onChange={(e, v) => {
                if (v) act("enable", { mode: v });
                else act("disable");
              }}
            />
          </LabeledControls.Item>
        </LabeledControls>
      </Section>
      <Section
        title="Cells"
        buttons={(
          <Button.Checkbox
            content="Equalise"
            checked={!!equalise}
            onClick={() => act("equalise")}
          />
        )}
      >
        <table>
          <tr>
            <th>#</th>
            <th>Charge</th>
            <th>Action</th>
          </tr>
          {cells.map((cell) => (
            <tr key={cell.slot}>
              <td>{cell.slot}</td>
              <td>{cell.used && (
                <ProgressBar />
              ) || (
                <Box italic>Empty</Box>
              )}
              </td>
              <td>{cell.used && (
                <Button
                  content="Eject"
                />
              ) || (
                <Button
                  content="Insert"
                />
              )}
              </td>
            </tr>
          ))}
        </table>
      </Section>
    </Window>
  );
};
