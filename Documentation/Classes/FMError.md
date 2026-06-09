# FMError

Structured error for a failed `fm` execution, so [FMResult](FMResult.md)`.throw()` yields a usable 4D error.

## Properties

| Property   | Type    | Description                                  |
| ---------- | ------- | -------------------------------------------- |
| `errCode`  | Integer | Mirrors `exitCode` (for 4D error handling).  |
| `message`  | Text    | Error message (stderr, or a default).        |
| `exitCode` | Integer | Process exit code.                           |
| `command`  | Text    | The command line that failed.                |
