import { useBackend } from 'tgui/backend';
import { Box, Icon, Section, Button, TimeDisplay } from 'tgui/components';
import { Window } from 'tgui/layouts';
import { LabeledControls } from 'tgui/components';

export const EscapePodConsole = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Window
      width={360}
      height={220}>
      <Window.Content>
        <Section
          height={6}
          fontSize={2.5}
          textAlign="center"
        >
          {(!!data.evac_active && !!!data.armed) && (
            <Box color="average">
              ARMING
            </Box>
          )
          || (!!data.armed && data.evac_eta > 0) && (
            <Box
              height={6}
              fillPositionedParent
              color="white"
              backgroundColor="bad"
              fontSize={5}
              >
              <TimeDisplay
                value={data.evac_eta*10}
                auto="down"
                format={(h,m,s) => `${m}:${s}`}
              />
            </Box>
          )
          || (data.docking_status === "docked" && (
            <Box color="green">
              <Icon
                name="check-square"
              /> ALL CLEAR
            </Box>
          ))
          || (data.docking_status === "undocking" && (
            <Box color="average">
              <Icon
                name="exclamation-triangle"
              /> EJECTING
            </Box>
          ))
          || (data.docking_status === "undocked") && (
            <Box color="bad">
              <Icon
                name="ban"
              /> EJECTED
            </Box>
          )
          || (data.docking_status === "docking") && (
            <Box color="average">
              <Icon
                name="sign-in-alt"
              /> INSTALLING
            </Box>
          )
          || "ERROR"}
        </Section>
        <Section
          title="Controls"
          buttons={
            <Button.Checkbox
              fluid
              content="Enable Override"
              disabled={data.docking_status !== "docked"}
              checked={!!data.override_enabled}
              onClick={() => act("command", {
                command: "toggle_override",
              })}
            />
          }
          >
          <LabeledControls>
            <LabeledControls.Item
              label="Hatch Control">
              <Button
                fluid
                icon="sign-in-alt"
                content="Force Hatch"
                disabled={!!!data.can_force}
                color={"red"}
                onClick={() => act("command", {
                  command: "force_door",
                })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Pod Control">
              <Button
                fluid
                icon="unlock"
                content="Force Arm"
                disabled={!!data.armed && !!!data.override_enabled}
                color={"red"}
                onClick={() => act("command", {
                  command: "manual_arm",
                })}
              />
            </LabeledControls.Item>
            <LabeledControls.Item
              label="Launch Control">
              <Button
                fluid
                icon="sign-out-alt"
                content="Manual Eject"
                disabled={!!!data.can_force && data.evac_eta > 0}
                color={"red"}
                onClick={() => act("command", {
                  command: "force_launch",
                })}
              />
            </LabeledControls.Item>
          </LabeledControls>
        </Section>
      </Window.Content>
    </Window>
  );
};
