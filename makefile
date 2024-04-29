.PHONY: backup restore get-volumes help build serve logs stop destroy
BACKUP_DIR = ./save

YQ_DOCKER_CMD = docker run --rm -v ${PWD}:/workdir mikefarah/yq
COMPOSE_PROJECT_NAME := $(shell basename $(CURDIR))
VOLUME_PREFIX := $(COMPOSE_PROJECT_NAME)_

define get-volumes
$(shell $(YQ_DOCKER_CMD) e '.volumes | keys | .[]' docker-compose.yml)
endef

COLOR_RESET   = \033[0m
COLOR_INFO    = \033[32m
COLOR_COMMENT = \033[33m

## Help
help:
	@printf "${COLOR_COMMENT}Usage:${COLOR_RESET}\n"
	@printf " make [target]\n\n"
	@printf "${COLOR_COMMENT}Available targets:${COLOR_RESET}\n"
	@awk '/^[a-zA-Z\-\_0-9\.@]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf " ${COLOR_INFO}%-16s${COLOR_RESET} %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)


#######################
# BUILDING TASKS
#######################

## Build docker image
build:
	docker compose build

## Run docker
serve: build
	docker compose up -d

## Show Docker logs
logs: serve
	docker compose logs -f

## Stop docker server
stop:
	docker compose stop

## Remove container with data volumes
destroy:
	docker-compose down -v

## Backup volumes
backup:
	mkdir -p $(BACKUP_DIR)
	@$(foreach vol,$(call get-volumes),\
        docker run --rm -v $(VOLUME_PREFIX)$(vol):/data -v $(CURDIR)/$(BACKUP_DIR):/backup ubuntu \
        tar czf /backup/$(vol).tar.gz -C /data .;)

## Restore volumes
restore: destroy serve stop
	@$(foreach vol,$(call get-volumes),\
        test -f $(BACKUP_DIR)/$(vol).tar.gz && \
        docker run --rm -v $(VOLUME_PREFIX)$(vol):/data -v $(CURDIR)/$(BACKUP_DIR):/backup ubuntu \
        bash -c "cd /data && tar xzf /backup/$(vol).tar.gz" || \
        echo "Backup for $(vol) not found";)

