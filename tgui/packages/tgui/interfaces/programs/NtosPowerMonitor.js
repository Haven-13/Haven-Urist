import { NtosWindow } from "tgui/layouts";
import { PowerMonitorContent } from 'tgui/interfaces/PowerMonitor';

export const NtosPowerMonitor = () => {
  return (
    <NtosWindow
      width={550}
      height={700}
      resizable>
      <NtosWindow.Content scrollable>
        <PowerMonitorContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
