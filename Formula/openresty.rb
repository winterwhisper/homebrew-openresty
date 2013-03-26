require 'formula'

class Openresty < Formula
  homepage 'http://openresty.org'
  url 'http://openresty.org/download/ngx_openresty-1.2.6.6.tar.gz'
  sha1 '3098cbebc33cdc412c882e73d436d5b39bfeaaa5'

  depends_on 'pcre'
  depends_on 'luajit' => :optional

  option 'with-debug', 'Compile with support for debug log'

  # Changes default port to 8080 and configure the log paths inside the Homebrew prefix
  def patches
    DATA
  end

  def install
    args = ["--prefix=#{prefix}",
            "--sbin-path=#{sbin}/nginx",
            "--with-http_ssl_module",
            "--with-pcre",
            "--with-ipv6",
            "--with-cc-opt=-I#{HOMEBREW_PREFIX}/include",
            "--with-ld-opt=-L#{HOMEBREW_PREFIX}/lib",
            "--conf-path=#{etc}/nginx/nginx.conf",
            "--error-log-path=#{var}/log/nginx/error.log",
            "--pid-path=#{var}/run/nginx.pid",
            "--lock-path=#{var}/run/nginx.lock",
            "--http-client-body-temp-path=#{var}/run/nginx/client_body_temp",
            "--http-proxy-temp-path=#{var}/run/nginx/proxy_temp",
            "--http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp",
            "--http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp",
            "--http-scgi-temp-path=#{var}/run/nginx/scgi_temp"]

    args << "--with-debug" if build.include? 'with-debug'

    system "./configure", *args

    system "make install"

    # Make the log and run directory for nginx,
    # nginx.conf will point to this for the logs
    # sbin/nginx is compiled to use run/nginx for temp directories
    (var/'run/nginx').mkpath
    (var/'log/nginx').mkpath
  end

  test do
    system 'nginx', '-t'
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_prefix}/sbin/nginx</string>
            <string>-g</string>
            <string>daemon off;</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end

__END__
--- a/bundle/nginx-1.2.6/conf/nginx.conf
+++ b/bundle/nginx-1.2.6/conf/nginx.conf
@@ -2,7 +2,7 @@
 #user  nobody;
 worker_processes  1;
 
-#error_log  logs/error.log;
+error_log  HOMEBREW_PREFIX/var/log/nginx/host.error.log;
 #error_log  logs/error.log  notice;
 #error_log  logs/error.log  info;
 
@@ -33,12 +33,12 @@
     #gzip  on;
 
     server {
-        listen       80;
+        listen       8080;
         server_name  localhost;
 
         #charset koi8-r;
 
-        #access_log  logs/host.access.log  main;
+        access_log  HOMEBREW_PREFIX/var/log/nginx/host.access.log;
 
         location / {
             root   html;
