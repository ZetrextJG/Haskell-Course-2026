# -------------------------
# NODES (ALL CITIES)
# Format: "City": ("Country", (Longitude, Latitude))
# -------------------------
cities = {
    # South America
    "Punta Arenas": ("Chile", (-70.907705, -53.1633778)),
    "Buenos Aires": ("Argentina", (-58.3816, -34.6037)),
    "Cordoba": ("Argentina", (-64.1888, -31.4201)),
    "Puerto Montt": ("Chile", (-72.9396, -41.4693)),
    "Santiago": ("Chile", (-70.6483, -33.4569)),
    "Antofagasta": ("Chile", (-70.4000, -23.6500)),
    "Lima": ("Peru", (-77.0428, -12.0464)),
    "La Paz": ("Bolivia", (-68.1193, -16.4897)),
    "Quito": ("Ecuador", (-78.4678, -0.1807)),
    "Cali": ("Colombia", (-76.5320, 3.4516)),
    "Medellín": ("Colombia", (-75.5658153, 6.2476376)),

    # Central & North America
    "Panama City": ("Panama", (-79.5198696, 8.9823792)),
    "Mexico City": ("Mexico", (-99.1013498, 19.2464696)),
    "Los Angeles": ("USA", (-118.242643, 34.0549076)),
    "Denver": ("USA", (-104.990251, 39.7392358)),
    "Dallas": ("USA", (-96.7969879, 32.7766642)),
    "Saint Louis": ("USA", (-90.1982439, 38.627428)),
    "Chicago": ("USA", (-87.6323879, 41.88325)),
    "New York": ("USA", (-74.0059728, 40.7127753)),

    # Canada & Alaska
    "Ottawa": ("Canada", (-75.7003397, 45.4200572)),
    "Manitoba": ("Canada", (-98.8138763, 53.7608608)),
    "Saskatchewan": ("Canada", (-106.4508639, 52.9399159)),
    "Fort Nelson": ("Canada", (-122.6900, 58.8053)),
    "Whitehorse": ("Canada", (-135.0568, 60.7212)),
    "Yukon": ("Canada", (-135.0, 64.2823274)),
    "Fairbanks": ("USA", (-147.7199756, 64.8400511)),
    "Unalakleet": ("USA", (-160.7925128, 63.8765975)),

    # Siberia / Asia core
    "Uelen": ("Russia", (-169.8223184, 66.1611863)),
    "Yakutsk": ("Russia", (129.7422193, 62.0396912)),
    "Ulaanbaatar": ("Mongolia", (106.9155007, 47.9220509)),

    # Central Asia / Caucasus
    "Aktau": ("Kazakhstan", (51.2120512, 43.671863)),
    "Baku": ("Azerbaijan", (49.8671, 40.4093)),
    "Ashgabat": ("Turkmenistan", (58.3833, 37.9601)),
    "Tehran": ("Iran", (51.3890, 35.6892)),
    "Tbilisi": ("Georgia", (44.8015168, 41.6938026)),

    # Europe
    "Istanbul": ("Turkey", (28.9783589, 41.0082376)),
    "Budapest": ("Hungary", (19.040235, 47.497912)),
    "Vienna": ("Austria", (16.3738, 48.2082)),
    "Berlin": ("Germany", (13.4050, 52.5200)),
    "Warsaw": ("Poland", (21.0122, 52.2297)),
    "Venice": ("Italy", (12.3155, 45.4408)),
    "Monaco": ("Monaco", (7.4246, 43.7384)),
    "Paris": ("France", (2.3513765, 48.8575475)),
    "Kingston upon Hull": ("UK", (-0.3273025, 53.7674909))
}

core_cities = [
    "Punta Arenas",
    "Lima",
    "Mexico City",
    "Chicago",
    "Yukon",
    "Aktau",
    "Budapest",
    "Paris",
    "Kingston upon Hull"
]

routes = {
    # -------------------------
    # CORE 1: Punta Arenas -> CORE 2: Lima
    # -------------------------
    "punta_arenas_to_lima_coastal": [
        "Punta Arenas",
        "Puerto Montt",
        "Santiago",
        "Antofagasta",
        "Lima"
    ],
    "punta_arenas_to_lima_andes": [
        "Punta Arenas",
        "Buenos Aires",
        "Cordoba",
        "La Paz",
        "Lima"
    ],

    # -------------------------
    # CORE 2: Lima -> CORE 3: Mexico City 
    # -------------------------
    "lima_to_los_angeles_main": [
        "Lima",
        "Quito",
        "Cali",
        "Medellín",
        "Panama City",
        "Mexico City",
    ],

    # -------------------------
    # CORE 3: Mexico City -> CORE 4: Chicago
    # -------------------------
    "mexico_city_to_chicago_direct": [
        "Mexico City",
        "Los Angeles",
        "Denver",
        "Chicago"
    ],
    "mexico_city_to_chicago_south": [
        "Mexico City",
        "Dallas",
        "Saint Louis",
        "Chicago"
    ],

    # -------------------------
    # CORE 4: Chicago -> CORE 5: Yukon
    # -------------------------
    "chicago_to_yukon_prairie": [
        "Chicago",
        "Saskatchewan",
        "Yukon"
    ],
    "chicago_to_yukon_east": [
        "Chicago",
        "New York",
        "Ottawa",
        "Manitoba",
        "Yukon"
    ],
    "chicago_to_yukon_arctic": [
        "Chicago",
        "Saskatchewan",
        "Fort Nelson",
        "Whitehorse",
        "Yukon"
    ],

    # -------------------------
    # CORE 5: Yukon -> CORE 6: Aktau
    # -------------------------
    "yukon_to_aktau_main": [
        "Yukon",
        "Fairbanks",
        "Unalakleet",
        "Uelen",
        "Yakutsk",
        "Ulaanbaatar",
        "Aktau"
    ],

    # -------------------------
    # CORE 6: Aktau -> CORE 7: Budapest
    # -------------------------
    "aktau_to_budapest_caucasus": [
        "Aktau",
        "Baku",
        "Tbilisi",
        "Istanbul",
        "Budapest"
    ],
    "aktau_to_budapest_persia": [
        "Aktau",
        "Ashgabat",
        "Tehran",
        "Budapest"
    ],

    # -------------------------
    # CORE 7: Budapest -> CORE 8: Paris
    # -------------------------
    "budapest_to_paris_central": [
        "Budapest",
        "Vienna",
        "Berlin",
        "Paris"
    ],
    "budapest_to_paris_north": [
        "Budapest",
        "Warsaw",
        "Berlin",
        "Paris"
    ],
    "budapest_to_paris_south": [
        "Budapest",
        "Venice",
        "Monaco",
        "Paris"
    ],

    # -------------------------
    # CORE 8: Paris -> CORE 9: Kingston upon Hull
    # -------------------------
    "paris_to_kingston_main": [
        "Paris",
        "Kingston upon Hull"
    ]
}

# -------------------------
# MASTER EVENT LOGIC (MASSIVE EXPANSION)
# Format: "City": { 
#     "name": String, 
#     "type": "obstacle" | "treasure" | "gamble" | "bureaucracy" | "milestone",
#     "outcomes": { Roll (1-6): {"text": String, "pts": Int, "nrg": Int} }
# }
# -------------------------

events = {
    # ==========================================
    # SOUTH AMERICA: The Southern Reaches
    # ==========================================
    "Punta Arenas": {
        "name": "The First Step", "type": "milestone",
        "outcomes": { i: {"text": "The expedition begins with high spirits and local fanfare. The Core is stable.", "pts": 2, "nrg": 0} for i in range(1, 7) }
    },
    "Puerto Montt": {
        "name": "Patagonian Fjords", "type": "obstacle",
        "outcomes": {
            1: {"text": "A massive storm floods your camp. Gear is waterlogged.", "pts": -2, "nrg": -3},
            2: {"text": "Relentless freezing rain slows progress.", "pts": 0, "nrg": -2},
            3: {"text": "Navigating slippery coastal rocks.", "pts": 1, "nrg": -1},
            4: {"text": "Navigating slippery coastal rocks.", "pts": 1, "nrg": -1},
            5: {"text": "You catch a ride on a local fishing boat, saving time.", "pts": 2, "nrg": 0},
            6: {"text": "Clear skies! The coastal leylines resonate strongly.", "pts": 5, "nrg": 0}
        }
    },
    "Buenos Aires": {
        "name": "Tango of the Leylines", "type": "treasure",
        "outcomes": {
            1: {"text": "Overwhelmed by the city. A pickpocket steals some supplies.", "pts": -2, "nrg": -1},
            2: {"text": "Lost in the sprawling urban grid.", "pts": 0, "nrg": -1},
            3: {"text": "A brief rest in a cafe recharges your suit slightly.", "pts": 2, "nrg": 1},
            4: {"text": "A brief rest in a cafe recharges your suit slightly.", "pts": 2, "nrg": 1},
            5: {"text": "You discover a hidden Aether cache in Recoleta Cemetery.", "pts": 5, "nrg": 1},
            6: {"text": "Local tech-smugglers upgrade your suit's efficiency!", "pts": 8, "nrg": 2}
        }
    },
    "Santiago": {
        "name": "Urban Sprawl", "type": "bureaucracy",
        "outcomes": {
            1: {"text": "Caught in a massive protest. The Core absorbs the chaotic energy.", "pts": -4, "nrg": -2},
            2: {"text": "Police checkpoints delay your exit from the city.", "pts": -1, "nrg": -2},
            3: {"text": "Standard city navigation.", "pts": 1, "nrg": -1},
            4: {"text": "Standard city navigation.", "pts": 1, "nrg": -1},
            5: {"text": "You find an abandoned subway tunnel to bypass traffic.", "pts": 3, "nrg": 0},
            6: {"text": "A local Aether-scholar grants you access to an underground tram.", "pts": 6, "nrg": 1}
        }
    },
    "La Paz": {
        "name": "The Breathless Peak", "type": "gamble",
        "outcomes": {
            1: {"text": "Severe altitude sickness. The thin air wreaks havoc on the Core's cooling system.", "pts": -6, "nrg": -4},
            2: {"text": "Hypoxia sets in. Every step is agony.", "pts": -2, "nrg": -2},
            3: {"text": "A slow, grueling climb through the Andes.", "pts": 2, "nrg": -1},
            4: {"text": "A slow, grueling climb through the Andes.", "pts": 2, "nrg": -1},
            5: {"text": "The high altitude provides zero Aether interference! Massive charge.", "pts": 8, "nrg": -1},
            6: {"text": "Perfect resonance at the top of the world. A legendary climb.", "pts": 12, "nrg": 0}
        }
    },
    "Antofagasta": {
        "name": "Atacama Sun", "type": "obstacle",
        "outcomes": {
            1: {"text": "Severe dehydration. You lose your way in the salt flats.", "pts": -3, "nrg": -3},
            2: {"text": "The heat is unbearable, draining your reserves.", "pts": -1, "nrg": -2},
            3: {"text": "A grueling but standard desert crossing.", "pts": 0, "nrg": -1},
            4: {"text": "A grueling but standard desert crossing.", "pts": 0, "nrg": -1},
            5: {"text": "You find an old mining road, speeding up the trek.", "pts": 2, "nrg": 0},
            6: {"text": "A local trucker shares water and historical lore.", "pts": 4, "nrg": 0}
        }
    },
    "Lima": {
        "name": "The Incan Network", "type": "treasure",
        "outcomes": {
            1: {"text": "Dense coastal fog shorts out your navigation.", "pts": -2, "nrg": -1},
            2: {"text": "Heavy traffic on the Pan-American highway.", "pts": 0, "nrg": -1},
            3: {"text": "You trace an ancient Nazca line, finding mild resonance.", "pts": 3, "nrg": 0},
            4: {"text": "You trace an ancient Nazca line, finding mild resonance.", "pts": 3, "nrg": 0},
            5: {"text": "Hidden ruins provide a massive Aether boost.", "pts": 6, "nrg": 0},
            6: {"text": "Perfect alignment with ancient leylines. The Core sings.", "pts": 10, "nrg": 1}
        }
    },
    "Medellín": {
        "name": "Mountain Cartels", "type": "gamble",
        "outcomes": {
            1: {"text": "Intercepted by local militias. You must burn energy to escape.", "pts": -5, "nrg": -3},
            2: {"text": "Forced to take a massive detour through dense jungle.", "pts": -2, "nrg": -2},
            3: {"text": "Navigating steep mountain passes.", "pts": 1, "nrg": -1},
            4: {"text": "Navigating steep mountain passes.", "pts": 1, "nrg": -1},
            5: {"text": "Friendly locals guide you through safe mountain trails.", "pts": 5, "nrg": 0},
            6: {"text": "You hitch a ride on an aerial tramway! Perfect views, pure Aether.", "pts": 9, "nrg": 1}
        }
    },

    # ==========================================
    # CENTRAL & NORTH AMERICA: The Concrete Jungle
    # ==========================================
    "Panama City": {
        "name": "The Grand Canal", "type": "bureaucracy",
        "outcomes": {
            1: {"text": "Detained by canal security. They suspect the Core is a weapon.", "pts": -4, "nrg": -3},
            2: {"text": "Endless paperwork to cross the canal zone.", "pts": -1, "nrg": -2},
            3: {"text": "A slow, sweaty day waiting for ferries.", "pts": 1, "nrg": -1},
            4: {"text": "A slow, sweaty day waiting for ferries.", "pts": 1, "nrg": -1},
            5: {"text": "You slip through alongside a massive cargo ship.", "pts": 4, "nrg": 0},
            6: {"text": "You bribe a tugboat captain for a fast, scenic crossing.", "pts": 6, "nrg": 1}
        }
    },
    "Mexico City": {
        "name": "The Sinking City", "type": "gamble",
        "outcomes": {
            1: {"text": "The city's unstable ground causes a micro-quake. The Core cracks!", "pts": -8, "nrg": -2},
            2: {"text": "Crushing population density slows you to a crawl.", "pts": -2, "nrg": -1},
            3: {"text": "Navigating the endless sprawl.", "pts": 2, "nrg": -1},
            4: {"text": "Navigating the endless sprawl.", "pts": 2, "nrg": -1},
            5: {"text": "You siphon Aether from the ruins of Tenochtitlan.", "pts": 7, "nrg": 0},
            6: {"text": "An underground archaeological team helps you recharge.", "pts": 10, "nrg": 2}
        }
    },
    "Los Angeles": {
        "name": "Media Circus", "type": "obstacle",
        "outcomes": {
            1: {"text": "Paparazzi swarm you. The flashes interfere with the Core.", "pts": -4, "nrg": -1},
            2: {"text": "Gridlock on the 405. The smog is choking.", "pts": -2, "nrg": -2},
            3: {"text": "A long, hot walk down endless boulevards.", "pts": 0, "nrg": -1},
            4: {"text": "A long, hot walk down endless boulevards.", "pts": 0, "nrg": -1},
            5: {"text": "A local influencer gives you a ride, saving energy.", "pts": 3, "nrg": 1},
            6: {"text": "You find an abandoned Hollywood set. Perfect quiet to recharge.", "pts": 6, "nrg": 2}
        }
    },
    "Denver": {
        "name": "Rocky Mountain High", "type": "obstacle",
        "outcomes": {
            1: {"text": "Caught in a freak blizzard at 10,000 feet.", "pts": -3, "nrg": -3},
            2: {"text": "The steep incline drains your suit's servos.", "pts": 0, "nrg": -2},
            3: {"text": "Steady climbing through thin air.", "pts": 2, "nrg": -1},
            4: {"text": "Steady climbing through thin air.", "pts": 2, "nrg": -1},
            5: {"text": "You find a ski resort with an industrial generator.", "pts": 4, "nrg": 1},
            6: {"text": "Clear mountain air! The Core resonates with the peaks.", "pts": 8, "nrg": 0}
        }
    },
    "Chicago": {
        "name": "The Windy City", "type": "obstacle",
        "outcomes": {
            1: {"text": "The 'Hawk' wind off Lake Michigan freezes your servos.", "pts": -2, "nrg": -3},
            2: {"text": "Bitter cold and industrial pollution.", "pts": -1, "nrg": -2},
            3: {"text": "Trudging through the urban grid.", "pts": 1, "nrg": -1},
            4: {"text": "Trudging through the urban grid.", "pts": 1, "nrg": -1},
            5: {"text": "You utilize the underground Pedway system.", "pts": 4, "nrg": 0},
            6: {"text": "You siphon massive residual Aether from the Willis Tower.", "pts": 7, "nrg": 1}
        }
    },
    "New York": {
        "name": "Wall Street Interference", "type": "gamble",
        "outcomes": {
            1: {"text": "Massive electromagnetic interference from the city grid wipes your data.", "pts": -7, "nrg": -2},
            2: {"text": "Lost in the concrete canyons.", "pts": -3, "nrg": -1},
            3: {"text": "The city that never sleeps keeps you moving.", "pts": 2, "nrg": -1},
            4: {"text": "The city that never sleeps keeps you moving.", "pts": 2, "nrg": -1},
            5: {"text": "Central Park provides a beautiful, natural resonance.", "pts": 6, "nrg": 0},
            6: {"text": "You plug into the city's main grid in secret. Overcharge!", "pts": 12, "nrg": 2}
        }
    },

    # ==========================================
    # CANADA & ALASKA: The Great White Silence
    # ==========================================
    "Saskatchewan": {
        "name": "The Endless Prairie", "type": "obstacle",
        "outcomes": {
            1: {"text": "A massive tornado forces you into a storm cellar. Delay.", "pts": -2, "nrg": -2},
            2: {"text": "Mind-numbing flatness takes a psychological toll.", "pts": -1, "nrg": -1},
            3: {"text": "Walking... just walking forever.", "pts": 1, "nrg": -1},
            4: {"text": "Walking... just walking forever.", "pts": 1, "nrg": -1},
            5: {"text": "A friendly farmer lets you charge up in his barn.", "pts": 3, "nrg": 1},
            6: {"text": "The open sky allows a direct, flawless Aether connection.", "pts": 6, "nrg": 0}
        }
    },
    "Yukon": {
        "name": "The Wild North", "type": "gamble",
        "outcomes": {
            1: {"text": "Stalked by a grizzly bear. You sprint for miles, burning the suit's power.", "pts": -3, "nrg": -4},
            2: {"text": "You fall through thin ice over a creek.", "pts": -1, "nrg": -3},
            3: {"text": "Absolute isolation. Just you and the wild.", "pts": 3, "nrg": -1},
            4: {"text": "Absolute isolation. Just you and the wild.", "pts": 3, "nrg": -1},
            5: {"text": "You find an abandoned gold-rush cabin with firewood.", "pts": 6, "nrg": 1},
            6: {"text": "The Aurora Borealis supercharges the Aetherium Core!", "pts": 12, "nrg": 2}
        }
    },
    "Fairbanks": {
        "name": "Alaskan Deep Freeze", "type": "obstacle",
        "outcomes": {
            1: {"text": "Caught in a whiteout blizzard. Frostbite sets in.", "pts": -2, "nrg": -3},
            2: {"text": "The cold thickens your suit's lubricants.", "pts": -1, "nrg": -2},
            3: {"text": "Trudging through deep, exhausting snow.", "pts": 1, "nrg": -1},
            4: {"text": "Trudging through deep, exhausting snow.", "pts": 1, "nrg": -1},
            5: {"text": "Clear skies allow for a beautiful, cold march.", "pts": 3, "nrg": 0},
            6: {"text": "You meet a bush pilot who drops supplies!", "pts": 5, "nrg": 2}
        }
    },

    # ==========================================
    # SIBERIA & ASIA: The Ultimate Test
    # ==========================================
    "Uelen": {
        "name": "The Bering Ice Bridge", "type": "gamble",
        "outcomes": {
            1: {"text": "CRACK. The ice gives way! You are plunged into the freezing Bering Sea.", "pts": -12, "nrg": -5},
            2: {"text": "Drifting ice floes push you miles off course.", "pts": -5, "nrg": -3},
            3: {"text": "Terrifying, slow progress over shifting ice plates.", "pts": 2, "nrg": -2},
            4: {"text": "Terrifying, slow progress over shifting ice plates.", "pts": 2, "nrg": -2},
            5: {"text": "Solid ice conditions allow you to make great time.", "pts": 8, "nrg": -1},
            6: {"text": "You successfully cross the Bering Strait on foot! Absolute legend!", "pts": 18, "nrg": 0}
        }
    },
    "Yakutsk": {
        "name": "The Road of Bones", "type": "obstacle",
        "outcomes": {
            1: {"text": "-50°C. The coldest city on earth shatters your external sensors.", "pts": -4, "nrg": -4},
            2: {"text": "Siberian wolves stalk your camp for days.", "pts": -1, "nrg": -2},
            3: {"text": "Endless taiga. Progress is a slow, freezing grind.", "pts": 1, "nrg": -1},
            4: {"text": "Endless taiga. Progress is a slow, freezing grind.", "pts": 1, "nrg": -1},
            5: {"text": "A local hunter shares warm food, vodka, and a fire.", "pts": 4, "nrg": 1},
            6: {"text": "You discover ancient mammoth tusks resonating with Aether.", "pts": 9, "nrg": 0}
        }
    },
    "Ulaanbaatar": {
        "name": "The Steppe Winds", "type": "treasure",
        "outcomes": {
            1: {"text": "A fierce Gobi dust storm damages the Core housing.", "pts": -3, "nrg": -2},
            2: {"text": "Lost in the vast, featureless plains.", "pts": 0, "nrg": -1},
            3: {"text": "A quiet night under the vast Mongolian sky.", "pts": 2, "nrg": 0},
            4: {"text": "A quiet night under the vast Mongolian sky.", "pts": 2, "nrg": 0},
            5: {"text": "Nomads invite you into their yurt. Deep cultural resonance.", "pts": 5, "nrg": 1},
            6: {"text": "You find a lost temple of Genghis Khan! Massive Aether surge.", "pts": 10, "nrg": 1}
        }
    },

    # ==========================================
    # CENTRAL ASIA & CAUCASUS: The Old Silk Road
    # ==========================================
    "Aktau": {
        "name": "Visa Revoked", "type": "bureaucracy",
        "outcomes": {
            1: {"text": "Border guards detain you. Visa revoked! Massive delay.", "pts": -6, "nrg": -3},
            2: {"text": "Held up at customs for days. Bribes required.", "pts": -2, "nrg": -2},
            3: {"text": "Heavy questioning, but they finally stamp your passport.", "pts": 1, "nrg": -1},
            4: {"text": "Heavy questioning, but they finally stamp your passport.", "pts": 1, "nrg": -1},
            5: {"text": "The border guard recognizes you from the news and waves you through.", "pts": 4, "nrg": 0},
            6: {"text": "Granted diplomatic fast-track by a friendly official.", "pts": 7, "nrg": 1}
        }
    },
    "Baku": {
        "name": "The Eternal Fires", "type": "treasure",
        "outcomes": {
            1: {"text": "Noxious fumes from the oil fields sicken you.", "pts": -2, "nrg": -1},
            2: {"text": "Harsh winds off the Caspian Sea.", "pts": 0, "nrg": -1},
            3: {"text": "Walking past the ancient fire temples.", "pts": 3, "nrg": 0},
            4: {"text": "Walking past the ancient fire temples.", "pts": 3, "nrg": 0},
            5: {"text": "The natural gas fires supercharge the Aetherium Core.", "pts": 7, "nrg": 1},
            6: {"text": "Perfect resonance at Yanar Dag (Burning Mountain).", "pts": 11, "nrg": 2}
        }
    },
    "Tehran": {
        "name": "Persian Leylines", "type": "gamble",
        "outcomes": {
            1: {"text": "Arrested on suspicion of espionage. You have to break out.", "pts": -8, "nrg": -3},
            2: {"text": "Forced to navigate the Zagros mountains to avoid patrols.", "pts": -2, "nrg": -2},
            3: {"text": "Moving quietly through the ancient streets.", "pts": 2, "nrg": -1},
            4: {"text": "Moving quietly through the ancient streets.", "pts": 2, "nrg": -1},
            5: {"text": "You find an underground bazaar to repair your suit.", "pts": 6, "nrg": 1},
            6: {"text": "You tap into the ancient Aether of the Persian Empire!", "pts": 14, "nrg": 0}
        }
    },

    # ==========================================
    # EUROPE: The Final Stretch
    # ==========================================
    "Istanbul": {
        "name": "Gateway to Europe", "type": "treasure",
        "outcomes": {
            1: {"text": "Overwhelmed by the crowds in the Grand Bazaar. Pickpocketed.", "pts": -2, "nrg": -1},
            2: {"text": "A quiet crossing of the Bosphorus.", "pts": 1, "nrg": 0},
            3: {"text": "Taking in the history of two continents.", "pts": 3, "nrg": 0},
            4: {"text": "Taking in the history of two continents.", "pts": 3, "nrg": 0},
            5: {"text": "A feast of Turkish delight and strong coffee restores you.", "pts": 5, "nrg": 2},
            6: {"text": "You find an ancient Byzantine relic. The Core absorbs it.", "pts": 9, "nrg": 1}
        }
    },
    "Budapest": {
        "name": "The Thermal Baths", "type": "treasure",
        "outcomes": {
            1: {"text": "The local water shorts out a minor suit system.", "pts": -1, "nrg": -1},
            2: {"text": "A rainy, gloomy march along the Danube.", "pts": 1, "nrg": 0},
            3: {"text": "Enjoying the architecture of the dual city.", "pts": 3, "nrg": 1},
            4: {"text": "Enjoying the architecture of the dual city.", "pts": 3, "nrg": 1},
            5: {"text": "Soaking in the Széchenyi baths deeply restores your Energy.", "pts": 4, "nrg": 3},
            6: {"text": "The geothermal energy beneath the city overcharges your suit!", "pts": 7, "nrg": 4}
        }
    },
    "Warsaw": {
        "name": "The Rebuilt City", "type": "treasure",
        "outcomes": {
            1: {"text": "A bitter winter storm sweeps the plains of Masovia.", "pts": -2, "nrg": -2},
            2: {"text": "Slow progress through the outskirts.", "pts": 0, "nrg": -1},
            3: {"text": "The resilience of the city inspires you.", "pts": 2, "nrg": 0},
            4: {"text": "The resilience of the city inspires you.", "pts": 2, "nrg": 0},
            5: {"text": "You find an old resistance tunnel, bypassing traffic.", "pts": 5, "nrg": 1},
            6: {"text": "You discover the 'Cyber-Hussar' Cache! Massive tech upgrade.", "pts": 10, "nrg": 2}
        }
    },
    "Venice": {
        "name": "The Sinking Canals", "type": "obstacle",
        "outcomes": {
            1: {"text": "You slip into a canal. The saltwater heavily damages the Core.", "pts": -5, "nrg": -3},
            2: {"text": "Navigating the maze of flooded streets.", "pts": -1, "nrg": -2},
            3: {"text": "Taking a gondola saves some walking.", "pts": 2, "nrg": 0},
            4: {"text": "Taking a gondola saves some walking.", "pts": 2, "nrg": 0},
            5: {"text": "You discover a hidden Masonic Aether-lodge.", "pts": 6, "nrg": 0},
            6: {"text": "The ancient glassblowers of Murano repair your Core housing!", "pts": 8, "nrg": 2}
        }
    },
    "Monaco": {
        "name": "The High Roller", "type": "gamble",
        "outcomes": {
            1: {"text": "You are barred from the casino. Security chases you out.", "pts": -4, "nrg": -2},
            2: {"text": "You lose a bet to a wealthy oligarch. They take some Aether.", "pts": -5, "nrg": 0},
            3: {"text": "You blend in with the rich and famous.", "pts": 2, "nrg": 0},
            4: {"text": "You blend in with the rich and famous.", "pts": 2, "nrg": 0},
            5: {"text": "You win big at the roulette table! A wealthy backer helps you.", "pts": 8, "nrg": 2},
            6: {"text": "You bankrupt the casino's Aether reserves!", "pts": 15, "nrg": 1}
        }
    },
    "Paris": {
        "name": "The Catacombs", "type": "gamble",
        "outcomes": {
            1: {"text": "You get lost in the endless underground labyrinth of skulls.", "pts": -6, "nrg": -3},
            2: {"text": "The ambient dark Aether of the catacombs drains your points.", "pts": -3, "nrg": -1},
            3: {"text": "You navigate the city of light above ground.", "pts": 2, "nrg": -1},
            4: {"text": "You navigate the city of light above ground.", "pts": 2, "nrg": -1},
            5: {"text": "The Eiffel Tower acts as a massive Aether antenna! Recharge.", "pts": 7, "nrg": 1},
            6: {"text": "You find the heart of the Catacombs. Flawless historical resonance.", "pts": 12, "nrg": 0}
        }
    },
    "Kingston upon Hull": {
        "name": "The End of the Road", "type": "milestone",
        "outcomes": {
            i: {"text": "You touch the waters of your home port. The Aetherium Core is secured. The Goliath Expedition is complete.", "pts": 25, "nrg": 0} for i in range(1, 7)
        }
    },

    # ==========================================
    # SOUTH AMERICA (Missing Nodes)
    # ==========================================
    "Cordoba": {
        "name": "The Pampero Winds", "type": "obstacle",
        "outcomes": {
            1: {"text": "A sudden, violent squall washes away some of your gear.", "pts": -3, "nrg": -2},
            2: {"text": "Heavy headwinds in the foothills slow your progress.", "pts": -1, "nrg": -2},
            3: {"text": "Trekking steadily through the Sierras de Córdoba.", "pts": 1, "nrg": -1},
            4: {"text": "Trekking steadily through the Sierras de Córdoba.", "pts": 1, "nrg": -1},
            5: {"text": "An old Jesuit block provides shelter and a mild Aether resonance.", "pts": 4, "nrg": 0},
            6: {"text": "You uncover an intact colonial-era Aether-battery in the ruins!", "pts": 7, "nrg": 1}
        }
    },
    "Quito": {
        "name": "Equatorial Ascent", "type": "gamble",
        "outcomes": {
            1: {"text": "Altitude sickness combined with a volcanic tremor damages the Core.", "pts": -6, "nrg": -3},
            2: {"text": "Exhausting, breathless climb up the Andean slopes.", "pts": -2, "nrg": -2},
            3: {"text": "Moving steadily through the high-altitude capital.", "pts": 2, "nrg": -1},
            4: {"text": "Moving steadily through the high-altitude capital.", "pts": 2, "nrg": -1},
            5: {"text": "The exact equatorial alignment gives the Core a pure, clean charge.", "pts": 6, "nrg": 1},
            6: {"text": "You siphon raw thermal Aether directly from the Pichincha volcano!", "pts": 11, "nrg": 2}
        }
    }
}

