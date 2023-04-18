# Singularity in Docker

Build Singularity images and run Singularity containers inside a Docker container.

The source code is available on [Github](https://github.com/soerenmetje/singularity-in-docker).

## Singularity Version

```shell
docker run --rm --privileged -v "$PWD:/app" soerenmetje/singularity:latest version
```

## Build Image

`myimage.def` should be located in current host working directory. After successful execution, the image `myimage.sif`
is located in same host directory.

```shell
docker run --rm --privileged -v "$PWD:/app" soerenmetje/singularity:latest build myimage.sif myimage.def
```

## Run Container

```shell
docker run --rm --privileged -v "$PWD:/app" soerenmetje/singularity:latest run myimage.sif
```

## Interactive Session

```shell
docker run --entrypoint "/bin/bash" --rm -it --privileged -v "$PWD:/app" soerenmetje/singularity:latest
```

## Other Commands

All singularity commands can be used.
Instead of

```
singularity <command>
``` 

run

```
docker run --rm --privileged -v "$PWD:/app" soerenmetje/singularity:latest <command>
```

### Available Commands

```
docker run --rm -it --privileged -v "$PWD:/app/singularity" soerenmetje/singularity:latest
Usage:
  singularity [global options...] <command>

Available Commands:
  build       Build a Singularity image
  cache       Manage the local cache
  capability  Manage Linux capabilities for users and groups
  completion  generate the autocompletion script for the specified shell
  config      Manage various singularity configuration (root user only)
  delete      Deletes requested image from the library
  exec        Run a command within a container
  inspect     Show metadata for an image
  instance    Manage containers running as services
  key         Manage OpenPGP keys
  oci         Manage OCI containers
  overlay     Manage an EXT3 writable overlay image
  plugin      Manage Singularity plugins
  pull        Pull an image from a URI
  push        Upload image to the provided URI
  remote      Manage singularity remote endpoints, keyservers and OCI/Docker registry credentials
  run         Run the user-defined default command within a container
  run-help    Show the user-defined help for an image
  search      Search a Container Library for images
  shell       Run a shell within a container
  sif         Manipulate Singularity Image Format (SIF) images
  sign        Attach digital signature(s) to an image
  test        Run the user-defined tests within a container
  verify      Verify cryptographic signatures attached to an image
  version     Show the version for Singularity

Run 'singularity --help' for more detailed usage information.

```

## Supported Architectures

- `linux/amd64`