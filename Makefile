build:
	$(info Make: Building images.)
	docker-compose build --no-cache
	@make -s clean

start:
	$(info Make: Starting containers.)
	docker-compose up -d

stop:
	$(info Make: Stopping containers.)
	@docker-compose stop

restart:
	$(info Make: Restarting containers.)
	@make -s stop
	@make -s start

clean:
	@docker system prune --volumes --force
