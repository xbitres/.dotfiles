function textformat2json() {
    sed 's/$/,/' | sed 's/{,$/{/' | sed 's/^ *\([A-z0-9]*\)[ |:]/"\1":/' | sed 's/""://' | sed 's/\(.\+:\) \([A-z]*\)/\1"\2"/' | sed 's/:""/:/' | tr -d '$\n' | sed 's/^\(.*$\)/\{\1}/' | sed 's/,}/}/g'
}

function protod() {
    if [ "$#" -gt 1 ]; then
        base64urldecode.go "$2" | protoc \
            -I "$WORKSPACE/golang/src/FIXE_ME" \
            --decode "$1" | textformat2json
    else
        base64urldecode.go "$1" /dev/stdin | protoc --decode_raw
    fi
}
