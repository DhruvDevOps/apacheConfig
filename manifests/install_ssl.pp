class apache::install_ssl($sslversion) {
exec { "wget https://www.openssl.org/source/openssl-0.9.8e.tar.gz":
                                path   => "/usr/bin:/usr/sbin:/bin",
								user 	=> "apache",
								group	=> "staff",
                                command => "wget http://10.32.10.25/tarball/${sslversion}.tar.gz -O /usr/local/apache/softwares/${sslversion}.tar.gz",
                                cwd       => "/usr/local/apache/softwares",
                                creates   => "/usr/local/apache/softwares/${sslversion}.tar.gz",
                                alias => "wget-httpd"
                                }
exec { "tar xzf ${sslversion}.tar.gz":
                                path   => "/usr/bin:/usr/sbin:/bin",
                                command => "tar -zxf ${sslversion}.tar.gz",
								user 	=> "apache",
								group	=> "staff",
                cwd       => "/usr/local/apache/softwares",
                creates   => "/usr/local/apache/softwares/${sslversion}",
                alias     => "untar-openssl-source",
				require   => Exec["wget-httpd"]
            }
exec { "./configure ":
                path   => "/usr/bin:/usr/sbin:/bin",
				user 	=> "apache",
				group	=> "staff",
                cwd     => "/usr/local/apache/softwares/${sslversion}",
                command => "/usr/local/apache/softwares/${sslversion}/config --prefix=/usr/local/apache",
                require => Exec[untar-openssl-source],
                before  => Exec["make install"],
                alias => "Compile"
            }
            exec { "install":
            path   => "/usr/bin:/usr/sbin:/bin",
			user 	=> "apache",
				group	=> "staff",
	    command => "make && make install",
            cwd     => "/usr/local/apache/softwares/${sslversion}",
            alias   => "make install",
            require => Exec["Compile"]
            }

}

