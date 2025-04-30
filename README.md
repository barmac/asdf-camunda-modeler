<div align="center">

# asdf-camunda-modeler [![Build](https://github.com/barmac/asdf-camunda-modeler/actions/workflows/build.yml/badge.svg)](https://github.com/barmac/asdf-camunda-modeler/actions/workflows/build.yml)


[Camunda Modeler](https://github.com/camunda/camunda-modeler) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

## Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

## Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.

## Install

Plugin:

```shell
asdf plugin add camunda-modeler
# or
asdf plugin add camunda-modeler https://github.com/barmac/asdf-camunda-modeler.git
```

## Usage

```shell
# Show all installable versions
asdf list all camunda-modeler

# Install specific version
asdf install camunda-modeler latest

# Set a version globally (on your ~/.tool-versions file)
asdf set -u camunda-modeler latest

# Now modeler commands are available
asdf cmd camunda-modeler diagram.bpmn

# Download and run current nightly
asdf cmd camunda-modeler nightly
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

## Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/barmac/asdf-camunda-modeler/graphs/contributors)!

## License

See [LICENSE](LICENSE) © [Maciej Barelkowski](https://github.com/barmac/)
