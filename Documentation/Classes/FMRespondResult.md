# FMRespondResult

Result of `fm respond`. Returned by [FM](FM.md)`.respond()` in asynchronous mode (and passed to streaming callbacks).

## Inherits

- [FMResult](FMResult.md)

The generated text is available through the inherited `text` property — the full response once terminated, or the current chunk inside an `onData` callback.

## Example

```4d
var $r : cs.fm.FMRespondResult:=cs.fm.FM.me.respond("Write a haiku"; {onData: Formula(MyOnData($1))})
$r.worker.wait()
// $r.text -> full response
```
