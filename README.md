[![Build Status](https://travis-ci.org/sarahabimay/TeamBuilder.svg?branch=master)](https://travis-ci.org/sarahabimay/TeamBuilder)

# TeamBuilder

Team Builder is an Elixir app, to randomly organize a list of people into teams.

#### Usage:
##### To Run:
```
./team_builder
```
##### To Add Members:
```
Welcome to TeamBuilder. Please add your first invitee.
Add Team Member ([q] Quit - [b] Build Teams):
```
##### To Build Teams:
```
[ Members Added ]
[1] Jane
[2] John
[3] Dexter
[3] Morgan

Add Team Members ([q] Quit - [b] Build Teams): b
```
##### Select team allocation style:
- option - option_size e.g. `1 - 4`
```
[ Team Type Options ]
[1] Fixed Number Of Teams [enter: 1 - max_number_of_teams]
[2] Max Team Size [enter: 2 - max_team_size]
> 1 - 4
```
##### Result!
```
[ Team 1 ]
[1] Jane

[ Team 2 ]
[1] John

[ Team 3 ]
[1] Morgan

[ Team 4 ]
[1] Dexter

Add Team Members ([q] Quit - [b] Build Teams):
```

## Installation
1. First you must have Elixir installed
  1. Mac OS
    * Update your homebrew to latest: ```brew update```
    * Run: ```brew install elixir```
  2. Add Elixir to your PATH (UNIX)
    * ```export PATH="$PATH:/path/to/elixir/bin"```
  3. Further help can be found at [Elixir-Lang](http://elixir-lang.org/install.html)


2. Clone the repo
  * ```git clone https://github.com/sarahabimay/TeamBuilder.git```


3. From the repo directory, run the command:
  * ```mix escript.build```


4. Then from the directory run:
  * ```./team_builder```
