import { NtosWindow } from 'tgui/layouts';
import { AiRestorerContent } from 'tgui/interfaces/AiRestorer';

export const NtosAiRestorer = () => {
  return (
    <NtosWindow
      width={370}
      height={400}
      resizable>
      <NtosWindow.Content scrollable>
        <AiRestorerContent />
      </NtosWindow.Content>
    </NtosWindow>
  );
};
