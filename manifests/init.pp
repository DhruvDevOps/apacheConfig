class apache($apache_version = '2.2.29', $ssl_version = 'openssl-0.9.8e')
{
user { 'apache':
      ensure  => present,
      gid     => 'staff',
	  home	  => $dir
    }
group { 'staff':
      ensure  => present
    }

file { "/usr/local/apache":
ensure => directory,
path => "/usr/local/apache",
owner => "apache",
group => "staff"
}
 
class{ 'apache::install_ssl' :
version => "${ssl_version}",
}
class{ 'apache::install' :
version => "${apache_version}",
require => Class['apache::install_ssl'],
}
apache::services { 'instance' :
apachectl => 'apachectl',
httpd_ver => 'httpd';
}

