#!/bin/sh
source ../header.sh
source ./version.sh

dependencies() {
	yum -y install libxml2 libxml2-devel
	yum -y install openssl openssl-devel
	yum -y install bzip2  bzip2-devel
	yum -y install libcurl-devel 
	yum -y install gd-devel
	yum -y install glibc-headers
	yum -y install gcc-c++
	yum -y install ncurses-devel
	yum -y install make
}

download() {
	php_tgz=php-${PHP_V}.tar.gz
  mcrypt_tgz=libmcrypt-2.5.8.tar.gz

	if [ ! -f $download/$php_tgz ];
	then
		wget http://www.php.net/get/$php_tgz/from/us1.php.net/mirror -O $php_tgz
		tar zxvf $php_tgz
	fi

	if [ ! -f $download/$mcrypt_tgz ];
	then
		#wget http://nchc.dl.sourceforge.net/project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz -O libmcrypt-2.5.8.tar.gz
		wget http://211.79.60.17//project/mcrypt/Libmcrypt/2.5.8/libmcrypt-2.5.8.tar.gz -O libmcrypt-2.5.8.tar.gz
		tar zxvf libmcrypt-2.5.8.tar.gz
	fi

}

install() {
	cd $download/libmcrypt-2.5.8/
	./configure;make;make install
	cd $download/libmcrypt-2.5.8/libltdl
	./configure --enable-ltdl-install
	make;make install
	yum -y install libicu libicu-devel

	cd $download/php-${PHP_V}

  ./configure  --prefix=${prefix}/php$suffix --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-libxml-dir --with-openssl --with-zlib --with-curl --with-gd --with-jpeg-dir --with-png-dir --with-zlib-dir --with-freetype-dir --with-gettext --enable-mbstring --with-mcrypt --with-mysql=/opt/mysql --with-pdo-mysql=/opt/mysql/bin/mysql_config --with-mysqli=/opt/mysql/bin/mysql_config --enable-zip --with-bz2 --enable-soap --with-pear --with-pcre-dir --with-openssl --with-config-file-path=/usr/local/etc --enable-shmop --enable-intl
  make;make install
}

usergroup() {
	groupadd www
	useradd -g www www
}

config() {
	cp $root/php.ini /usr/local/etc/
  cp $root/php-fpm /etc/init.d/
  cp $root/php-fpm.conf $prefix/php${suffix}/etc/
	chmod +x /etc/init.d/php-fpm

	mkdir -p /logs/php
	chown -R www:www /logs

	ln -s $prefix/php${suffix}/bin/php /usr/local/bin/php$suffix
	ln -s $prefix/php${suffix}/bin/phpize /usr/local/bin/phpize$suffix

	/etc/init.d/php-fpm restart
}

reload() {
	/etc/init.d/php-fpm reload
	chkconfig php-fpm on
}


main $1
