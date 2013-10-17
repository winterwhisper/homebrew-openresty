require 'formula'

class NgxOpenresty < Formula
  homepage 'http://openresty.org/'
  url 'http://openresty.org/download/ngx_openresty-1.4.2.9.tar.gz'
  sha1 'd6df036381e88125745475d686643f4bb9830974'

  depends_on 'pcre'
  depends_on 'luajit' => :recommended
  depends_on 'drizzle' => :optional
  depends_on 'postgresql' => :optional

  # openresty options
  option 'without-luajit', "Compile *without* support for the Lua Just-In-Time Compiler"
  option 'with-drizzle', "Compile with support for upstream communication with MySQL and/or Drizzle database servers"
  option 'with-postgresql', "Compile with support for direct communication with PostgreSQL database servers"
  option 'with-iconv', "Compile with support for converting character encodings"

  option 'with-debug', "Compile with support for debug logging and proper gdb debugging symbols"

  # nginx options
  option 'with-webdav', "Compile with ngx_http_dav_module"
  option 'with-gunzip', "Compile with ngx_http_gunzip_module"

  skip_clean 'logs'

  def install
    args = ["--prefix=#{prefix}",
      "--with-http_ssl_module",
      "--with-pcre",
      "--with-pcre-jit",
      "--sbin-path=#{bin}/openresty",
      "--conf-path=#{etc}/openresty/nginx.conf",
      "--pid-path=#{var}/run/openresty.pid",
      "--lock-path=#{var}/openresty/nginx.lock"
    ]

    args << "--with-http_dav_module" if build.with? 'webdav'
    args << "--with-http_gunzip_module" if build.with? 'gunzip'

    # Debugging mode (with proper debugging symbols)
    if build.with? 'debug'
      args << '--with-debug'
      opoo "Openresty will be built --with-debug option, but without debugging symbols. For debugging symbols you have to compile it by hand."
    end

    # OpenResty options
    args << "--with-luajit" unless build.without? 'luajit'

    args << "--with-http_drizzle_module" if build.with? 'drizzle'
    args << "--with-http_postgres_module" if build.with? 'postgres'
    args << "--with-http_iconv_module" if build.with? 'iconv'

    system "./configure", *args

    system "make"
    system "make install"
  end
end
