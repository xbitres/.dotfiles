///bin/echo &>/dev/null; exec /usr/bin/env go run "$0" "$@"
package main

import (
    "encoding/base64"
    "os"
)

func main() {
    out, err := base64.URLEncoding.DecodeString(os.Args[1])
    if err != nil {
        panic(err)
    }
    _, err = os.Stdout.Write(out)
    if err != nil {
        panic(err)
    }
}
