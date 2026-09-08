Migrating Database
========================

This folder contains scripts to migrate your database data to a newer format.
For example the spells column in the chars table has been separated into
a new table, so a migration script has been created to do this for you.

## Running Migrations

From the repository root, run `python tools/dbtool.py update`.

This will run all outstanding migrations and skip migrations that have already
run. Migrations can change or remove persisted data, so create a backup before
running `python dbtool.py migrate` directly. The normal `update` command offers
the backup before it runs migrations.

Migration 065 removes the Unity Trust and Assist data retired by the July 2009
profile. It also retires the Unity shirts (25734-25744) and Eminent quivers
(6269-6271) from active SQL definitions. Existing ownership of those items is
removed from inventory, equipment sets, lockstyle, delivery, and active auction
listings; the searchable auction index is reconciled as well. Unity shirt bits
stored on Porter Slip 02 are cleared while later slip positions stay stable.
Sold auction history and audit tables are retained because they do not own an
item. Fresh SQL imports already omit the retired definitions, while the
migration detects legacy definitions and persisted ownership when upgrading an
existing database.
