[![Build Status](https://travis-ci.org/sarahabimay/TeamBuilder.svg?branch=master)](https://travis-ci.org/sarahabimay/TeamBuilder)

# TeamBuilder

Team Builder is in development, but soon you will be able to randomly organize your event invitees into teams.

## Installation
1) First you must have Elixir installed
2) git clone the repo
3) from the repo directory, run the command ```mix escript.build```
4) then from the directory run ```./team_builder

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add team_builder to your list of dependencies in `mix.exs`:

        def deps do
          [{:team_builder, "~> 0.0.1"}]
        end

  2. Ensure team_builder is started before your application:

        def application do
          [applications: [:team_builder]]
        end

