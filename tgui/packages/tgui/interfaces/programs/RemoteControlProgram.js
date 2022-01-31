import { useBackend } from "tgui/backend";
import { Section } from "tgui/components";
import { Button } from "tgui/components/Button";
import { NtosWindow } from "tgui/layouts";

export const RemoteControlProgram = (props, context) => {
  const { act, data } = useBackend(context);
  return (
    <NtosWindow>
      <NtosWindow.Content>
        <table>
          <tr>
            <td>
              <Section>
                <Button.Checkbox />
              </Section>
            </td>
          </tr>
          <tr>
            <td>
              <Section title="SMES Units" />
            </td>
            <td>
              <Section title="Breakers" />
            </td>
          </tr>
        </table>
      </NtosWindow.Content>
    </NtosWindow>
  );
};
