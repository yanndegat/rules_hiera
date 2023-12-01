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
    for f in ctx.files.hieradata:
        if f.basename == ctx.attr.config:
            config_path = f.path

    if config_path == None:
        fail("Missing config file {} in hieradata files".format(ctx.attr.config))


    opts = {
        "--render-as": render_as,
        "--merge": merge,
        "--config" : config_path,
    }

    if ctx.attr.default != None and ctx.attr.default != "":
        opts["--default"] = ctx.attr.default

    out = ctx.actions.declare_file("{}.{}".format(ctx.attr.name, ctx.attr.render_as))


    ctx.actions.run_shell(
        inputs  = ctx.files.hieradata,
        outputs = [out],
        tools   = [ctx.toolchains["@rules_hiera//:toolchain_type"].runtime.lookup],
        command = "{lookup} {keys} {vars} {opts} > '{out}'".format(
            lookup = ctx.toolchains["@rules_hiera//:toolchain_type"].runtime.lookup.path,
            vars = " ".join(["--var {}={}".format(k, ctx.attr.vars[k]) for k in ctx.attr.vars]),
            opts = " ".join(["{}={}".format(k, opts[k]) for k in opts]),
            keys = " ".join(ctx.attr.keys),
            out = out.path,
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
