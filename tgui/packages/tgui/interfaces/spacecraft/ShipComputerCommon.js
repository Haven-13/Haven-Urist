import { useBackend } from "tgui/backend";
import { Section, LabeledList } from "tgui/components";

export const ShipOvermapNavigationInfo = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Section
      title="Flight Data"
      height="100%">
      <LabeledList>
        <LabeledList.Item
          label="X : Y">
          {data.s_x} : {data.s_y}
        </LabeledList.Item>
        <LabeledList.Item
          label="ETA">
          {data.etaNext} seconds
        </LabeledList.Item>
        <LabeledList.Item
          label="Velocity">
          {data.speed}
        </LabeledList.Item>
        <LabeledList.Item
          label="delta-V">
          {data.acceleration}
        </LabeledList.Item>
        <LabeledList.Item
          label="Heading">
          {data.heading}&deg;
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

export const ShipOvermapSectorInfo = (props, context) => {
  const { act, data } = useBackend(context);

  return (
    <Section
      title="Location Data"
      height="100%"
      maxHeight={15}>
      <LabeledList>
        <LabeledList.Item
          label="Name">
          {data.sector}
        </LabeledList.Item>
        <LabeledList.Item
          label="X : Y">
          {data.s_x} : {data.s_y}
        </LabeledList.Item>
        <LabeledList.Item
          label="Additional Info"
        />
      </LabeledList>
      {data.sectorInfo}
    </Section>
  );
};
