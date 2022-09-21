#!/bin/bash

function convert() {
    local crlf data

    data=$(find . -path ./.git -prune -o -type f -print)
    for item in ${data[@]}; do
        if [[ "$(file ${item})" != *"text"* ]]; then
            continue
        fi

        if grep -q $'\r' ${item}; then
            crlf=":crlf"
        fi
        perl -we 'binmode STDIN,  ":encoding(Shift-JIS)'"${crlf}"'";
              binmode STDOUT, ":encoding(UTF-8)";
              print while <STDIN>;
            ' <${item} | tee "${item}_n" &>/dev/null
        mv "${item}_n" "${item}"
    done
}

convert
