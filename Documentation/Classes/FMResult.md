# FMResult

Base result wrapping a `4D.SystemWorker` execution of the `fm` CLI. Specialised subclasses add typed accessors over the raw output.

## Subclasses

- [FMRespondResult](FMRespondResult.md)
- [FMTokenCountResult](FMTokenCountResult.md)
- [FMSchemaResult](FMSchemaResult.md)
- [FMAvailableResult](FMAvailableResult.md)
- [FMQuotaUsageResult](FMQuotaUsageResult.md)

## Properties

| Property  | Type            | Description                                              |
| --------- | --------------- | ------------------------------------------------------- |
| `worker`  | 4D.SystemWorker | The system worker that ran `fm`.                        |
| `command` | Text            | The exact command line that was executed.               |

## Computed properties

| Property     | Type    | Description                                                     |
| ------------ | ------- | -------------------------------------------------------------- |
| `terminated` | Boolean | `True` once the process has terminated.                        |
| `exitCode`   | Integer | Process exit code (`-1` if unknown).                           |
| `success`    | Boolean | `True` when terminated with exit code `0` and no error.        |
| `text`       | Text    | Trimmed standard output (or the current chunk while streaming).|
| `errorText`  | Text    | Standard error output.                                         |
| `errors`     | Collection | Errors, if any (4D execution errors and/or a [FMError](FMError.md) on non‑zero exit). |

## Functions

### throw()

```
.throw()
```

Throws each element of `errors` (no‑op when there are none).

## Example

```4d
var $r : cs.fm.FMAvailableResult:=cs.fm.FM.me.available("system")
If ($r.success)
    // $r.available, $r.text ...
Else
    $r.throw()
End if
```
