def _lookup_impl(ctx):
    render_as = ctx.attr.render_as
    merge = ctx.attr.merge
    if render_as != "yaml" and render_as != "json" and render_as != "text":
        fail("lookup render_as must be one of text, yaml or json, was {}".format(ctx.attr.render_as))

    if render_as == "text":
        render_as = "s"

    if merge != "first" and merge != "unique" and merge != "hash" and merge != "deep":
        fail("lookup merge must be one of first, unique, hash or deep")

    config_path = ""

    if len(ctx.files.hieradata) == 0:
        fail("missing hieradata files")

    tar_mode = False
    if len(ctx.files.hieradata) == 1:
        tar_mode = True
        config_path = ctx.attr.config
    else:
        for f in ctx.files.hieradata:
            if f.basename == ctx.attr.config:
                config_path = f.short_path

    if config_path == "":
        fail("Missing config file {} in hieradata files".format(ctx.attr.config))

    opts = {
        "--render-as": render_as,
        "--merge": merge,
        "--config" : config_path,
    }

    if ctx.attr.default != None and ctx.attr.default != "":
        opts["--default"] = ctx.attr.default

    out_filename = ctx.attr.out

    if out_filename == None or out_filename == "":
        out_filename = "{}.{}".format(ctx.attr.name, ctx.attr.render_as)

    out = ctx.actions.declare_file(out_filename)

    if tar_mode:
        # hack 1: it mandatory to untar the hieradata archive in a tmpdir to avoid collisions when running multiple lookups in parallel
        # hack 2: under darwin, it's hard to generate a tmpdir in another directory than _CS_DARWIN_USER_TEMP_DIR. we use basename $(mktemp) hack
        #         to have something useable under linux and macos
        command = "mkdir -p $(dirname {out}); UNTARDIR=$(basename $(mktemp)); mkdir -p $UNTARDIR && cd $UNTARDIR && tar -xf ../{tar_file} && [[ -f {config} ]] && (../{lookup} {keys} {vars} {opts} > '../{out}') || echo ERROR: missing config file {config} >&2"
    else:
        command = "mkdir -p $(dirname {out}); [[ -f {config} ]] && ({lookup} {keys} {vars} {opts} > '{out}') || echo ERROR: missing config file {config} >&2"

    ctx.actions.run_shell(
        inputs  = ctx.files.hieradata,
        outputs = [out],
        tools   = [ctx.toolchains["@rules_hiera//:toolchain_type"].runtime.lookup],
        command = command.format(
            lookup = ctx.toolchains["@rules_hiera//:toolchain_type"].runtime.lookup.path,
            vars = " ".join(["--var {}={}".format(k, ctx.attr.vars[k]) for k in ctx.attr.vars]),
            opts = " ".join(["{}={}".format(k, opts[k]) for k in opts]),
            keys = " ".join(ctx.attr.keys),
            config = config_path,
            out = out.path,
            tar_file = ctx.files.hieradata[0].path,
        )
    )

    return [
        DefaultInfo(
            files = depset([out]),
        ),
    ]

hiera_lookup = rule(
    implementation = _lookup_impl,
    attrs = {
        "hieradata": attr.label(
            allow_files = True,
            mandatory = True,
        ),
        "config": attr.string(
            mandatory = False,
            default   = "hiera.yaml"
        ),
        "keys": attr.string_list(
            mandatory = True,
        ),
        "out": attr.string(),
        "render_as": attr.string(
            mandatory = True,
            default   = "yaml",
        ),
        "default": attr.string(),
        "merge": attr.string(
            mandatory = True,
            default   = "first",
        ),
        "vars": attr.string_dict( default = {}),
    },
    toolchains = ["@rules_hiera//:toolchain_type"],
)
