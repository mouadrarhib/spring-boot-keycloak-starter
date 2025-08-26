up:
	docker compose up -d --build

down:
	docker compose down

logs:
	docker compose logs -f

token-user:
	CLIENT_ID=spring-boot-api CLIENT_SECRET=secret123 USERNAME=user1 PASSWORD=user1pass \
	bash -c 'curl -s -X POST "http://localhost:8081/realms/spring-boot-realm/protocol/openid-connect/token" -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=password" -d "client_id=$$CLIENT_ID" -d "client_secret=$$CLIENT_SECRET" -d "username=$$USERNAME" -d "password=$$PASSWORD" | jq -r .access_token'

token-admin:
	CLIENT_ID=spring-boot-api CLIENT_SECRET=secret123 USERNAME=admin1 PASSWORD=admin1pass \
	bash -c 'curl -s -X POST "http://localhost:8081/realms/spring-boot-realm/protocol/openid-connect/token" -H "Content-Type: application/x-www-form-urlencoded" -d "grant_type=password" -d "client_id=$$CLIENT_ID" -d "client_secret=$$CLIENT_SECRET" -d "username=$$USERNAME" -d "password=$$PASSWORD" | jq -r .access_token'
