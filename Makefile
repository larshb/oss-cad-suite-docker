DOCKER_TAG  := oss-cad-suite
DOCKER_TGZ  := oss-cad-suite-save.tgz
RELEASE_TGZ := oss-cad-suite-linux-x64-20230925.tgz
RELEASE_SRC := https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2023-09-25/${RELEASE_TGZ}

${DOCKER_TGZ}: .build
	docker save ${DOCKER_TAG} | gzip > $@

${RELEASE_TGZ}:
	wget ${RELEASE_SRC}

.build: ${RELEASE_TGZ} Dockerfile
	docker build -t ${DOCKER_TAG} --build-arg="RELEASE_TGZ=${RELEASE_TGZ}" .
	$(info Consider running 'docker system prune' to clean up)
	touch $@

run: .build Makefile
	@printf "#!/bin/bash\n\ndocker run -it --rm ${DOCKER_TAG}\n" > $@
	@chmod +x $@
	@echo "You can now run './$@'"
