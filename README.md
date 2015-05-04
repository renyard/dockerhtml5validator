# Docker W3C/HTML5 validator instance
Dockerfile for the creation of a self contained W3C Markup validator (with HTML5 validation) SSL instance for validation of authored HTML documents through the [Validity](https://github.com/renyard/validity) Chrome extension.

Setup of such a configuration can be tricky and a little messy so having all this in an isolated and automated way seemed like a good idea.

## Building
To build the Docker image, you will need server.crt and sever.key in the certs/ directory, then run the following:

```sh
$ ./build.sh
```

This will take some time (lots to download), performing the following tasks:
- Install Ubuntu base (14.04), Apache HTTP server, OpenJDK 6, [supervisord](http://supervisord.org/) and a few others.
- Download latest W3C validator source and [Validator.nu](http://validator.github.io/) `vnu.jar` portable HTML5 validator jar.
- Configure Perl/CPAN.
- Install and configure W3C validator (including Validator.nu setup).
- Start Apache and Validator.nu under `supervisord`.
- Install the Node proxy and SSL certificates.

That's the boring/messy stuff out of the way - your new Docker image should now be built.

## Running
To execute the image, run the following:

```sh
$ ./run.sh
```

This will start the image in a new detached container and expose port `443` (Node) to your host machine on port `443`. You can of course run the container on an alternative local port if you desire by modifying the `docker run -p` switch.

With this complete you should now be able to browse to `https://hostname` and be presented with a working W3C validator instance.
