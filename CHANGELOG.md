# Changelog

### [2.0.3](https://www.github.com/barmac/asdf-camunda-modeler/compare/v2.0.2...v2.0.3) (2023-06-13)


### Bug Fixes

* sort versions semantically ([d9ad4c8](https://www.github.com/barmac/asdf-camunda-modeler/commit/d9ad4c86f7a6ca7c83699fcc00d879152886574f)), closes [#8](https://www.github.com/barmac/asdf-camunda-modeler/issues/8)

### [2.0.2](https://www.github.com/barmac/asdf-camunda-modeler/compare/v2.0.1...v2.0.2) (2022-10-18)


### Bug Fixes

* make nightly command work on MacOS again ([59f3e76](https://www.github.com/barmac/asdf-camunda-modeler/commit/59f3e76d9bc7913bbdf313ea2f9a9e2c1d94a848))

### [2.0.1](https://www.github.com/barmac/asdf-camunda-modeler/compare/v2.0.0...v2.0.1) (2022-10-18)


### Bug Fixes

* check nightly age on executable ([39adff6](https://www.github.com/barmac/asdf-camunda-modeler/commit/39adff609cfb348f94b627ed0d194c4a5503ca38))
* rename plugin also in the nightly command ([2f18ce4](https://www.github.com/barmac/asdf-camunda-modeler/commit/2f18ce4373e33c51798c741089defee090e08519))

## [2.0.0](https://www.github.com/barmac/asdf-modeler/compare/v1.0.0...v2.0.0) (2022-10-17)


### ⚠ BREAKING CHANGES

* rename plugin to `asdf-camunda-modeler` ([3a1d620](https://www.github.com/barmac/asdf-modeler/commit/3a1d62096a54cc4afad7eaea6941b2cc065a8896))

To upgrade, reinstall the plugin via:

```bash
asdf plugin remove modeler
asdf plugin add camunda-modeler https://github.com/barmac/asdf-camunda-modeler.git
```

## 1.0.0 (2022-09-19)


### Features

* add `nightly` command ([c7a0179](https://www.github.com/barmac/asdf-camunda-modeler/commit/c7a0179f33de91e0330171856d7349dba674189d)), closes [#2](https://www.github.com/barmac/asdf-camunda-modeler/issues/2)
* display download progress bar ([2080f37](https://www.github.com/barmac/asdf-camunda-modeler/commit/2080f37fd50b950d8ec773199324c5058f974a54))
* implement for macos and linux ([31d92dc](https://www.github.com/barmac/asdf-camunda-modeler/commit/31d92dceaeb0bddf95f933b66247a71a4fa1951c))
