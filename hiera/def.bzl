load("@rules_pkg//pkg:pkg.bzl", "pkg_tar")
load("@rules_pkg//pkg:mappings.bzl", "pkg_files", "pkg_filegroup", "strip_prefix")
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
    visibility = ["//visibility:public"],
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
        visibility = visibility,
    )

def hiera_tar(name, hieradata, base = None, prefix = "hieradata", visibility= ["//visibility:public"]):
    pkg_files(
        name = "hiera-{}".format(name),
        srcs = [hieradata],
        prefix = prefix,
        strip_prefix = strip_prefix.from_pkg(),
    )

    if base != None:
        pkg_files(
            name = "hiera-base-{}".format(name),
            srcs = [base],
            prefix = prefix,
            strip_prefix = strip_prefix.from_pkg(),
        )

        pkg_filegroup(
            name = "hiera-files-{}".format(name),
            srcs = [":hiera-base-{}".format(name), ":hiera-{}".format(name)],
        )
    else:
        pkg_filegroup(
            name = "hiera-files-{}".format(name),
            srcs = [":hiera-{}".format(name)],
        )

    pkg_tar(
        name = name,
        srcs = [":hiera-files-{}".format(name)],
        visibility= visibility,
    )
