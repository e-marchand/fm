# FMParameters

Base class for the parameters of an `fm` command. It holds the options common to every subcommand and turns them into command‑line arguments. Specialised subclasses add per‑command options.

## Subclasses

- [FMRespondParameters](FMRespondParameters.md)
- [FMTokenCountParameters](FMTokenCountParameters.md)
- [FMSchemaParameters](FMSchemaParameters.md)
- [FMServeParameters](FMServeParameters.md)

## Properties

| Property  | Type | Default | Description                                                                       |
| --------- | ---- | ------- | --------------------------------------------------------------------------------- |
| `model`   | Text | `""`    | Model to use: `"system"` (default) or `"pcc"`. Omitted from the call when empty.   |
| `timeout` | Real | `0`     | Seconds before the process is killed if still alive (`0` = no timeout).            |
| `throw`   | Boolean | `False` | If `True`, a failed synchronous call throws its errors instead of returning. |

### Asynchronous callback properties

| Property      | Type        | Description                                                                 |
| ------------- | ----------- | --------------------------------------------------------------------------- |
| `onData`      | 4D.Function | Called for each chunk of output (streaming). Receives a [FMResult](FMResult.md). |
| `onResponse`  | 4D.Function | Called once on success.                                                      |
| `onError`     | 4D.Function | Called once on failure.                                                      |
| `onTerminate` | 4D.Function | Called once when the process terminates.                                     |
| `formula`     | 4D.Function | Called like `onData`.                                                        |

*Providing any of these makes the call asynchronous.* Be sure the calling process does not die before the callbacks fire (use `worker.wait()` or a `CALL WORKER` process).

## Functions

### args()

```
.args() : Collection
```

Returns the list of command‑line arguments (flags + quoted values), without the executable and subcommand. Overridden by subclasses.

### _isAsync()

```
._isAsync() : Boolean
```

`True` when at least one callback property is set.
