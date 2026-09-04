Tools
========================

## Database Tool
`python dbtool.py`  
`python dbtool.py backup` - creates a whole database backup in `../sql/backups/`  
`python dbtool.py backup lite` - creates a backup only of tables defined in settings  
`python dbtool.py update` - performs an express update with backup and migrations if necessary  
`python dbtool.py update full` - performs a full update with backup and migrations  
`python dbtool.py migrate` - checks and performs any needed migrations

This tool creates or connects to the database defined in `../settings/network.lua`. It 
allows the user to backup or restore the database, import any `custom.sql` 
stored in `../sql/backups/`, and import the latest SQL files provided by LandSandBoat 
Development. This tool also handles data migrations for character data.

## Price Checker
`python price_checker.py`

This tool checks NPC and guild shop prices to see if anything is being sold for less than the buyback price.

## Festive Moogle Tool
`python give_items.py`

This tool is used to distribute the following items:  
- Nomad Cap  
- Moogle Cap  
- Moogle Rod  
- Harpsichord  
- Stuffed Chocobo  
- Tidal Talisman  
- Destrier Beret  
- Chocobo Shirt  

## Announce
`python announce.py "<your message>"`

Sends `<your message>` to every character, in every zone, on every map process.  

## Entity ID Audit

`python tools/client/entity_id_audit.py <catalog.json> <zone-id> <zone-dir> --out <report.json>`

Compares one zone from Tinkerer's private `export-zone-entities` catalog with
the maintained NPC and mob YAML. The report identifies direct matches,
same-index mismatches, unique-name move candidates, ambiguous names, and
one-sided targets. Candidate moves are evidence for review, not an authorized
rewrite: duplicate names, unnamed entities, slot members, Lua references, and
ordering assumptions require a separate dependency audit. Unplaced mob
reservations are reported separately and excluded from name matching.

## Key Item ID Audit

`python tools/client/key_item_audit.py <key-items.json> scripts/enum/key_item.lua --out <report.json>`

Compares the global July key-item catalog with the canonical server enum. The
report preserves ID-zero DAT headings as structural metadata and classifies
exact matches, same-ID name conflicts, unique-name shift candidates,
client-only IDs, and server-only IDs. It never rewrites the enum.

## Item ID Audit

`python tools/client/item_audit.py <items.json> sql/item_basic.sql --out <report.json>`

Compares all six July item resources with the canonical runtime item table.
The report keeps empty and dot-named DAT slots as placeholders, separates
server items occupying those slots from IDs outside the catalog, and classifies
same-ID name, category, and stack-size differences plus unique-name shift
candidates. Currency stack size is excluded because the DAT field, SQL field,
and unlimited runtime currency stack have different meanings. The SQL loader
expects the repository's canonical one-row-per-`INSERT` form. It never rewrites
SQL.

Setup
========================

## Installing Python
`python3 --version` or `py -3 --version`

**This requires Python 3 and pip.**  
**Website:** https://www.python.org/downloads/  
Download the latest version from the website or check your package manager.

## Installing Dependencies
`pip install -r requirements.txt`

**MariaDB** - MariaDB is required to interact with the database.  
**GitPython** - GitPython is required to compare database versions.  
**PyYAML** - PyYAML is required to read/write settings.  
**Colorama** - Colorama is required to make colored terminal text.  
**zmq** - ZeroMQ is required for sending messages to the server.  
**Pylint** - Pylint is a static code analyser.  
**Black** - Black is a Python code formatter.  

## Other
`./install-systemd-service.sh` - Installs a systemd service for running the servers on Linux.  
`./run_clang_format.py` - Formats C++ code. Run from repo root.  
