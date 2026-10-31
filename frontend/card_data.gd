class_name CardData
extends RefCounted
## Static definitions for the six Memory Cards (blueprint section 4).
## Placeholder content only: each tile names the phase that wires it up.
## Original labels throughout - era names and descriptive service names,
## no console branding, glyphs, or artwork (docs/02_IP-Hygiene-Rules.md).

static func cards() -> Array:
	return [
		{
			"id": "retro",
			"title": "Retro",
			"subtitle": "Emulated systems",
			"accent": Color("#6dd3ff"),
			"phase": "Phase 3",
			"tiles": ["8-bit Era", "16-bit Era", "32/64-bit Era", "128-bit Era", "HD Era", "Favorites", "Recently Played", "Search"],
		},
		{
			"id": "cloud",
			"title": "Cloud",
			"subtitle": "Streaming services",
			"accent": Color("#ff7ad9"),
			"phase": "Phase 4",
			"tiles": ["GeForce NOW", "Xbox Cloud", "Amazon Luna", "Boosteroid"],
		},
		{
			"id": "media",
			"title": "Media",
			"subtitle": "Watch and listen",
			"accent": Color("#ffd166"),
			"phase": "Phase 5",
			"tiles": ["Channel82 TV", "Rumble", "YouTube", "Local Media"],
		},
		{
			"id": "creator",
			"title": "Creator",
			"subtitle": "Stream toolkit",
			"accent": Color("#69db7c"),
			"phase": "Phase 5",
			"tiles": ["OBS Studio", "Discord", "Stream Tools", "Quick Launch"],
		},
		{
			"id": "library",
			"title": "Library",
			"subtitle": "Native games",
			"accent": Color("#4dabf7"),
			"phase": "Phase 5",
			"tiles": ["Steam", "Native Games", "Veilwalkers (Soon)"],
		},
		{
			"id": "system",
			"title": "System",
			"subtitle": "Settings and about",
			"accent": Color("#adb5bd"),
			"phase": "Phase 5",
			"tiles": ["Settings", "Themes", "Updates", "About", "Power"],
		},
	]
