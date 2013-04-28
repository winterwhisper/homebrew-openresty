# OenResty Tap

Tap for Homebrew that add a formula for OpenResty.

## Install

    $ brew tap killercup/homebrew-openresty
    $ brew install ngx_openresty

## Optional Arguments

You might want to use LuaJIT for better performance and maybe also enable support Postgres:

    $ brew install ngx_openresty --with-postgres --with-luajit
