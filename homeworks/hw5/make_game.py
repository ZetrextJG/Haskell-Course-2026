from xml.etree.ElementTree import Element, SubElement, tostring
from xml.dom import minidom

from route import cities, routes, core_cities, events

# -------------------------
# BUILD KML
# -------------------------
kml = Element("kml", xmlns="http://www.opengis.net/kml/2.2")
doc = SubElement(kml, "Document")

# --- Add cities ---
for name, (coutry, (lon, lat)) in cities.items():
    pm = SubElement(doc, "Placemark")
    SubElement(pm, "name").text = name
    point = SubElement(pm, "Point")
    SubElement(point, "coordinates").text = f"{lon},{lat},0"


# --- Add routes ---
for route_name, path in routes.items():
    pm = SubElement(doc, "Placemark")
    SubElement(pm, "name").text = route_name

    line = SubElement(pm, "LineString")
    SubElement(line, "tessellate").text = "1"

    coords = []
    for city in path:
        lon, lat = cities[city][1]
        coords.append(f"{lon},{lat},0")

    SubElement(line, "coordinates").text = " ".join(coords)


# -------------------------
# OUTPUT FILE
# -------------------------
xml_str = minidom.parseString(tostring(kml)).toprettyxml()

with open("map.kml", "w", encoding="utf-8") as f:
    f.write(xml_str)

print("KML generated: map.kml")

print("Converting routes to haskell: Route.hs")
with open("Routes.hs", "w", encoding="utf-8") as f:
    f.writelines([
        "module Routes where\n",
        "getRoutes :: String -> [[String]]\n",
    ])

    for city in core_cities[:-1]:
        current_routes = []
        for route_name, route_cities in routes.items():
            first_city: str = route_cities[0]
            rest: list[str] = route_cities[1:]
            if first_city == city:
                current_routes.append(rest)

        routes_string = ", ".join([
            "[ " + ", ".join([f'"{rcity}"' for rcity in route]) + " ]"
            for route in current_routes 
        ])
        f.write(f'getRoutes "{city}" = [ {routes_string} ]\n')

print("Converting events to haskell: Events.hs")
with open("Events.hs", "w", encoding="utf-8") as f:
    f.writelines([
        "module Events where\n",
        "-- Name of the city -> Alternative name of the  \n",
        "tellEvent :: String -> Maybe String\n",
        "-- Name of the city, Roll -> (Text, Point Difference, Energy Difference)\n",
        "resolveEvent :: String -> Int -> (String, Int, Int)\n",
    ])
    f.write("\n")

    for city, event_metadata in events.items():
        event_name: str = event_metadata["name"]
        event_type: str = event_metadata["type"]
        f.write(f'tellEvent "{city}" = Just "{event_name} ({event_type})" \n')
    f.write('tellEvent _ = Nothing \n')

    f.write("\n")

    for city, event_metadata in events.items():
        for roll, outcome in event_metadata["outcomes"].items():
            text = outcome["text"]
            pts = outcome["pts"]
            nrg = outcome["nrg"]
            f.write(f'resolveEvent "{city}" {roll} = ("{text}", {pts}, {nrg}) \n')

print("Game generation done")
