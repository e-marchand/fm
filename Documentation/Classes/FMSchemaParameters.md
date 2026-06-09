# FMSchemaParameters

Parameters for `fm schema object` (used by [FM](FM.md)`.schema()`). Describes a root object type and its properties.

## Inherits

- [FMParameters](FMParameters.md)

## Properties

| Property     | Type       | Default | Description                                                |
| ------------ | ---------- | ------- | ---------------------------------------------------------- |
| `name`       | Text       | `""`    | Name of the root object type (required).                   |
| `properties` | Collection | `[]`    | Property declarations (see below).                         |

Each item of `properties` is an object:

| Key           | Type    | Description                                                    |
| ------------- | ------- | ------------------------------------------------------------- |
| `name`        | Text    | Property name.                                                 |
| `type`        | Text    | `"string"`, `"integer"`, `"double"`, or `"boolean"`.          |
| `array`       | Boolean | Mark the property as an array of that type.                    |
| `optional`    | Boolean | Mark the property as optional (not in `required`).            |
| `description` | Text    | Optional description.                                          |

## Example

```4d
var $schema : Object:=cs.fm.FM.me.schema({name: "Contact"; properties: [\
    {name: "name"; type: "string"; description: "Full name"}; \
    {name: "age"; type: "integer"}; \
    {name: "tags"; type: "string"; array: True}; \
    {name: "nickname"; type: "string"; optional: True}\
]})
```
