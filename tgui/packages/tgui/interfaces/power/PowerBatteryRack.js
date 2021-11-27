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
    "Output only",
    "Input only",
    "Automatic",
  ];
  return (
    <Window
      width={400}
      height={400}
    >
      <Section>
        <LabeledControls>
          <LabeledControls.Item label="Input">
            <ProgressBar
              width={9}
              value={input_load}
              maxValue={transfer_max}
            >
              {formatSiUnit(input_load, 0, "W")}
            </ProgressBar>
          </LabeledControls.Item>
          <LabeledControls.Item label="Output">
            <ProgressBar
              width={9}
              value={output_load}
              maxValue={transfer_max}
            >
              {formatSiUnit(output_load, 0, "W")}
            </ProgressBar>
          </LabeledControls.Item>
          <LabeledControls.Item label="Mode" width={5}>
            {MODES[mode]}
          </LabeledControls.Item>
          <LabeledControls.Item label="Control">
            <Knob
              animated
              value={mode}
              minValue={0}
              maxValue={3}
              displayPos="left"
              step={1}
              stepPixelSize={25}
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
        <table width="100%">
          <tr>
            <th>#</th>
            <th width={300}>Charge</th>
            <th>Action</th>
          </tr>
          {cells.map((cell) => (
            <tr key={cell.slot} style={{ "line-height": "1.8em" }}>
              <td>{cell.slot}</td>
              <td>{cell.used && (
                <ProgressBar
                  value={cell.charge}
                  maxValue={cell.capacity}
                >
                  {formatSiUnit(cell.charge, 0, "W")} / {
                    formatSiUnit(cell.capacity, 0, "W")
                  }
                </ProgressBar>
              ) || (
                <Box textAlign="center" italic>Empty</Box>
              )}
              </td>
              <td>{!!cell.used && (
                <Button
                  fluid
                  icon="sign-out-alt"
                  content="Eject"
                  onClick={() => act("ejectcell", { eject: cell.id })}
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
