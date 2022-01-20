#!/bin/bash
set -e

PROJECT_PATH="${1:-.}"
PROJECT_COVERAGE=./coverage/lcov.info

cd ${PROJECT_PATH}

rm -rf coverage
if grep -q "flutter:" pubspec.yaml; then
    flutter --version
    flutter test --no-pub --test-randomize-ordering-seed random --coverage -j 28
else
    dart --version
    dart test --coverage=coverage && pub run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib
fi
lcov --remove ${PROJECT_COVERAGE} -o ${PROJECT_COVERAGE} \
    '**/l10n/*.dart' \
    '**/l10n/**/*.dart'
genhtml ${PROJECT_COVERAGE} -o coverage
open ./coverage/index.html
