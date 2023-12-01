load("@rules_hiera//hiera/toolchains/hiera:toolchain.bzl", "register_hiera_toolchain")

def register_toolchains():
    register_hiera_toolchain(visibility = ["//visibility:public"])
