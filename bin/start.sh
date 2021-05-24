#!/bin/sh

bin/elixir_search_extractor eval "ElixirSearchExtractor.ReleaseTasks.migrate()"

bin/elixir_search_extractor start
