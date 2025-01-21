# Maintainer Documentation

## Releasing
You will need `git cliff` installed:
```shell
cargo install git-cliff
```

1. Finalize your changes and commit them.
2. Generate a changelog with the tentative release using today's date in the demonstrated format. Note, if you've already made a release today, append an incrementing `.1`, etc. to the end of the tag.
```shell
git cliff -o CHANGELOG.md --tag v2024.10.29
```
3. Commit the changelog update, tag with the version, and push:
```shell
git add CHANGELOG.md
git commit -m "Release v2024.10.29"
git tag v2024.10.29
git push
git push --tags
```
