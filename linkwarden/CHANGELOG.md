# Changelog

## [1.1.2](https://github.com/wittdennis/charts/compare/linkwarden-1.1.1...linkwarden-1.1.2) (2026-09-01)


### Bug Fixes

* **deps:** update ghcr.io/linkwarden/linkwarden docker tag to v2.16.2 ([adf64b7](https://github.com/wittdennis/charts/commit/adf64b7b9ec1b4dd1821a1e7195848dd3ab76c9c))

## [1.1.1](https://github.com/wittdennis/charts/compare/linkwarden-1.1.0...linkwarden-1.1.1) (2026-08-18)


### Bug Fixes

* **deps:** update ghcr.io/linkwarden/linkwarden docker tag to v2.16.1 ([47a06b8](https://github.com/wittdennis/charts/commit/47a06b812d920f3d7beadcb3acbc967ce1bf0d4f))

## [1.1.0](https://github.com/wittdennis/charts/compare/linkwarden-1.0.4...linkwarden-1.1.0) (2026-08-09)


### Features

* publish chart as oci artifact ([66c2ee4](https://github.com/wittdennis/charts/commit/66c2ee47a02dd44682cccca55bc53b4011108168))

## Changelog
All notable changes to this project will be documented in this file. See [conventional commits](https://www.conventionalcommits.org/) for commit guidelines.

- - -
## linkwarden-1.0.4 - 2026-07-30
#### Bug Fixes
- (**deps**) update ghcr.io/linkwarden/linkwarden docker tag to v2.16.0 - (24507fa) - wittdennis-renovate[bot]

- - -

## linkwarden-1.0.3 - 2026-07-20
#### Bug Fixes
- (**deps**) update ghcr.io/linkwarden/linkwarden docker tag to v2.15.1 - (6730038) - wittdennis-renovate[bot]
- (**linkwarden**) switch to official image - (c2d0a3d) - Dennis Witt

- - -

## linkwarden-1.0.2 - 2026-05-20
#### Bug Fixes
- (**linkwarden**) use correct main branch in chart urls - (ca9522d) - Dennis Witt

- - -

## linkwarden-1.0.1 - 2026-04-23
#### Bug Fixes
- (**deps**) update docker.io/denniswitt/linkwarden-rootless docker tag to v2.14.1 - (4144a41) - wittdennis-renovate[bot]
#### Miscellaneous Chores
- (**linkwarden**) switch to ghcr for container image - (bf62ebe) - Dennis Witt

- - -

## linkwarden-1.0.0 - 2026-03-27
#### Features
- (**linkwarden**) add startupProbe to handle slow app start - (23b89f9) - Dennis Witt

- - -

## linkwarden-0.3.1 - 2026-03-26
#### Bug Fixes
- (**deps**) update docker.io/denniswitt/linkwarden-rootless docker tag to v2.14.0 - (ddb393b) - wittdennis-renovate[bot]

- - -

## linkwarden-0.3.0 - 2026-03-16
#### Features
- (**ddb-proxy**) add route block for gateway api usage - (a36861e) - Dennis Witt
- (**foundry**) add route block for gateway api usage - (54f19a8) - Dennis Witt
- (**node-red**) add route block for gateway api usage - (c6c9e31) - Dennis Witt
#### Bug Fixes
- (**linkwarden**) adding filters to route would lead to invalid yaml - (f8665dd) - Dennis Witt

- - -

## linkwarden-0.2.0 - 2026-01-16
#### Features
- (**linkwarden**) add configuration options for authentik - (5062a51) - Dennis Witt
- (**linkwarden**) add configuration options for authentik - (81fac85) - Dennis Witt
- <span style="background-color: #d73a49; color: white; padding: 2px 6px; border-radius: 3px; font-weight: bold; font-size: 0.85em;">BREAKING</span>create new auth section for auth configurations - (b46a078) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.2.0-preview.1 - (ce7e6d6) - github-actions

- - -

## linkwarden-0.2.0-preview.1 - 2026-01-16
#### Features
- (**linkwarden**) add configuration options for authentik - (f12b88e) - Dennis Witt
- <span style="background-color: #d73a49; color: white; padding: 2px 6px; border-radius: 3px; font-weight: bold; font-size: 0.85em;">BREAKING</span>create new auth section for auth configurations - (0604413) - Dennis Witt

- - -

## linkwarden-0.1.0 - 2026-01-15
#### Features
- initial working linkwarden version - (86ea572) - Dennis Witt
#### Bug Fixes
- (**deps**) update ghcr.io/linkwarden/linkwarden docker tag to v2.13.5 - (c52f21c) - wittdennis-renovate[bot]
- (**deps**) update ghcr.io/linkwarden/linkwarden docker tag to v2.13.4 - (ff5636c) - wittdennis-renovate[bot]
- (**deps**) update ghcr.io/linkwarden/linkwarden docker tag to v2.13.3 - (7c2bdf2) - wittdennis-renovate[bot]

- - -

## linkwarden-0.1.0-preview.4 - 2026-01-15
#### Bug Fixes
- (**linkwarden**) use correct data dir - (5dce483) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.4 - (e9d5e0a) - github-actions

- - -

## linkwarden-0.1.0-preview.3 - 2026-01-15
#### Bug Fixes
- (**linkwarden**) quote values in configmap - (a334c4d) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.3 - (4a97b17) - github-actions

- - -

## linkwarden-0.1.0-preview.2 - 2026-01-15
#### Bug Fixes
- (**linkwarden**) correctly use required function - (64c6f2e) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.2 - (92f87fd) - github-actions

- - -

## linkwarden-0.1.0-preview.1 - 2026-01-15
#### Features
- added first draft of linkwarden chart - (baf009c) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.1 - (69a72be) - github-actions

- - -

## linkwarden-0.1.0-preview.4 - 2025-12-22
#### Bug Fixes
- (**linkwarden**) use correct data dir - (5dce483) - Dennis Witt

- - -

## linkwarden-0.1.0-preview.3 - 2025-12-22
#### Bug Fixes
- (**linkwarden**) quote values in configmap - (a334c4d) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.3 - (4a97b17) - github-actions

- - -

## linkwarden-0.1.0-preview.2 - 2025-12-22
#### Bug Fixes
- (**linkwarden**) correctly use required function - (64c6f2e) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.2 - (92f87fd) - github-actions

- - -

## linkwarden-0.1.0-preview.1 - 2025-12-22
#### Features
- added first draft of linkwarden chart - (baf009c) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.1 - (69a72be) - github-actions

- - -

## linkwarden-0.1.0-preview.3 - 2025-12-22
#### Bug Fixes
- (**linkwarden**) quote values in configmap - (a334c4d) - Dennis Witt

- - -

## linkwarden-0.1.0-preview.2 - 2025-12-22
#### Bug Fixes
- (**linkwarden**) correctly use required function - (64c6f2e) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.2 - (92f87fd) - github-actions

- - -

## linkwarden-0.1.0-preview.1 - 2025-12-22
#### Features
- added first draft of linkwarden chart - (baf009c) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.1 - (69a72be) - github-actions

- - -

## linkwarden-0.1.0-preview.2 - 2025-12-22
#### Bug Fixes
- (**linkwarden**) correctly use required function - (64c6f2e) - Dennis Witt

- - -

## linkwarden-0.1.0-preview.1 - 2025-12-22
#### Features
- added first draft of linkwarden chart - (baf009c) - Dennis Witt
#### Miscellaneous Chores
- (**version**) linkwarden-0.1.0-preview.1 - (69a72be) - github-actions

- - -

## linkwarden-0.1.0-preview.1 - 2025-12-22
#### Features
- added first draft of linkwarden chart - (baf009c) - Dennis Witt
