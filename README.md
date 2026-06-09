# FM — Apple Foundation Models for 4D

A small, dependency‑free 4D wrapper around Apple's [`fm`](https://developer.apple.com/apple-intelligence/) command‑line tool, which exposes **Apple Foundation Models** — the on‑device Apple Intelligence LLM and its Private Cloud Compute counterpart.

Generate text, count tokens, build JSON generation schemas, check model availability/quota, and run a local Chat Completions server — all from 4D, with no network or API key.

```4d
var $answer : Text:=cs.fm.FM.me.respond("Explain closures in one sentence.")
```

## Requirements

- **macOS** Golden Gate with Apple Intelligence available.
- The **`fm`** executable installed and reachable through your `PATH` (`which fm` should resolve).
- 4D / 4D Server **20 R5** or later (uses `4D.SystemWorker`).

Two models are available:

| Model    | Description                                            |
| -------- | ----------------------------------------------------- |
| `system` | On‑device Apple Foundation Model (default).           |
| `pcc`    | Apple Foundation Model on Private Cloud Compute.      |

## Usage

### Respond (synchronous)

```4d
var $text : Text:=cs.fm.FM.me.respond("What is Swift?")
```

With options (instructions, model, deterministic sampling, images…):

```4d
var $text : Text:=cs.fm.FM.me.respond("What is in this image?"; {\
    model: "pcc"; \
    instructions: "Answer briefly."; \
    image: ["/path/to/photo.jpg"]; \
    greedy: True\
})
```

### Respond (streaming)

Provide an `onData` callback and the call becomes asynchronous: it returns immediately with a running worker. Call `worker.wait()` to pump the callbacks (or run the call from a `CALL WORKER` process so it never blocks the caller).

```4d
var $r : cs.fm.FMRespondResult:=cs.fm.FM.me.respond("Tell a short story."; {\
    onData: Formula(OnChunk($1)); \
    onTerminate: Formula(OnDone($1))\
})
$r.worker.wait()
// $r.text -> the full response

  // OnChunk method
#DECLARE($chunk : cs.fm.FMResult)
// $chunk.text -> the latest streamed piece
```

### Token count

```4d
var $n : Integer:=cs.fm.FM.me.tokenCount("Hello world")  // -> 11
```

### JSON generation schema

```4d
var $schema : Object:=cs.fm.FM.me.schema({name: "Person"; properties: [\
    {name: "name"; type: "string"; description: "Full name"}; \
    {name: "age"; type: "integer"}; \
    {name: "tags"; type: "string"; array: True}; \
    {name: "nickname"; type: "string"; optional: True}\
]})
```

Feed it back into a constrained generation via `schemaFile`:

```4d
// write $schema to a file, then:
var $json : Text:=cs.fm.FM.me.respond("Generate a person."; {schemaFile: "/tmp/person.json"})
```

### Availability & quota

```4d
If (cs.fm.FM.me.available("system").available)
    var $usage : Object:=cs.fm.FM.me.quotaUsage("system").usage
End if
```

### Serve a Chat Completions API

```4d
var $server : cs.fm.FMResult:=cs.fm.FM.me.serve({host: "127.0.0.1"; port: 8080})
// POST /v1/chat/completions , GET /v1/models , GET /health
$server.worker.terminate()  // stop it
```

### Error handling

Synchronous calls return their value; inspect the result for failures, or set `throw: True` to raise them:

```4d
var $r : cs.fm.FMAvailableResult:=cs.fm.FM.me.available("system")
If (Not($r.success))
    ALERT($r.errorText)
End if

// or, to throw on failure:
cs.fm.FM.me.respond("hi"; {throw: True})
```

## API overview

| Function                          | Returns                                       | Notes                                  |
| --------------------------------- | --------------------------------------------- | -------------------------------------- |
| `respond(prompt; params)`         | `Text` (sync) / `FMRespondResult` (streaming) | Prompt sent on stdin.                  |
| `tokenCount(prompt; params)`      | `Integer`                                     | `system` model only.                   |
| `schema(params)`                  | `Object` (parsed JSON schema)                 |                                        |
| `available(model)`                | `FMAvailableResult`                           | `.available`                           |
| `quotaUsage(model)`               | `FMQuotaUsageResult`                          | `.usage`                               |
| `serve(params)`                   | `FMResult`                                     | Long‑running; `worker.terminate()`.    |
| `installed()`                     | `Boolean`                                     | macOS + `fm` on `PATH`.                |

Detailed per‑class reference lives in [`Documentation/Classes/`](Documentation/Classes/FM.md):
[FM](Documentation/Classes/FM.md) ·
[FMParameters](Documentation/Classes/FMParameters.md) ·
[FMRespondParameters](Documentation/Classes/FMRespondParameters.md) ·
[FMTokenCountParameters](Documentation/Classes/FMTokenCountParameters.md) ·
[FMSchemaParameters](Documentation/Classes/FMSchemaParameters.md) ·
[FMServeParameters](Documentation/Classes/FMServeParameters.md) ·
[FMResult](Documentation/Classes/FMResult.md) ·
[FMError](Documentation/Classes/FMError.md)

## How it works

Each call shells out to `fm` through a **`4D.SystemWorker`**:

- Arguments are built from a typed parameters object; the **prompt is written to stdin**, so prompt text needs no shell escaping.
- Synchronous calls `wait()` and parse the output (trimmed text, bare integer, or JSON).
- When callbacks are supplied, the call streams (`--stream`) and dispatches `onData` / `onResponse` / `onError` / `onTerminate` as the process runs.

## License

MIT.
