## Search Extractor

> *This is and Elixir app that takes some keyword and searches to google and  stores some important information.*

## Project Setup

### Erlang & Elixir

* Erlang 23.3

* Elixir 1.11.4

* Recommended version manager.

  - [asdf](https://github.com/asdf-vm/asdf)
  - [asdf-erlang](https://github.com/asdf-vm/asdf-erlang)
  - [asdf-elixir](https://github.com/asdf-vm/asdf-elixir)

### Development

* Install [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)

* Setup and boot the Docker containers:

  ```sh
  make docker_setup
  ```

* Install Elixir dependencies:

  ```sh
  mix deps.get
  ```

* Install Node dependencies:

  ```sh
  npm install --prefix assets
  ```

* Setup the databases:

  ```sh
  mix ecto.setup
  ```

* Start the Phoenix app

  ```sh
  iex -S mix phx.server
  ```

* Run all tests:

  ```sh
  mix test 
  ```

* Run all lint:

  ```sh
  mix codebase 
  ```
  
* Test coverage:

  ```sh
  mix coverage 
  ```

### Production

* Buidl Docker image

  ```sh
  docker-compose build
  ```
