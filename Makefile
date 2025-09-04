# Makefile para facilitar a gestão do ambiente Docker Go

# --- Configurações ---
.DEFAULT_GOAL := help

# Garante que os comandos funcionem mesmo que exista um arquivo com o mesmo nome
.PHONY: help dev debug-app debug-test up down stop logs ps clean build

# --- Comandos Principais ---

dev: ## Inicia o ambiente de desenvolvimento com Hot-Reload (Air)
	@echo "🚀  Iniciando ambiente de desenvolvimento com Hot-Reload..."
	@docker compose up --build

debug-app: ## Inicia o ambiente para DEPURAR A APLICAÇÃO com Delve
	@echo "🐞  Iniciando ambiente de depuração da aplicação (use 'Attach to Docker' no VS Code)..."
	@docker compose -f compose.debug.yaml up --build

debug-test: ## Inicia o ambiente para DEPURAR OS TESTES com Delve
	@echo "🧪  Iniciando ambiente de depuração de testes (use 'Attach to Docker' no VS Code)..."
	@docker compose -f compose.debug-test.yaml up --build

# --- Comandos de Ciclo de Vida ---

up: ## Sobe todos os serviços do docker-compose.yml em background
	@echo "⬆️  Subindo serviços em background..."
	@docker compose up -d --build

down: ## Para e remove os contêineres de todos os ambientes
	@echo "⬇️  Parando e removendo contêineres..."
	@docker compose down
	@docker compose -f compose.debug.yaml down
	@docker compose -f compose.debug-test.yaml down

stop: ## Para os contêineres de todos os ambientes sem removê-los
	@echo "🛑  Parando contêineres..."
	@docker compose stop
	@docker compose -f compose.debug.yaml stop
	@docker compose -f compose.debug-test.yaml stop

clean: ## Para e remove contêineres, volumes e redes
	@echo "🧹  Limpando tudo (contêineres, volumes anônimos)..."
	@docker compose down -v --remove-orphans
	@docker compose -f compose.debug.yaml down -v --remove-orphans
	@docker compose -f compose.debug-test.yaml down -v --remove-orphans

# --- Comandos Utilitários ---

build: ## Força a reconstrução das imagens sem iniciar os contêineres
	@echo "🛠️  Construindo imagens..."
	@docker compose build
	@docker compose -f compose.debug.yaml build
	@docker compose -f compose.debug-test.yaml build

logs: ## Exibe os logs dos serviços do docker-compose.yml
	@echo "📜  Exibindo logs..."
	@docker compose logs -f

ps: ## Lista os contêineres em execução
	@echo "📋  Listando contêineres..."
	@docker compose ps

help: ## Exibe esta mensagem de ajuda
	@echo "Commands available:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
