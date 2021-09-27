#!/usr/bin/env sh

case "${1}" in
    "api")
        shift
        echo "Starting API ..." && \
        exec uvicorn main:app --reload --host 0.0.0.0 --port 8080 --log-level=info
        ;;

    "pytest")
        shift
        echo "Tests"
        exec pytest ${@}
        ;;

    "help")
        shift
        exec echo "Set command: api pytest"
        ;;

    *)
        exec ${@}
        ;;
esac
