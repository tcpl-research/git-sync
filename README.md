# Git Sync

A GitHub Action for syncing between two independent repositories using  optionally **force push**. 


## Features
 * Sync branches between two GitHub repositories
 * Sync branches to/from a remote repository
 * GitHub action can be triggered on a timer or on push
 * To sync with current repository, please checkout [Github Repo Sync](https://github.com/marketplace/actions/github-repo-sync)


## Usage

### GitHub Actions
```
# File: .github/workflows/repo-sync.yml

on: push
jobs:
  repo-sync:
    runs-on: ubuntu-latest
    steps:
    - name: repo-sync
      uses: tcpl-research/git-sync@v2
      env:
        SOURCE_REPO: ""
        SOURCE_BRANCH: ""
        DESTINATION_REPO: ""
        DESTINATION_BRANCH: ""
        EMAIL: ""
        NAME: ""
        FORCE: ""
        SSH_PRIVATE_KEY: ${{ secrets.SSH_PRIVATE_KEY }}
      with:
        args: $SOURCE_REPO $SOURCE_BRANCH $DESTINATION_REPO $DESTINATION_BRANCH $EMAIL $NAME
```
`SSH_PRIVATE_KEY` can be omitted if using authenticated HTTPS repo clone urls like `https://username:access_token@github.com/username/repository.git`.

`EMAIL` and `NAME` will be set as the git username and email for the push commit

`FORCE` defaults to false and will only be enforced when passing `true`. Still needs to be passed as an empty string for default.

#### Advanced: Sync all branches

To Sync all branches from source to destination, use `SOURCE_BRANCH: "refs/remotes/source/*"` and `DESTINATION_BRANCH: "refs/heads/*"`. But be careful, branches with the same name including `master` will be overwritten.

### Docker
```
docker run --rm -e "SSH_PRIVATE_KEY=$(cat ~/.ssh/id_rsa)" $(docker build -q .) \
  $SOURCE_REPO $SOURCE_BRANCH $DESTINATION_REPO $DESTINATION_BRANCH
```

## Authors

Original repo from [Wei He](https://github.com/wei/git-sync)

Updated by tcpl to suit needs

