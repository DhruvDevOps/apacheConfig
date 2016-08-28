class apache::install ($version) {
$httpd_dir='/usr/local/apache'
$ipaddress_eth0=$::ipaddress_eth0
exec { "wget http://apache.mirrors.tds.net//httpd/httpd-${version}.tar.gz":
                                path   => "/usr/bin:/usr/sbin:/bin",
                                command => "wget http://10.32.10.25/tarball/httpd-${version}.tar.gz -O /usr/local/apache/softwares/httpd-${version}.tar.gz",
								user 	=> "apache",
								group	=> "staff",
                                cwd       => "/usr/local/apache/softwares",
                                creates   => "/usr/local/apache/softwares/httpd-${version}.tar.gz",
                                alias => "download-httpd"
                                }
exec { "tar xzf httpd-${version}.tar.gz":
                                path   => "/usr/bin:/usr/sbin:/bin",
                                command => "tar -xvf httpd-${version}.tar.gz",
								user 	=> "apache",
								group	=> "staff",
                cwd       => "/usr/local/apache/softwares",
                creates   => "/usr/local/apache/softwares/httpd-${version}",
                alias     => "untar-httpd",
		require => Exec["download-httpd"]
            }
exec { "./configure -C  --prefix=/usr/local/apache   --with-mpm=worker  --enable-suexec --with-suexec  --enable-cache --enable-disk-cache --enable-mem-cache  --enable-deflate --enable-cgid  --enable-proxy --enable-proxy-connect   --enable-proxy-http --enable-proxy-ftp --enable-mod_jk  --with-mod_jk --enable-ssl --with-ssl=/usr/local/ssl ":
                path   => "/usr/bin:/usr/sbin:/bin",
                cwd     => "/usr/local/apache/softwares/httpd-${version}",
				user 	=> "apache",
				group	=> "staff",
                command => "/usr/local/apache/softwares/httpd-${version}/configure -C  --prefix=/usr/local/apache   --with-mpm=worker  --enable-suexec --with-suexec  --enable-cache --enable-disk-cache --enable-mem-cache  --enable-deflate --enable-cgid  --enable-proxy --enable-proxy-connect   --enable-proxy-http --enable-proxy-ftp --enable-mod_jk  --with-mod_jk --enable-ssl --with-ssl=/usr/local/apache/ssl ",
                require => Exec["untar-httpd"],
                #before  => Exec["make"],
                alias => "./configure"
            }
            exec { "make && make install":
            path   => "/usr/bin:/usr/sbin:/bin",
			user 	=> "apache",
			group	=> "staff",
            cwd     => "/usr/local/apache/softwares/httpd-${version}",
            alias   => "make",
            require => Exec["./configure"]
            }
package { 'httpd':
			require => Exec["make"]
			}
			

file { "/usr/local/apache/conf/httpd.conf":
ensure => file,
owner => "apache",
content => template('apache/httpd.conf.erb'),
require => Package['httpd']
}
file { "$httpd_dir/bin/${apachectl}":
ensure => file,
source => "puppet:///modules/apache/${apachectl}",
owner => "apache",
group => "staff",
mode => "0755"
}


$path = 'apache/httpd.conf.erb'
$path1 = 'apache/httpd-ssl.conf.erb'


file { "$httpd_dir/htdocs/test_page.html":
ensure => file,
content => puppet:///modules/apache/test_page.ht,
owner => "apache",
group => "staff",
require => Exec["${name}"]
}

file { "$httpd_dir/${conf}/extra/httpd-ssl.conf":
ensure => file,
content => template("${path1}"),
owner => "apache",
group => "staff",
require => File["$httpd_dir/${conf}/httpd.conf"]
}
}

