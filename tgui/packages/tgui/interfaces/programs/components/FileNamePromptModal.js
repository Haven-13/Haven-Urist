import { useSharedState } from "tgui/backend";
import { Modal, Section, Stack, Button, Flex, Input } from "tgui/components";

export const FileNamePromptModal = (props, context) => {
  const {
    title = "Enter a file name",
    value,
    onCancel,
    onAccept,
    ...rest
  } = props;

  const [
    currentInput,
    setCurrentInput,
  ] = useSharedState(context, "currentInput", value);

  return (
    <Modal
      p={0}
      {...rest}
    >
      <Section
        title={title}
      >
        <Stack vertical>
          <Stack.Item>
            <Input
              fluid
              value={currentInput}
              onInput={(e, v) => setCurrentInput(v)}
            />
          </Stack.Item>
          <Stack.Item>
            <Flex
              direction="row"
              justify="flex-end"
            >
              <Flex.Item mr={2}>
                <Button
                  content="Proceed"
                  onClick={() => onAccept(currentInput)}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Cancel"
                  onClick={() => onCancel()}
                />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  );
};
