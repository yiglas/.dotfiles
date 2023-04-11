proxy () {
    export HTTP_PROXY=http://localhost:8080
    export HTTPS_PROXY=http://localhost:8080
    export NO_PROXY=localhost,127.0.0.1
}

unproxy () {
    unset HTTP_PROXY
    unset HTTPS_PROXY
}
