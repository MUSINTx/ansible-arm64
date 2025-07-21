#!/bin/bash

# If command is passed, execute it
if [ $# -gt 0 ]; then
    exec "$@"
else
    # Default to ansible version if no command provided
    exec ansible --version
fi