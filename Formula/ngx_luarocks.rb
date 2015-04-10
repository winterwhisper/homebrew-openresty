require 'formula'

class NgxLuarocks < Formula
  homepage 'https://rocks.moonscript.org/'

  stable do
    url 'http://keplerproject.github.io/luarocks/releases/luarocks-2.2.1.tar.gz'
    sha1 '82b858889e31ec0eb4d05ce7ea3a72fdf5403aad'
  end

  depends_on 'ngx_openresty'

  def install
    ngx_openresty = Formula['ngx_openresty']

    args = [
      "--prefix=#{prefix}",
      "--lua-version=5.1",
      "--lua-suffix=jit-2.1.0-alpha",
      "--with-lua=#{ngx_openresty.prefix}/luajit",
      "--with-lua-include=#{ngx_openresty.prefix}/luajit/include/luajit-2.1",
      "--with-lua-lib=#{ngx_openresty.prefix}/lualib"
    ]
    
    system "./configure", *args

    system "make build"
    system "make install"
  end
end

