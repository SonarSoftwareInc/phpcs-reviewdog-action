#!/bin/sh

cd "$GITHUB_WORKSPACE"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

/usr/local/bin/phpcs.phar \
    --report=summary \
    --report-checkstyle=/tmp/phpcs_result_checkstyle.xml \
    ${INPUT_PHPCS_ARGS:-\.}

EXIT_CODE=$?

cat /tmp/phpcs_result_checkstyle.xml

< /tmp/phpcs_result_checkstyle.xml | reviewdog -f=checkstyle -name="phpcs" -reporter="${INPUT_REPORTER:-github-pr-check}"

exit $EXIT_CODE
