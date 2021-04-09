import { NtosWindow } from "tgui/layouts";
import { StationAlertConsoleContent } from 'tgui/interfaces/StationAlertConsole';

export const AlarmMonitorProgram= () => {
  return (
    <NtosWindow
      width={315}
      height={500}
      resizable>
      <NtosWindow.Content scrollable>
        <StationAlertConsoleContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
