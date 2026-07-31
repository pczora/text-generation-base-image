GIT_REF := $(shell git rev-parse --abbrev-ref HEAD | tr '/' '-')
GIT_SHA := $(shell git rev-parse --short HEAD)
TAG     := $(GIT_REF)-$(GIT_SHA)

IMAGE_NAME ?= pczora/text-generation-base:$(TAG)

image:
	docker buildx build --platform linux/amd64 -t ${IMAGE_NAME} -f Dockerfile .

push_image:
	docker push ${IMAGE_NAME}
