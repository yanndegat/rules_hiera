HieraInfo = provider(
    doc = "Information about how to invoke Hiera.",
    fields = ["lookup"],
)

def _hiera_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        runtime = HieraInfo(
            lookup = ctx.file.lookup,
        ),
    )
    return [toolchain_info]

hiera_toolchain = rule(
    implementation = _hiera_toolchain_impl,
    attrs = {
        "lookup": attr.label(
            mandatory = True,
            allow_single_file = True,
            executable = True,
            cfg = "target",
        ),
    },
)

def register_hiera_toolchain(visibility):
    toolchain_typename = "toolchain_type"
    native.toolchain_type(
        name = toolchain_typename,
        visibility = visibility,
    )

    name = "linux_amd64"
    toolchain_name = "{}_toolchain".format(name)

    hiera_toolchain(
        name = "{}_impl".format(name),
        lookup = "@hiera//:lookup",
    )

    native.toolchain(
        name = toolchain_name,
        exec_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        target_compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        toolchain = ":{}_impl".format(name),
        toolchain_type = ":{}".format(toolchain_typename),
        visibility = visibility,
    )


def _download_impl(ctx):
    ctx.report_progress("Downloading hiera")

    ctx.template(
        "BUILD",
        Label("@rules_hiera//hiera/toolchains/hiera:BUILD.toolchain.tpl"),
        executable = False,
        substitutions = {
            "{version}": ctx.attr.version,
        },
    )

    url_template = "https://github.com/yanndegat/hiera/releases/download/v{version}/hiera_{version}_{os}_{arch}.tar.gz"
    url = url_template.format(version = ctx.attr.version, os = ctx.attr.os, arch = ctx.attr.arch)

    if not ctx.download_and_extract(
        url = url,
        sha256 = ctx.attr.sha256,
        output = "hiera",
     ):
        fail("could not dl toolchain")
    else:
        print("successfully dl tool")

    return {
        "version": ctx.attr.version,
        "sha256": ctx.attr.sha256,
        "os": ctx.attr.os,
        "arch": ctx.attr.arch,
        "name": ctx.attr.name,
    }

hiera_download = repository_rule(
    implementation = _download_impl,
    attrs = {
        "version": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "os": attr.string(mandatory = True),
        "arch": attr.string(mandatory = True),
    },
)
