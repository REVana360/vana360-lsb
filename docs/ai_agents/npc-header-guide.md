# NPC Script Header Guide

This guide explains how to format the header for NPC script files in LandSandBoat, and how to locate the required information.

## Header Format

Every NPC script should begin with a standardized header. This header provides the zone name, zone ID, NPC name, and the NPC's spawn position (as a `!pos` command).

```lua
-----------------------------------
-- Area: Windurst Walls (239)
--  NPC: Ambrosius
-- !pos 65.175 -2.499 -63.231 239
-----------------------------------
```

### Components

1.  **Area**: The name of the zone followed by its Zone ID in parentheses.
2.  **NPC**: The name of the NPC.
3.  **!pos**: The X, Y, Z coordinates, followed by the Zone ID. This matches the format used by the in-game `!pos` command.

## Finding the Information

### 1. Zone Name and ID

*   **Zone Name**: Usually matches the name of the folder containing the script (e.g., `scripts/zones/Windurst_Walls/`).
*   **Zone ID**: Can be found in `data/enums/zone.yaml`, the source for the generated `scripts/enum/zone.codegen.lua`. Search for the zone's key (e.g., `windurst_walls`) to find its numeric ID.

### 2. NPC Name and Entity ID

*   **NPC Name**: Use the `display_name` in the zone's `data/zones/<zone>/npcs.yaml` file. This is usually the name players see in-game.
*   **Entity ID**: Use the numeric key for the NPC record in that same file.

### 3. Finding Position (X, Y, Z) in zone data

If you don't have the coordinates from an in-game capture or a retail dump, find them in the per-zone YAML:

1.  Open `data/zones/<zone>/npcs.yaml`.
2.  Search for the NPC's `script` or `display_name`.
3.  The `at` value stores X, Y, Z, and direction. Append the numeric zone ID from `data/enums/zone.yaml` to form the `!pos` command.

Example YAML entry:
```yaml
17756197:
  script: Ambrosius
  display_name: Ambrosius
  at: [65.175, -2.499, -63.231, 76]
```
In this example, the header position is `!pos 65.175 -2.499 -63.231 239`; `76` is the NPC's direction, while `239` is Windurst Walls' zone ID.

## Maintaining the Notes Section

If a script requires additional context or documentation, a "Notes" section can be included within the header block.

### Existing Notes
If a script already has a notes section, **do not remove it**. Maintain the notes and update them if your changes alter the NPC's behavior or purpose.

### Formatting Notes
Notes should be placed within the header block, usually before the `!pos` command.

```lua
-----------------------------------
-- Area: Windurst Walls (239)
--  NPC: Ambrosius
-- Notes: This NPC is part of the "Crying Over Onions" quest.
-- !pos 65.175 -2.499 -63.231 239
-----------------------------------
```
