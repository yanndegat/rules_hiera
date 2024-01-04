load("@rules_hiera//hiera/toolchains/hiera:toolchain.bzl", "hiera_toolchain")
load("@rules_hiera//hiera:versions.bzl", "VERSIONS")

def register_toolchains():
    toolchain_typename = "toolchain_type"

    native.toolchain_type(
        name = toolchain_typename,
        visibility = ["//visibility:public"],
    )

    for version in VERSIONS:
        toolchain_name = "{}_toolchain".format(version)
        hiera_toolchain(
            name = "{}_impl".format(version),
            lookup = "@hiera_{}//:lookup_{}".format(version, version),
        )

        native.toolchain(
            name = toolchain_name,
            exec_compatible_with = VERSIONS[version]["exec_compatible_with"],
            target_compatible_with = VERSIONS[version]["exec_compatible_with"],
            toolchain = ":{}_impl".format(version),
            toolchain_type = ":{}".format(toolchain_typename),
            visibility = ["//visibility:public"],
        )
