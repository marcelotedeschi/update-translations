# Update translations Script
This is a simple script to automate the Phraseapp translation process. It:

1. Checks the branch to master stashing changes
2. Creates new update-translations/[date] branch
3. Pulls changes from Phraseapp translations
4. Adds commit, pushes to remote and creates pull request

## Required tools
* [Git](https://git-scm.com/)
* [PhraseApp CLI](https://github.com/phrase/phraseapp-client/releases)
* [Hub](https://hub.github.com/)

## Running
```shell
$ cd project-folder
$ path/to/file/update-translations.sh
```
