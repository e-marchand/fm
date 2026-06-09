# _FMAsyncOptions

Internal options object passed to `4D.SystemWorker.new()` for asynchronous / streaming `fm` calls. The worker reads its config properties and calls its callback methods (bound to the instance), which dispatch to the user callbacks held in the [FMParameters](FMParameters.md).

## Properties

| Property        | Type        | Description                                            |
| --------------- | ----------- | ----------------------------------------------------- |
| `dataType`      | Text        | `"text"` — response decoding type.                    |
| `timeout`       | Integer     | Only present when `> 0` (a present `0` would kill the process immediately). |
| `_parameters`   | [FMParameters](FMParameters.md) | The user parameters with their callbacks. |
| `_resultClass`  | 4D.Class    | Result class used to wrap chunks and the final result.|
| `_result`       | [FMResult](FMResult.md) | The result populated on terminate.        |

## Functions

| Function        | Description                                                         |
| --------------- | ----------------------------------------------------------------- |
| `onData()`      | Wraps each chunk in a result and forwards to `onData` / `formula`. |
| `onResponse()`  | Final response (dispatched from `onTerminate`).                    |
| `onError()`     | Execution error (exposed via `worker.errors`).                    |
| `onDataError()` | stderr (available via `worker.responseError`).                    |
| `onTerminate()` | Marks the result terminated and dispatches `onResponse`/`onError`/`onTerminate`/`formula`. |
