import { RequestKioskContent } from 'tgui/interfaces/RequestKiosk';
import { NtosWindow } from "tgui/layouts";

export const NtosRequestKiosk = (props, context) => {
  return (
    <NtosWindow
      width={550}
      height={600}
      resizable>
      <NtosWindow.Content scrollable>
        <RequestKioskContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
