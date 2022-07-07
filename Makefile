######################################################################################
# SUPPORT
######################################################################################

status:
	@minikube status



env-up: create-data-volumes-folder
	docker-compose -f dev-env/docker-compose.yml up --remove-orphans

env-up-d: create-data-volumes-folder
	docker-compose -f dev-env/docker-compose.yml up -d --remove-orphans

env-down:
	docker-compose -f dev-env/docker-compose.yml down --remove-orphans

######################################################################################
# MIGRATIONS
######################################################################################
######################################################################################
# CODE QUALITY
######################################################################################
lint: vendor
	@echo "Linting..."
	@go run $(LINT) run --timeout=10m $(PATHS)

vet:
	@echo "Vetting..."
	@go vet $(PATHS)

tests:
	@echo "Testing..."
	@go clean -testcache && PROFILE=test go test -v -gcflags=-l -cover $(PATHS) -coverprofile=coverage.out
	@go tool cover -func=coverage.out

generate-mock: check-interface_name \
				vendor
	@go run $(MOCKERY) --dir ./internal --name ${interface_name} --recursive --case=underscore --output ./mocks

######################################################################################
# BUILD
######################################################################################
define getBuildInfo
	cat BUILD_INFO | grep -w $1 | cut -d'=' -f2
endef

BUILD_TIME=$(shell date '+%a %b %d %H:%M:%S %Y')
GIT_COMMIT=$(shell git rev-parse --short HEAD)
GIT_BRANCH=$(shell git branch --show-current)
PACKAGE=$(shell $(call getBuildInfo,PACKAGE))
VERSION=$(shell $(call getBuildInfo,VERSION))
VERSION_CLIENT=$(shell $(call getBuildInfo,VERSION_CLIENT))
APP_NAME=docker-go-server
LDFLAGS= -X '${PACKAGE}/cmd.Version=${VERSION}' -X '${PACKAGE}/cmd.GitCommit=${GIT_COMMIT}' -X '${PACKAGE}/cmd.BuildTime=${BUILD_TIME}'
BUILD=go build -v -o ./bin/${APP_NAME} ./cmd
IMAGE_NAME="rain/${APP_NAME}"
IMAGE_TAG=${VERSION}
IMAGE_ID="${IMAGE_NAME}"

image-tag: check-branch check-commit
	@echo "${VERSION}-${branch}-${commit}"

image-name: check-tag
	@echo "${IMAGE_NAME}:${tag}"

build:
	@echo "Building..."
	@$(BUILD)

build-linux:
	@echo "Building..."
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64 $(BUILD)

build-docker-image:
	@echo "Building docker image..."
	@echo $(IMAGE_TAG)
	@docker build --no-cache -f ./Dockerfile -t $(IMAGE_ID) --build-arg APP_NAME=${APP_NAME} .

build-docker: build \
			build-docker-image

build-linux-docker: build-linux \
					build-docker-image
