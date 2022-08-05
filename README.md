# Docker Shibboleth Service Provider on Ubuntu Linux

This is a docker container that builds and runs a web server that provides a web based authentication system. Based on the instructions found in the [
Shibboleth at Cornell Documentation](https://confluence.cornell.edu/display/SHIBBOLETH/Install+Shibboleth+Service+Provider+on+Linux).

## Docker Commands

A bash script is included in the root of this project that will run the docker commands to build and run the container.

## To get started use the following commands

```bash
# List all command options
bash run.sh help

# Build the container
bash run.sh build

# Start the container
bash run.sh start

# Test the shib configuration
bash run.sh test
```

Then goto [https://localhost/ ](https://localhost/ ) and you should see a login page.

if you get error on your local machine: `Error starting userland proxy: listen tcp 0.0.0.0:80: bind: address already in use`

Then you should change the ports:80 in docker compose to use a different port.
