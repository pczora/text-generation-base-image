IMAGE_NAME ?= pczora/text-generation-base:0.0.3_v1.13_cuda

image:
	docker buildx build --platform linux/amd64 -t ${IMAGE_NAME} -f Dockerfile .

push_image:
	docker push ${BASE_IMAGE_NAME}

