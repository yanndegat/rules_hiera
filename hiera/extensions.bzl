load("@rules_hiera//hiera/toolchains/hiera:toolchain.bzl", "hiera_download")
load("@rules_hiera//hiera:versions.bzl", "VERSIONS")

def _repositories(ctx):
    for module in ctx.modules:
        for version  in VERSIONS:
            if not module.is_root and not version:
                fail("download: version must be specified in non-root module " + module.name)

            hiera_download(
                name = "hiera_{}".format(version),
                version = VERSIONS[version]["version"],
                sha256 = VERSIONS[version]["sha256"],
                os = VERSIONS[version]["os"],
                arch = VERSIONS[version]["arch"],
            )


repositories = module_extension(
    implementation = _repositories,
)
