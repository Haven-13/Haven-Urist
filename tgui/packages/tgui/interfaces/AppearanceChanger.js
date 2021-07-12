import { useBackend } from "tgui/backend"
import { Button, Flex, Section, Stack } from "tgui/components";
import { Window } from "tgui/layouts";

const AppearanceContent = (props, context) => {
  const {
    title,
    content = [],
    checked = (v) => false,
    format = (v) => {},
    onSelect = (v) => {},
  } = props;
  return (
    <Stack vertical fill width={15}>
      <Stack.Item bold>
        {title}
      </Stack.Item>
      <Stack.Item grow>
        <Section fill scrollable>
          {content.map((entry, index) => (
            <Button.Checkbox
              key={index}
              fluid
              checked={checked(entry)}
              onClick={() => onSelect(entry)}
            >
              {format(entry)}
            </Button.Checkbox>
          ))}
        </Section>
      </Stack.Item>
    </Stack>
  )
}

export const AppearanceChanger = (props, context) => {
  const {act, data} = useBackend(context);
  const {
    specimen,
    species,
    gender,
    genders,
    hair_styles,
    hair_style,
    facial_hair_styles,
    facial_hair_style,
  } = data;
  return (
    <Window
      width={750}
      height={400}
    >
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Flex>
              <Flex.Item>
                <Button
                  content="Skin tone"
                  onClick={() => act("skin_tone")}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Skin colour"
                  onClick={() => act("skin_color")}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Hair colour"
                  onClick={() => act("hair_color")}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Facial colour"
                  onClick={() => act("facial_hair_color")}
                />
              </Flex.Item>
              <Flex.Item>
                <Button
                  content="Eye colour"
                  onClick={() => act("eye_color")}
                />
              </Flex.Item>
            </Flex>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item>
                <AppearanceContent
                  title={"Species"}
                  content={species}
                  checked={(entry) =>
                    entry.specimen === specimen
                  }
                  format={(entry) => entry.specimen}
                  onSelect={(entry) => act("race", {
                    race: entry.specimen
                  })}
                />
              </Stack.Item>
              <Stack.Item>
                <AppearanceContent
                  title={"Gender"}
                  content={genders}
                  checked={(entry) =>
                    entry.gender_key === gender
                  }
                  format={(entry) => entry.gender_name}
                  onSelect={(entry) => act("gender", {
                    gender: entry.gender_key
                  })}
                />
              </Stack.Item>
              <Stack.Item>
                <AppearanceContent
                  title={"Hair"}
                  content={hair_styles}
                  checked={(entry) =>
                    entry.hairstyle === hair_style
                  }
                  format={(entry) => entry.hairstyle}
                  onSelect={(entry) => act("hair", {
                    hair: entry.hairstyle
                  })}
                />
              </Stack.Item>
              <Stack.Item>
                <AppearanceContent
                  title={"Facial Hair"}
                  content={facial_hair_styles}
                  checked={(entry) =>
                    entry.facialhairstyle === facial_hair_style
                  }
                  format={(entry) => entry.facialhairstyle}
                  onSelect={(entry) => act("facial_hair", {
                    facial_hair: entry.facialhairstyle
                  })}
                />
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  )
}
