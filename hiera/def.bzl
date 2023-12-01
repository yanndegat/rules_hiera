load("@rules_hiera//hiera/rules:lookup.bzl", _hiera_lookup = "hiera_lookup")

BZL_FILES = [
    "**/*.bazel",
    "**/WORKSPACE*",
    "**/BUILD",
]

def hiera_lookup(
    name,
    keys,
    hieradata,
    config = "hiera.yaml",
    vars = {},
    render_as = "yaml", defaut = None,
    merge = "first",
    tags = None):

    _hiera_lookup(
        name = name,
        keys  = keys,
        hieradata = hieradata,
        config = config,
        vars = vars,
        render_as = render_as,
        merge = merge,
        tags = tags,
        visibility = ["//visibility:public"],
    )
