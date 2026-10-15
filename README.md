# CleanMacZip

---

Using `zip` / Finder “Compress” on macOS often adds `__MACOSX/`, `._*` AppleDouble files, and `.DS_Store`, which break graders, Linux unzip, and some mail filters — **CleanMacZip** stages a copy without resource forks, strips that junk, then packs with `COPYFILE_DISABLE=1` and `zip -X`.

## Usage

---

```bash
brew install t66v8dw62k-ops/cleanmaczip/cleanmaczip
cleanmaczip <source_directory>
```

## Goal

---

Trying to get 230 stars to submit to home-brew! :D
