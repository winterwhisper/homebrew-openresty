require 'formula'

class NgxOpenresty < Formula
  homepage 'http://openresty.org/'
  url 'http://openresty.org/download/ngx_openresty-1.2.8.6.tar.gz'
  sha1 '4b47862a77577d06447d17c935e94dc935c279e5'

  depends_on 'pcre'
  depends_on 'luajit' unless build.include? 'without-luajit'
  depends_on 'libdrizzle' if build.include? 'with-drizzle'
  depends_on 'postgresql' if build.include? 'with-postgres'

  option 'without-luajit', "Compile *without* support for the Lua Just-In-Time Compiler"
  option 'with-drizzle', "Compile with support for upstream communication with MySQL and/or Drizzle database servers"
  option 'with-postgres', "Compile with support for direct communication with PostgreSQL database servers"
  option 'with-iconv', "Compile with support for converting character encodings"
  option 'without-debug', "Compile *without* support for debug logging"

  skip_clean 'logs'

  def install
    args = ["--prefix=#{prefix}",
      "--with-http_ssl_module",
      "--with-pcre",
      "--with-pcre-jit",
      "--with-cc-opt='-I#{HOMEBREW_PREFIX}/include'",
      "--with-ld-opt='-L#{HOMEBREW_PREFIX}/lib'",
      "--sbin-path=#{bin}/openresty",
      "--conf-path=#{etc}/openresty/nginx.conf",
      "--pid-path=#{var}/run/openresty.pid",
      "--lock-path=#{var}/openresty/nginx.lock"
    ]

    args << "--with-http_dav_module" if build.include? 'with-webdav'
    args << "--with-debug" unless build.include? 'without-debug'

    # OpenResty options
    args << "--with-luajit" unless build.include? 'without-luajit'
    args << "--with-http_drizzle_module" if build.include? 'with-drizzle'
    args << "--with-http_postgres_module" if build.include? 'with-postgres'
    args << "--with-http_iconv_module" if build.include? 'with-iconv'

    system "./configure", *args
    system "make"
    system "make install"
  end
end
