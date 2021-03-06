BUILD=build
BIN_DIR?=.

BUILD_TIME=$(shell date +%s)
GIT_COMMIT=$(shell git rev-parse HEAD)
VERSION ?= $(shell git tag --points-at HEAD | grep ^v | head -n 1)
LDFLAGS=-ldflags "-X main.BuildTime=$(BUILD_TIME) -X main.GitCommit=$(GIT_COMMIT) -X main.Version=$(VERSION)"

.PHONY: build
build:
	@mkdir -p $(BUILD)/$(BIN_DIR)
	go build $(LDFLAGS) -o $(BUILD)/$(BIN_DIR)/dp-legacy-redirector .

.PHONY: debug
debug:
	go run -race $(LDFLAGS) .

.PHONY: test
test:
	go test -race -cover ./...

.PHONY: audit
audit:
	go list -json -m all | nancy sleuth --exclude-vulnerability-file ./.nancy-ignore