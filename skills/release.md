# Skill: release – Tag a release and publish CRT files

## Purpose

Create a versioned GitHub Release and upload all four `.crt` artefacts
(cs/de × 9pin/24pin) automatically via the CI `release` job.

## Versioning scheme

```
v<major>.<minor>.<patch>    e.g. v2.6.1
```

The CI derives the version string from `git describe --tags`:
- On a tagged commit: `2.6.1`
- After additional commits: `2.6.1-5-gabc1234`

## Release checklist (human)

Before tagging, verify:

- [ ] CI build is green on `main`
- [ ] `README.md` version section is updated
- [ ] Any new fonts are committed to `fonts/prg/` and `fonts/png/`
- [ ] `docs/pagefox_memory_map.md` is up to date if banking changed
- [ ] Changelog entry is written (GitHub will auto-generate release notes)

## Tagging and pushing

```bash
git tag v2.6.1
git push origin v2.6.1
```

This triggers the `release` job in `.github/workflows/ci.yml`, which:

1. Downloads the four `.crt` + `.png` artefacts from the `build` job.
2. Creates a GitHub Release named after the tag.
3. Uploads all `.crt` and `.png` files as release assets.
4. Generates release notes from merged PRs since the last tag.

## Verifying the release

After the workflow completes (~5 min):

```bash
gh release view v2.6.1
gh release download v2.6.1 --dir /tmp/release-check/
ls -la /tmp/release-check/
```

Expected files:

```
Pagefox-cs-2.6.1.crt
Pagefox-cs-2.6.1.png
Pagefox-cs-2.6.1-24pin.crt
Pagefox-cs-2.6.1-24pin.png
Pagefox-de-2.6.1.crt
Pagefox-de-2.6.1.png
Pagefox-de-2.6.1-24pin.crt
Pagefox-de-2.6.1-24pin.png
```

## Deleting a bad release (emergency)

```bash
gh release delete v2.6.1 --yes
git tag -d v2.6.1
git push origin :refs/tags/v2.6.1
```

Then fix the issue, commit, and re-tag.

## What agents must NOT do

- Do not push a tag without a human confirming the release checklist above.
- Do not manually upload `.crt` files to the release – let CI do it.
- Do not modify `permissions: contents: write` scope unless the release job
  is restructured and a human has reviewed the change.
