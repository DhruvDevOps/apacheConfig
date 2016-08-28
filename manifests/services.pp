define apache::services ($apachectl, $httpd_ver)
{
service { $httpd_ver:
   ensure => running,
    #name   => httpd,
    enable => true,
    start   => "/usr/local/apache/bin/${apachectl} start",
    stop    => "/usr/local/apache/bin/${apachectl} stop",
    pattern => "/usr/local/apache/bin/httpd",
  } 
  }
