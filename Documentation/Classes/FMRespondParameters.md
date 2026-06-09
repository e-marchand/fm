# FMRespondParameters

Parameters for `fm respond` (used by [FM](FM.md)`.respond()`). The prompt itself is passed on **stdin**, never as an argument, so it needs no escaping.

## Inherits

- [FMParameters](FMParameters.md)

## Properties

| Property         | Type       | Default | Description                                                                 |
| ---------------- | ---------- | ------- | --------------------------------------------------------------------------- |
| `instructions`   | Text       | `""`    | Instructions for the model to follow (system prompt).                       |
| `schemaFile`     | Text       | `""`    | Path to a JSON schema file constraining the output (guided generation).     |
| `text`           | Collection | `Null`  | Additional text segments to include in the prompt (repeatable).             |
| `image`          | Collection | `Null`  | Image file paths to include in the prompt (repeatable).                     |
| `loadTranscript` | Text       | `""`    | Path to a saved transcript to seed the conversation.                        |
| `saveTranscript` | Text       | `""`    | Name under which to save the transcript after responding.                   |
| `stream`         | Boolean    | `False` | Stream output as it is generated. Set automatically when callbacks are given.|
| `greedy`         | Boolean    | `False` | Use greedy (deterministic) sampling.                                        |
| `verbose`        | Boolean    | `False` | Print verbose output.                                                        |
| `useCase`        | Text       | `""`    | System model use case: `"general"` (default) or `"content-tagging"`.        |
| `guardrails`     | Text       | `""`    | Guardrail level: `"default"` or `"permissive-content-transformations"`.     |

See [FMParameters](FMParameters.md) for `model`, `timeout`, `throw` and the callback properties.

## Example

```4d
var $answer : Text:=cs.fm.FM.me.respond("What is in this image?"; {\
    instructions: "Describe briefly."; \
    image: ["/path/to/photo.jpg"]; \
    greedy: True\
})
```
