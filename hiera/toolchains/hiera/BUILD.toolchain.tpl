package(default_visibility = ["//visibility:public"])

filegroup(
    name = "lookup_{os}_{arch}",
    srcs = ["hiera/lookup_v{version}_{os}_{arch}"],
    visibility = ["//visibility:public"]
)
