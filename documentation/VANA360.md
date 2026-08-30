# Vana360 server profile

`vana360-lsb` is the maintained project branch. `base` is a fast-forward-only
mirror of `upstream/base`.

The project branch targets the selected Vana360 Xbox 360 client with a
level-75 profile through the July 21, 2009 update. It keeps current engine
correctness and security work. Later gameplay content, client assumptions, and
packet forms are removed only through dependency-audited pruning.
Retail client files and private runtime evidence never enter this repository.

## Content policy

The selected client assets, official update records, and repeatable runtime
tests jointly determine the supported boundary. A file's commit date is not a
content classification: modern fixes to shared engine code remain eligible.

The profile enables ACP and AMK and marks ASA and later content disabled. The
July 9 executable timestamp identifies the selected binary build; the July 21
update is the gameplay cutoff. Later data physically present on the disc does
not expand that boundary.

Content removal proceeds from an explicit inventory and dependency audit.
Settings establish the initial profile, but they are not accepted as proof
that later content is unreachable. SQL rows, zones, instances, missions,
quests, global scripts, items, skills, packet writers, and dynamic loaders each
require a tested disposition before destructive pruning.

## Module and database profile

July 2009 behavior is maintained directly in canonical scripts, data, and SQL.
The tracked `modules/init.txt` enables no project modules in a clean checkout.
The generic module framework remains available for local operator extensions,
but those modules are not part of the maintained Vana360 profile.

`dbtool` applies the canonical schema and data during database setup. No
separate era SQL layer is required.

## Accepting upstream changes

1. Fetch `upstream` and identify candidate engine, safety, build, and tooling
   changes independently from new retail content.
2. Integrate accepted changes on a disposable branch from the chosen upstream
   commit.
3. Reconstruct the Vana360 delta as coherent landmark commits. Do not merge
   `base` or the previous maintained branch into the candidate.
4. Review the complete diff and every added or restored content surface.
5. Build the server, create a fresh database, and run upstream and Vana360
   checks.
6. Validate the pinned title and private asset snapshot before advancing the
   maintained reference.

Do not place project commits on `base`. Vana360 pins an exact project commit;
the maintained reference moves only after its consumers are validated.
