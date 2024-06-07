FROM alpine:3

# Run command will be excuted while the image is building (docker build -t alp .)
RUN echo "building..."

# Entrypoint allows the container to be used as an executable (alias alpine_sh="docker run -it --rm alp")
ENTRYPOINT ["/bin/sh"]

# Command is the default command run by the container, intended to be overridden (alpine_sh -c 'echo bye')
CMD ["-c", "echo hi"]
