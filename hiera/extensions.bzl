load("@rules_hiera//hiera/toolchains/hiera:toolchain.bzl", "hiera_download")

def _repositories(ctx):
    for module in ctx.modules:
        for index, download_tag in enumerate(module.tags.download):
            if not module.is_root and not download_tag.version:
                fail("download: version must be specified in non-root module " + module.name)

            hiera_download(
                name = "hiera",
                version = download_tag.version,
                sha256 = download_tag.sha256,
                os = download_tag.os,
                arch = download_tag.arch,
            )


_download_tag = tag_class(
    attrs = {
        "version": attr.string(mandatory = True),
        "sha256": attr.string(mandatory = True),
        "os": attr.string(mandatory = True),
        "arch": attr.string(mandatory = True),
    },
)

repositories = module_extension(
    implementation = _repositories,
    tag_classes = {
        "download": _download_tag,
    },
)
