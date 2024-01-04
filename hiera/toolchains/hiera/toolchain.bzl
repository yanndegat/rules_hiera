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

def _download_impl(ctx):
    ctx.report_progress("Downloading hiera")

    ctx.template(
        "BUILD",
        Label("@rules_hiera//hiera/toolchains/hiera:BUILD.toolchain.tpl"),
        executable = False,
        substitutions = {
            "{version}": ctx.attr.version,
            "{os}": ctx.attr.os,
            "{arch}": ctx.attr.arch,
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
