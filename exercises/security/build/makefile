all: build

# Check if sudo is required to run Docker
RUNSUDO := $(shell groups | grep ' docker ' 1>/dev/null || echo "sudo")

# see https://pythonspeed.com/articles/docker-build-secrets/

.PHONY: build
# Build the container image using example_token.txt as a secret file
build:
	${RUNSUDO} \
	DOCKER_BUILDKIT=1 docker build --secret id=token,src=./example_token.txt . \
		-t example_docker_secret \
		-f Containerfile --progress=plain --no-cache

run:
	${RUNSUDO} \
	docker run -it example_docker_secret
