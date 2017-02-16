#!/bin/sh
. ${BUILDPACK_HOME}/test/helper.sh

# Use the develop branch (0.11.0-SNAPSHOT) as of February 16, 2017,
# until the "stateless build" feature is available in a release.
export PREDICTIONIO_DIST_URL="https://marsikai.s3.amazonaws.com/PredictionIO-0.11.0-cb14625.tar.gz"

test_engine_classification_4_0_0() {
  ENGINE_FIXTURE_DIR="$BUILDPACK_HOME/test/fixtures/predictionio-engine-classification-4.0.0"
  cp -r $ENGINE_FIXTURE_DIR/* $ENGINE_FIXTURE_DIR/.[!.]* $BUILD_DIR

  compile

  assertEquals "Expected captured exit code to be 0; was <${RETURN}>" "0" "${RETURN}"
  assertTrue "missing Procfile" "[ -f $BUILD_DIR/Procfile ]"
  assertTrue "missing PostgreSQL driver" "[ -f $BUILD_DIR/lib/postgresql_jdbc.jar ]"
  assertTrue "missing runtime memory config" "[ -f $BUILD_DIR/.profile.d/pio-memory.sh ]"
  assertTrue "missing runtime path config" "[ -f $BUILD_DIR/.profile.d/pio-path.sh ]"
  assertTrue "missing runtime config renderer" "[ -f $BUILD_DIR/.profile.d/pio-render-configs.sh ]"
  assertTrue "missing web executable" "[ -f $BUILD_DIR/bin/heroku-buildpack-pio-web ]"
  assertTrue "missing train executable" "[ -f $BUILD_DIR/bin/heroku-buildpack-pio-train ]"
  assertTrue "missing release executable" "[ -f $BUILD_DIR/bin/heroku-buildpack-pio-release ]"
  assertTrue "missing data loader executable" "[ -f $BUILD_DIR/bin/heroku-buildpack-pio-load-data ]"

  expected_output="$BUILD_DIR/pio-engine/target/scala-2.10/template-scala-parallel-classification-assembly-0.1-SNAPSHOT-deps.jar"
  assertTrue "missing Scala build output: $expected_output" "[ -f $expected_output ]"

  # echo "Stage build at runtime path /app"
  # mv $BUILD_DIR/* $BUILD_DIR/.[!.]* /app/

  # echo "Execute pio commands"
  # cd /app/pio-engine
  # ./PredictionIO-dist/bin/pio status
}