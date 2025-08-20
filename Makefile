IMAGE_NAME ?= pczora/text-generation-base:v3.11_cuda
MINIMAL_IMAGE_NAME ?= pczora/text-generation-base:v3.11_cuda-mini

make minimal_image:
	docker buildx build --platform linux/amd64 -t ${IMAGE_NAME} -f ./Docker/minimal/Dockerfile .

push_minimal_image:
	docker push ${MINIMAL_IMAGE_NAME}

image:
	docker buildx build --platform linux/amd64 -t ${IMAGE_NAME} -f Dockerfile .

push_image:
	docker push ${IMAGE_NAME}

