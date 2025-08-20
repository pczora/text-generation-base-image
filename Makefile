IMAGE_NAME ?= pczora/text-generation-base:v3.11_cuda

image:
	docker buildx build --platform linux/amd64 -t ${IMAGE_NAME} -f Dockerfile .

push_image:
	docker push ${BASE_IMAGE_NAME}

