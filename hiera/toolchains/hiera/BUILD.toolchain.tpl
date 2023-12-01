package(default_visibility = ["//visibility:public"])

filegroup(
    name = "lookup",
    srcs = ["hiera/lookup_{version}"],
    visibility = ["//visibility:public"]
)
