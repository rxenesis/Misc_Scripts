#!/bin/bash

get_download_url() {
    local repo="$1"
    local plus_name="$2"
    local ext_name="$3"

    local release_url="https://api.github.com/repos/$repo/releases/latest"
    local name_part="$(curl -sSL $release_url | jq -r .name | tr ' ' '-')"

   
    if [ -z "$plus_name" ]; then
        local pkg_fname="$name_part.$ext_name"
    else
        local pkg_fname="$name_part-$plus_name.$ext_name"
    fi

    curl -sSL "$release_url" | jq -r --arg pkg_fname "$pkg_fname" '.assets[] | select(.name == $pkg_fname).browser_download_url'
}
