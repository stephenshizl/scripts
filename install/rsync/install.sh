#!/bin/sh
source ../header.sh
version=3.0.9
inner_ip=default

dependencies() {
}

download() {
  tgz=rsync-$version.tar.gz

	if [ ! -f $download/$tgz ];
	then
		wget ftp://ftp.samba.org/pub/rsync/$tgz 
		tar zxvf $tgz 
	fi
}

install() {
	cd $download/rsync-$version
	./configure --prefix=${prefix}/rsync 
	make;make install
}

usergroup() {
	echo 'no need'
}

config() {
	mkdir /etc/rsyncd
	cp $root/rsyncd /etc/init.d/
  cp $root/rsyncd.conf /etc/rsyncd/
	sed -i 's/inner_ip/$inner_ip/' /etc/rsyncd/rsyncd.conf 
  cp $root/rsyncd.secrets /etc/rsyncd/
  cp $root/rsyncd.motd /etc/rsyncd/
  cp $root/rsync.password /etc/rsyncd/
	chmod 600 /etc/rsyncd/rsyncd.secrets
	chmod 600 /etc/rsyncd/rsync.password
  chmod +x /etc/init.d/rsyncd
  /etc/init.d/nginx restart
}

reload() {
	/etc/init.d/nginx reload
}

inner_ip=$2	
 
if [ x$1 = "xinstall" ];then
if [ x$2 = "x" ];then
 echo 'Pls specify the inner IP, ex, 192.168.1.10'
 exit
fi
inner_ip=$2	

main $1