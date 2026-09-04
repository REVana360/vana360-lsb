# Contributing Guide

Vana360 fork changes must preserve the [Vana360 server profile](documentation/VANA360.md).
The upstream guidance below continues to apply
except where the profile requires a narrower content scope.

## Vana360 Commit Subjects

Use `type: imperative summary`: one ASCII line, 50 characters or fewer
including the type, with exactly one space after the colon. Do not use a body,
parentheses, or trailers. Preserve another contributor's credit with Git author
metadata rather than a commit-message trailer.

Choose one type from this fixed list:

- `core` C++ services, engine behavior, and shared libraries.
- `lua` script behavior and native Lua bindings.
- `sql` schema, migrations, and maintained profile data.
- `content` zones, NPCs, quests, mobs, drops, and items.
- `tools` build, audit, and repository tooling.
- `docs` documentation and agent guidance.
- `ci` hosted checks and automation.
- `chore` repository housekeeping with no single code area.
- `refactor` behavior-preserving changes spanning areas.
- `test` test fixtures and harnesses.

Prefer the owning area over the kind of change. `landmark`, `feat`, and `fix`
are not types on the maintained branch.

## Table of Contents

- [Contributing Guide](#contributing-guide)
  - [Table of Contents](#table-of-contents)
  - [Code of Conduct](#code-of-conduct)
  - [License](#license)
  - [General Guidelines](#general-guidelines)
  - [Technical Guidelines](#technical-guidelines)
  - [Workflow Guide](#workflow-guide)
  - [Issue Report Contributions](#issue-report-contributions)
  - [Pull Request Contributions](#pull-request-contributions)

## Code of Conduct

- Please read and understand our [Code of Conduct](CODE_OF_CONDUCT.md).

## License

- We operate under [GNU General Public License v3.0](LICENSE).
- We do not accept contributions that use other more restrictive licenses (such as AGPLv3).

## General Guidelines

- By contributing to this Vana360 fork, either through issues, pull requests, or discussions, you are expected to abide by the rules laid out here in this Contributing Guide.
- The maintained profile supports only the selected Vana360 Xbox 360 client.
  Other client versions and modified clients are out of scope.
- We do not support piracy of any kind. We encourage you to maintain an active retail subscription and support the game.

## Technical Guidelines

- For more specific guides on Git, GitHub, C++, Lua, SQL, Python, style, and
  other technical changes, read the tracked
  [Development Guide](docs/wiki/Development-Guide.md),
  [Development Landing Page](docs/wiki/Development.md), and
  [documentation index](docs/wiki/README.md).
- If you use an AI coding agent, or if you are one, read [AI Agents](docs/ai_agents/README.md) first. It sets out what we expect from AI-assisted contributions.
- Wiki source is tracked in [docs/wiki](docs/wiki/README.md). Edit the pages
  there and open a pull request to this repository.

## Workflow Guide

- It is **always** better to ask questions and ask for advice instead of investing a lot of time into work that we may end up asking you to rewrite or split up into smaller contributions.
- Cite your sources. This can be comments in your code or your commit messages. Pull Request descriptions and comments will get lost over time.
- If you're committing work on someone else's behalf, use git's `--author` argument so the commit retains their credit without a message trailer.
- Make your commit messages meaningful, or amend/rebase once you're ready to push.
- If you want to report or resolve an exploitable issue please try and get in contact with staff privately. Staff are pretty easy to find across different Discords or by the emails their commits are attributed with. This software is used by many live servers with active players, and we want to distribute fixes for exploits in a responsible and private fashion before they're published to the public.

## Issue Report Contributions

- Unimplemented feature requests must be _retail behavior_, and adequately cover everything about that feature which is missing.
- Fill out the templated checkboxes that are preloaded in the issue body. These allow us to diagnose your issue as efficiently as possible, and confirm that you've searched for duplicate issues or recent fixes.

## Pull Request Contributions

All contributions must be made through pull requests to
`REVana360/vana360-lsb`. We don't take fixes from Discord to apply ourselves.
If you need help making a pull request, GitHub provides a contribution guide.

We prefer submitting early and often, over monolithic and once. If you're implementing a complex feature, please try to submit PRs as you get each smaller functional aspect working (use your best judgment on what counts as a useful PR). This way we can help make sure you're on the right track before you sink a lot of time into implementations we might want done in a different way.

Please try to leave your PR alone after submission, unless it's to fix bugs you've noticed, or if we've requested changes. If you're still pushing commits after opening the PR, it makes it hard for reviewers to know when you're "finished" and if it's "safe" to begin their reviews. If you do want to push early for reviews of your in-progress work, you can open your PR as a "draft".

After a pull request is made, if a staff member leaves feedback for you to change, you must either fix or address it for your pull request to be merged.

If you do not fill the checkboxes confirming that you've read the supporting documentation, and that you've tested your code - your PR will not be reviewed.
