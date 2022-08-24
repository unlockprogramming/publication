+++
draft = false
title = "Aws command line snippets"
date = "2022-07-27"
+++

My curated list of aws command line snippets that might be useful for developer.

<!--more-->

## Delete all aws ecr repositories

```bash
for row in $(aws ecr describe-repositories | jq -r '.repositories[] | @base64'); do
  _jq() {
    echo ${row} | base64 --decode | jq -r ${1}
  }
  repositoryName=$(_jq '.repositoryName')
  echo "Deleting repository..... $repositoryName"
  aws ecr delete-repository --repository-name "$repositoryName" --force | jq -r '.'
done
```
