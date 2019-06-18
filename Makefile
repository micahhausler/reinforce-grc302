USERNAME?=micahhausler
IMAGE=$(USERNAME)/reinforce-grc302
EXPLOIT_IMAGE=$(USERNAME)/reinforce-grc302-exploit

docker:
	docker build -t $(IMAGE) -f Dockerfile.webapp .

push: docker
	docker push $(IMAGE)

docker-exploit:
	docker build -t $(EXPLOIT_IMAGE) -f Dockerfile.exploit .

push-exploit: docker-exploit
	docker push $(EXPLOIT_IMAGE)

.PHONY: docker push docker-exploit push-exploit
