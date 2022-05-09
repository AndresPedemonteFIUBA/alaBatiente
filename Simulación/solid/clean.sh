#!/bin/sh

error() {
    echo "Error: $1" >&2
    exit 1
}

clean_calculix() {
    (
        set -e -u
        cd "$1"
        echo "--- Cleaning up CalculiX case in $(pwd)"
        rm -fv ./*.cvg ./*.dat ./*.frd ./*.sta ./*.12d spooles.out dummy
        clean_precice_logs .
    )
}

clean_precice_logs() {
    (
        set -e -u
        cd "$1"
        echo "---- Cleaning up preCICE logs in $(pwd)"
        rm -fv ./precice-*-iterations.log \
            ./precice-*-convergence.log \
            ./precice-*-events.json \
            ./precice-*-events-summary.log \
            ./precice-postProcessingInfo.log \
            ./precice-*-watchpoint-*.log \
            ./precice-*-watchintegral-*.log \
            ./core
    )
}

clean_calculix .
