# FM

`FM` is a **singleton** wrapper around the macOS `fm` command‑line tool (Apple Foundation Models). It lets 4D code generate responses, count tokens, build JSON schemas, check availability and quota, and run the local Chat Completions server — on‑device or via Private Cloud Compute.

Access it through the class store singleton:

```4d
var $text : Text:=cs.fm.FM.me.respond("What is Swift?")
```

> Requires macOS with the `fm` executable installed and reachable through `PATH`.

## Properties

| Property       | Type | Default    | Description                                                        |
| -------------- | ---- | ---------- | ------------------------------------------------------------------ |
| `executable`   | Text | `"fm"`     | Path or name of the `fm` executable (resolved through `PATH`).     |
| `defaultModel` | Text | `"system"` | Model used by `respond` when none is given: `"system"` or `"pcc"`. |

## Functions

### respond()

```
.respond( prompt : Text { ; parameters : Object } ) : Variant
```

Generates a response to `prompt`.

- **Synchronous** (default): waits and returns the generated **Text**.
- **Asynchronous**: if `parameters` carries `onData` / `onResponse` / `onTerminate` / `onError` / `formula`, it starts streaming (`--stream`) and returns a [FMRespondResult](FMRespondResult.md) immediately. Call `result.worker.wait()` (or run from a `CALL WORKER` process) to let the callbacks fire.

`parameters` is coerced into [FMRespondParameters](FMRespondParameters.md).

```4d
// synchronous
var $answer : Text:=cs.fm.FM.me.respond("Summarize this"; {instructions: "Be concise."})

// streaming
var $r : cs.fm.FMRespondResult:=cs.fm.FM.me.respond("Tell a story"; {onData: Formula(MyOnData($1))})
$r.worker.wait()
```

### tokenCount()

```
.tokenCount( prompt : Text { ; parameters : Object } ) : Integer
```

Returns the number of tokens in `prompt` (on‑device system model only). `parameters` is coerced into [FMTokenCountParameters](FMTokenCountParameters.md).

### schema()

```
.schema( parameters : Object ) : Object
```

Generates a JSON generation schema for an object type and returns it **parsed** (or `Null`). `parameters` is coerced into [FMSchemaParameters](FMSchemaParameters.md).

```4d
var $schema : Object:=cs.fm.FM.me.schema({name: "Person"; properties: [\
    {name: "name"; type: "string"}; \
    {name: "age"; type: "integer"}\
]})
```

### available()

```
.available( model : Text ) : cs.fm.FMAvailableResult
```

Checks model availability. Pass `"system"`, `"pcc"`, or `""` to check all. See [FMAvailableResult](FMAvailableResult.md).

### quotaUsage()

```
.quotaUsage( model : Text ) : cs.fm.FMQuotaUsageResult
```

Checks model quota usage. See [FMQuotaUsageResult](FMQuotaUsageResult.md).

### serve()

```
.serve( parameters : Object ) : cs.fm.FMResult
```

Starts the Chat Completions API server. **Long‑running**: returns immediately with a running worker. Stop it with `result.worker.terminate()`. `parameters` is coerced into [FMServeParameters](FMServeParameters.md).

### installed()

```
.installed() : Boolean
```

`True` if the `fm` executable can be run on this machine (always `False` on Windows).
