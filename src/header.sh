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
# (1) spec.load.configs - this searches for spec.config.sh
#                         files and sources them, allowing
#                         for complete customization of
#                         any and all `spec.sh` functionality
#
# (2) spec.main - this is only executed when `spec.sh` is
#                 called directly from the command-line
#
# (3) spec.run.specFile - this is executed safely in a subshell
#                         once for every file that is passed to
#                         `spec.sh` from the command-line
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
#
# Note: you'll notice that every function has two versions:
#
# - spec.[fn]        This is the public API and these functions
#                    are called for all `spec.sh` behavior
#
# - ___spec___.[fn]  This is the default implementation of the
#                    given public API function. This allows for
#                    literally any `spec.sh` function to be
#                    overriden. To override a function, in your
#                    spec.config.sh file specify a function
#                    with the name `spec.[something]`. If you
#                    want to invoke the default implementation in
#                    your function, call `___spec___.[something]`.
#
#                    This is similar to calling 'super' or 'base'
#                    in many popular programming languages.
#
# The only function that cannot be overriden is: spec.load.configs
#
# Conventionally, there are 3 types of functions:
#
# - spec.load.[fn]    These should load data into SPEC_* arrays
#                     for usage by other functions and should not
#                     run or source anything on their own
#                     
# - spec.run.[fn]     These should not load anything but instead
#                     should read existing variables or arguments
#                     and execute files or functions
#
# - spec.display.[fn] These should only output to STDERR/STDOUT
#                     and should not themselves load or run anything
#
# The only exception to this is spec.main which represents the
# main entrypoint for running `spec.sh`
##
