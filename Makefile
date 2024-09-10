include ./.env
pull:
	docker pull nginx:1.27.1
	docker pull postgres:16.4
	docker pull adminer

start:
	docker compose up --build

up:
	sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
	#sudo service apache2 stop
	systemctl --user start docker-desktop
	mkdir -p ./tmp/pgdata
	sudo chmod -R 777 ./tmp/pgdata
	sleep 5s
	docker compose up --build -d
	#sleep 15s
	sudo chmod -R 777 ./$(PROJECT)
	sudo chown -R $(USER_ID):$(GROUP_ID) ./$(PROJECT)

down:
	docker compose down

list:
	docker compose ps

app-log:
	docker logs -f --details $(PROJECT)-web

bash:
	docker exec -it $(PROJECT)-app bash

install-laravel:
	composer create-project laravel/laravel $(PROJECT)
