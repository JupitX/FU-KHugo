import { VectorMap } from "@react-jvectormap/core"
import { worldMill } from "@react-jvectormap/world"
import Palette from "../common/Colors";

interface CountryMapProperties {
    mapColor?: string;
}

const CountryMap: React.FC<CountryMapProperties> = ({ mapColor }) => {

    return (
        <VectorMap
            map={worldMill}
            backgroundColor = "transparent"
            markerStyle = {{
                initial: {
                    fill: Palette.light.electricBlue,
                    r: 4,
                } as any,
            }}
            markersSelectable = {true}
            markers = {[ // Make this dynamic
                {
                    latLng: [37.2580397, -104.657039],
                    name: "United States",
                    style: {
                        fill: Palette.light.electricBlue,
                        borderWidth: 1,
                        borderColor: "white",
                        stroke: Palette.light.gray
                    }
                },
                {
                    latLng: [20.7504374, 73.7276105],
                    name: "India",
                    style: { fill: Palette.light.electricBlue, borderWidth: 1, borderColor: "white" },
                },
                {
                    latLng: [53.613, -11.6368],
                    name: "United Kingdom",
                    style: { fill: Palette.light.electricBlue, borderWidth: 1, borderColor: "white" }
                },
                {
                    latLng: [-25.0304388, 115.2092761],
                    name: "Sweden",
                    style: {
                        fill: Palette.light.electricBlue,
                        borderWidth: 1,
                        borderColor: "white",
                        strokeOpacity: 0
                    },
                },
            ]}
            zoomOnScroll = {false}
            zoomMax = {12}
            zoomMin = {1}
            zoomAnimate = {true}
            zoomStep = {1.5}
            regionStyle = {{
                initial: {
                    fill: mapColor || Palette.light.beige,
                    fillOpacity: 1,
                    fontFamilt: "Outfit",
                    strokeWidth: 0,
                    strokeOpacity: 0
                },

                hover: {
                    fillOpacity: 0.7,
                    cursor: "pointer",
                    fill: Palette.light.electricBlue,
                    stroke: "none"
                },

                selected: {
                    fill: Palette.light.electricBlue
                },

                selectedHover: {}
            }}

            regionLabelStyle = {{
                initial: {
                    fill: Palette.light.gray,
                    fontWeight: 500,
                    fontSize: "13px",
                    stroke: "none"
                },
                
                hover: {},
                selected: {},
                selectedHover: {}

            }}
        />
    );
};

export default CountryMap;