# FMTokenCountParameters

Parameters for `fm token-count` (used by [FM](FM.md)`.tokenCount()`). The prompt is passed on **stdin**. `--quiet` is always added so the output is a bare integer.

## Inherits

- [FMParameters](FMParameters.md)

## Properties

| Property         | Type       | Default | Description                                       |
| ---------------- | ---------- | ------- | ------------------------------------------------- |
| `instructions`   | Text       | `""`    | Instructions to include in the count.             |
| `text`           | Collection | `Null`  | Additional text segments to include (repeatable). |
| `image`          | Collection | `Null`  | Image file paths to include (repeatable).         |
| `loadTranscript` | Text       | `""`    | Path to a saved transcript to seed the count.     |

> Token counting works with the on‑device `system` model only.
