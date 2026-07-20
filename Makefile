IMAGE_NAME ?= pczora/text-generation-base:v4.9_cuda-mini

image:
	docker buildx build --platform linux/amd64 -t ${IMAGE_NAME} -f Dockerfile .

push_image:
	docker push ${IMAGE_NAME}
