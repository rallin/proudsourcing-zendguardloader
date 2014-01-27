class ps_zendguardloader (

	$apache_modules_dir	= $ps_zendguardloader::params::apache_modules_dir,
	$apache_php_dir		= $ps_zendguardloader::params::apache_php_dir,

) inherits ps_zendguardloader::params {

	file { "${apache_modules_dir}":
		ensure => 'directory',
		mode => 755,
		owner => 'root',
	}
	
	file { "${apache_modules_dir}ZendGuardLoader-php-5.3-linux-glibc23-x86_64.so":
		ensure => present,
	    source => "puppet:///modules/ps_zendguardloader/ZendGuardLoader-php-5.3-linux-glibc23-x86_64.so",
	    subscribe => File["${apache_modules_dir}"]
	}
	
	file { "${apache_php_dir}conf.d/ps_zendguardloader.ini":
		ensure => present,
	    content => template("ps_zendguardloader/ps_zendguardloader.ini.erb"),
	    subscribe => File["${apache_modules_dir}ZendGuardLoader-php-5.3-linux-glibc23-x86_64.so"]
	}
	
	exec { "apache_restart-zgl":
    	command => "/etc/init.d/apache2 reload",
		refreshonly => true,
    	subscribe => File["${apache_php_dir}conf.d/ps_zendguardloader.ini"],
	}

}
