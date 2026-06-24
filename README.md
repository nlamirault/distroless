# Atoma

A set of **lightweight and secure** container images based on the
[Wolfi](https://wolfi.dev/) Linux distribution.

## Documentation

Documentation follows the [Diátaxis](https://diataxis.fr/) framework — see [`docs/`](docs/) for the full index.

| Type              | Documents                                                                                          |
| ----------------- | -------------------------------------------------------------------------------------------------- |
| **Tutorials**     | [Getting started](docs/tutorials/getting-started.md)                                               |
| **How-to guides** | [Build and test images](docs/how-to/howto-build.md) · [Verify images](docs/how-to/howto-verify.md) |
| **Reference**     | [Configuration](docs/reference/configuration.md) · [Makefile commands](docs/reference/makefile.md) |
| **Explanation**   | [Architecture and design](docs/explanation/architecture.md)                                        |

## Available Images

| Image Name                           | Pull                                                    |
| ------------------------------------ | ------------------------------------------------------- |
| [shell](./images/shell/)             | `docker pull ghcr.io/nlamirault/atoma/shell`       |
| [infra-tools](./images/infra-tools/) | `docker pull ghcr.io/nlamirault/atoma/infra-tools` |

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)

## License

[Apache 2.0 License](./LICENSE)
