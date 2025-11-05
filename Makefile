format:
	swiftformat .

lint:
	swiftlint --quiet || true

test-packages:
	(cd packages/SharedKit && swift test) && (cd apps/api && swift test)

api-dev:
	(cd infra/docker && docker compose up --build)





