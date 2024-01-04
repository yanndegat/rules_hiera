VERSIONS = {
    "linux_amd64":{
        "version": "0.6.8",
        "sha256": "724f9681a73fc8d839e375efbe515ebc0868957e86a3ec5bff520efc29c98305",
        "os" : "linux",
        "arch": "amd64",
        "exec_compatible_with": [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        "target_compatible_with" : [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
    },
    "linux_arm64":{
        "sha256": "35c5b86330d0665b2b2a09c515f5bece9750f1c529665a4d967bbc9af312ac5c",
        "version": "0.6.8",
        "os" : "linux",
        "arch": "amd64",
        "exec_compatible_with": [
            "@platforms//os:linux",
            "@platforms//cpu:arm64",
        ],
        "target_compatible_with" : [
            "@platforms//os:linux",
            "@platforms//cpu:arm64",
        ],
    },
    "darwin_amd64":{
        "version": "0.6.8",
        "sha256": "a321b957c23c46a00ca970086f0b0bf60e242f377b384fe52fb670326d704551",
        "os" : "darwin",
        "arch": "amd64",
        "exec_compatible_with": [
            "@platforms//os:osx",
            "@platforms//cpu:x86_64",
        ],
        "target_compatible_with" : [
            "@platforms//os:osx",
            "@platforms//cpu:x86_64",
        ],
    },
    "darwin_arm64":{
        "version": "0.6.8",
        "sha256": "34be9cc84bf091628a9bd1943ee50158cf83e5ba410fa442f40e041da431703a",
        "os" : "darwin",
        "arch": "arm64",
        "exec_compatible_with": [
            "@platforms//os:osx",
            "@platforms//cpu:aarch64",
        ],
        "target_compatible_with" : [
            "@platforms//os:osx",
            "@platforms//cpu:aarch64",
        ],
    },
}
