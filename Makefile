default: clean build up

# Brings down the docker-compose file
# and any generated files.
clean:
	@docker-compose down --remove-orphans

# Builds the docker-compose file.
build:
	@docker-compose build

# Brings up the docker-compose file.
up:
	@./scripts/run.sh

# Setup will run the setup wizard.
setup:
	@./scripts/setup_wizard.sh

# Attaches into the container.
attach:
	@docker exec -ti bitcoin_node /bin/sh 


