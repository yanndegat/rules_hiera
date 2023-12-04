# Hiera lookup Rule

The hiera rules are useful to encrypt files using hiera.

## Getting Started

To import rules_hiera in your project, you first need to add it to your `MODULE.bazel` file:

```python
bazel_dep(name = "rules_hiera", version = "0.0.1")
git_override(
    module_name = "rules_hiera",
    remote      = "https://github.com/yanndegat/rules_hiera",
    commit      = "9f44cd6b0fc36e552d274d6fcfd5c3bfad4efce6",
)
```

Once you've imported the rule set , you can then load the tf rules in your `BUILD` files with:

```python
load("@rules_hiera//hiera:def.bzl", "hiera_lookup")

# will generate json file with lookup values
hiera_lookup(
    name = "bar",
    keys = ["bar"],
    hieradata = "//hieradata",
    merge     = "deep",
    render_as = "json",
    vars = {
        "scope": "test",
    },
)
```
