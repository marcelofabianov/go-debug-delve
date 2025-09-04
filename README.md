# Exemplo de Ambiente de Desenvolvimento e Debug para Go com Docker

Este repositório contém um projeto de exemplo completo que demonstra como configurar um ambiente de desenvolvimento robusto para aplicações em Go utilizando Docker. O setup inclui três modos de uso:

1.  **Modo de Desenvolvimento**: Com hot-reload utilizando [Air](https://github.com/air-verse/air) para máxima produtividade.
2.  **Modo de Depuração da Aplicação**: Com [Delve](https://github.com/go-delve/delve) e integração total com o Visual Studio Code para depurar a aplicação principal.
3.  **Modo de Depuração de Testes**: Usando Delve para executar e depurar testes de integração.

---

## Funcionalidades

* **Go 1.25**: Aplicação base escrita em Go.
* **Docker & Docker Compose**: Ambiente totalmente containerizado.
* **Testes com `testify`**: Exemplo de teste de integração para validar a API.
* **Hot-Reload**: Recarregamento automático da aplicação ao salvar arquivos (`.go`).
* **Multi-Stage & Single-Stage Dockerfiles**: Builds otimizados para cada cenário.
* **Debug Remoto**: Configuração `launch.json` para o VS Code se conectar ao Delve.
* **Separação de Ambientes**: Arquivos `compose` dedicados para cada cenário de uso.

---

## Pré-requisitos

* [Docker Engine](https://docs.docker.com/engine/install/)
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visual Studio Code](https://code.visualstudio.com/)
* [Extensão Go para VS Code](https://marketplace.visualstudio.com/items?itemName=golang.Go)

---

## Como Começar

### 1. Configuração Inicial

Clone o repositório (se ainda não o fez) e crie o arquivo de variáveis de ambiente.

```sh
# Crie seu arquivo .env local a partir do exemplo
cp .env.example .env

# (Opcional) Ajuste as variáveis no .env, como HOST_UID e HOST_GID
# Para saber seu UID e GID no Linux/macOS: id -u ; id -g
```

### 2. Modo de Desenvolvimento (Hot-Reload com `Air`)

Ideal para o desenvolvimento do dia a dia.

```sh
# Suba os contêineres em modo de desenvolvimento
docker compose up --build

# A API estará disponível em http://localhost:8080
```
Para testar, envie uma requisição (`curl http://localhost:8080/`) ou altere um arquivo `.go` e veja o `Air` reiniciar o servidor.

### 3. Modo de Depuração da Aplicação (com `Delve`)

Permite usar breakpoints na aplicação principal.

**Passo 1: Iniciar o Ambiente**
```sh
docker compose -f compose.debug.yaml up --build
```
O terminal mostrará o Delve aguardando conexão: `API server listening at: [::]:2345`.

**Passo 2: Conectar o VS Code**
1.  Abra `cmd/api/main.go` e adicione um breakpoint.
2.  Vá para a aba "Run and Debug", selecione **"Attach to Docker (Go)"** e pressione **F5**.
3.  Pressione **F5 novamente** ("Continue") para deixar a aplicação rodar.
4.  Envie uma requisição (`curl http://localhost:8080/`) para ativar o breakpoint.

### 4. Modo de Depuração de Testes (com `Delve`)

Permite usar breakpoints dentro dos seus arquivos de teste.

**Passo 1: Iniciar o Ambiente**
```sh
docker compose -f compose.debug-test.yaml up --build
```
O terminal mostrará o Delve aguardando conexão.

**Passo 2: Conectar o VS Code**
1.  Abra `cmd/api/main_test.go` e adicione um breakpoint.
2.  Vá para a aba "Run and Debug", selecione **"Attach to Docker (Go)"** e pressione **F5**.
3.  O Delve iniciará a suíte de testes e pausará automaticamente no seu breakpoint.
---
