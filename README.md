<div align="center">

# asdf-modeler [![Build](https://github.com/barmac/asdf-modeler/actions/workflows/build.yml/badge.svg)](https://github.com/barmac/asdf-modeler/actions/workflows/build.yml) [![Lint](https://github.com/barmac/asdf-modeler/actions/workflows/lint.yml/badge.svg)](https://github.com/barmac/asdf-modeler/actions/workflows/lint.yml)


[Camunda Modeler](https://github.com/camunda/camunda-modeler/tree/develop/docs) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add modeler
# or
asdf plugin add modeler https://github.com/barmac/asdf-modeler.git
```

modeler:

```shell
# Show all installable versions
asdf list-all modeler

# Install specific version
asdf install modeler latest

# Set a version globally (on your ~/.tool-versions file)
asdf global modeler latest

# Now modeler commands are available
asdf modeler diagram.bpmn
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/barmac/asdf-modeler/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Maciej Barelkowski](https://github.com/barmac/)
