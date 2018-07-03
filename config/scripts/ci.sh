#!/bin/bash
# Setups any pre-build requirements upon circle CI

# Absolute environments path
ENVIRONMENTS_DIR="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )/../environments"

# Start the build
case "$CIRCLE_NODE_INDEX" in
  0)
    ENVIRONMENT=uk_integration ant ci
    ;;
esac
