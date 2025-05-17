include ./.env
pull:
	docker pull nginx:1.27.1
	docker pull postgres:16.4
	docker pull adminer

start:
	docker compose up --build

up:	prepare-dir
	sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0 && systemctl --user start docker-desktop && sleep 5s # ubuntu desktop 24.04
	docker compose up --build -d
	sleep 5s && sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=1 # ubuntu desktop 24.04 

down:
	docker compose down

list:
	docker compose ps

nginx-log:
	docker logs -f --details $(PROJECT)-nginx

db-log:
	docker logs -f --details $(PROJECT)-db

app-log:
	docker logs -f --details $(PROJECT)-app

bash-app:
	docker exec -it $(PROJECT)-app bash

bash-nginx:
	docker exec -it $(PROJECT)-nginx bash

bash-db:
	docker exec -it $(PROJECT)-db bash

install-laravel:
	composer create-project laravel/laravel $(PROJECT)

prepare-dir:
	mkdir -p ./tmp/pgdata
	sudo chmod -R 0755 ./tmp/pgdata
	sudo chmod -R 0755 ./$(PROJECT)
	sudo chmod -R 0777 ./$(PROJECT)/storage/app/public
	sudo chown -R $(USER_ID):$(GROUP_ID) ./$(PROJECT)
	sudo find ./$(PROJECT) -type f | xargs chmod 0664

create-project: install-laravel pull prepare-dir start
	# next go to bash and execute command "cd .. && php artisan migrate"