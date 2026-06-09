# FMServeParameters

Parameters for `fm serve` (used by [FM](FM.md)`.serve()`). Start a Chat Completions API server over TCP (`host`/`port`) or a Unix domain socket (`socket`).

## Inherits

- [FMParameters](FMParameters.md)

## Properties

| Property | Type    | Default | Description                              |
| -------- | ------- | ------- | ---------------------------------------- |
| `host`   | Text    | `""`    | Host address to bind to (TCP mode).      |
| `port`   | Integer | `0`     | Port to listen on, 1‑65535 (TCP mode).   |
| `socket` | Text    | `""`    | Unix domain socket path (socket mode).   |

## Example

```4d
var $server : cs.fm.FMResult:=cs.fm.FM.me.serve({host: "127.0.0.1"; port: 8080})
// ... use the server ...
$server.worker.terminate()
```
