BRANCH ?= "master"
REPONAME ?= "$(shell basename `git rev-parse --show-toplevel`)"
ORG ?= "stevenjack"
VERSION ?= $(shell cat ./VERSION)

build-image:
	@docker build -t ${ORG}/${REPONAME} --build-arg VERSION=${VERSION} .

check-version:
	@echo "=> Checking if VERSION exists as Git tag..."
	(! git rev-list ${VERSION})

docker-login:
	@docker login -e ${DOCKER_EMAIL} -u ${DOCKER_USER} -p ${DOCKER_PASS}

push-tag:
	@echo "=> New tag version: ${VERSION}"
	git checkout ${BRANCH}
	git pull origin ${BRANCH}
	git tag ${VERSION}
	git push origin ${BRANCH} --tags

push-to-registry:
	@docker login -e ${DOCKER_EMAIL} -u ${DOCKER_USER} -p ${DOCKER_PASS}
	@docker tag ${ORG}/${REPONAME}:latest ${ORG}/${REPONAME}:${CIRCLE_TAG}
	@docker push ${ORG}/${REPONAME}:${CIRCLE_TAG}
	@docker push ${ORG}/${REPONAME}
