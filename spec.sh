#! /usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

##
# 🔬 Organization of the `spec.sh` file:
#
# (1) spec.loadConfigs - this searches for spec.config.sh
#                        files and sources them, allowing
#                        for complete customization of
#                        any and all `spec.sh` functionality
#
# (2) spec.main - this is only executed when `spec.sh` is
#                 called directly from the command-line
#
# (3) spec.runFile - this is executed safely in a subshell
#                    once for every file that is passed to
#                    `spec.sh` from the command-line
#
# (5) Spec Runner API - the functions that make up the rest
#                       of this file are considered the
#                       "Spec Runner API" and include all
#                       of the necessary code for loading
#                       spec files and executing them
#
# (5) bundled dependencies - when `spec-full.sh` is used all
#                            of the integrated libraries are
#                            included at the end of this file
##

SPEC_VERSION=0.5.0

spec.main() {
  # --version
  if [ $# -eq 1 ] && [ "$1" = "--version" ]
  then
    printf "spec.sh version " >&2
    printf "$SPEC_VERSION"
    return 0
  fi
}

[ "${0/*\/}" = "spec.sh" ] && spec.main "$@"