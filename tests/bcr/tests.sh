#!/usr/bin/env bash

set -xeEuo pipefail

grep -q '"FooFoo"' $(find . -name "bar.json")
grep -q '["Bar","FooFoo"]' $(find . -name "array.json")
grep -q '["Bar","FooFoo2"]' $(find . -name "array2.json")
grep -q "FooFoo2" $(find . -name "my_array.yaml")
