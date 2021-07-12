import { Modal, Section, Flex, Box, Button, Stack, Icon } from "tgui/components";

export const ErrorMessageModal = (props, context) => {
  const {
    message,
    onClick = () => {},
    ...rest
  } = props;

  return (
    <Modal
      {...rest}
      p={0}
    >
      <Section
        title="Error"
        p={1}
      >
        <Stack vertical>
          <Stack.Item>
            <Flex>
              <Flex.Item width={3}>
                <Icon
                  size={2}
                  name="times"
                />
              </Flex.Item>
              <Flex.Item>
                <Box>
                  {message}
                </Box>
              </Flex.Item>
            </Flex>
          </Stack.Item>
          <Stack.Item align="right">
            <Flex justify="flex-end">
              <Flex.Item>
                <Button
                  content="OK"
                  onClick={() => onClick()}
                />
              </Flex.Item>
            </Flex>
          </Stack.Item>
        </Stack>
      </Section>
    </Modal>
  );
};
