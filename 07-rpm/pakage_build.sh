#yum groupinstall -y "Development Tools" 

#yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils openssl-devel zlib-devel pcre-devel gcc libtool perl-core openssl nano lynx

#yum install -y gnutls-devel

cd /root

wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

#wget --no-check-certificate https://www.openssl.org/source/latest.tar.gz
wget https://www.openssl.org/source/openssl-3.0.0.tar.gz
tar -xvf latest.tar.gz

yum-builddep rpmbuild/SPECS/nginx.spec

rpmbuild -bb rpmbuild/SPECS/nginx.spec

ll rpmbuild/RPMS/x86_64/

yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
systemctl start nginx
systemctl status nginx

mkdir /usr/share/nginx/html/repo

cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/


wget https://repo.percona.com/yum/release/7/RPMS/noarch/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
#wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm


createrepo /usr/share/nginx/html/repo
#createrepo /usr/share/nginx/html/repo/

#В location / в файле /etc/nginx/conf.d/default.conf добавим директиву autoindex on. В
sed -i -e 's/index  index.html index.htm;/index  index.html index.htm;\n        autoindex on;/g' /etc/nginx/conf.d/default.conf

nginx -t
nginx -s reload
sleep 5

#lynx http://localhost/repo/
curl -a http://localhost/repo/

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

cat /etc/yum.repos.d/otus.repo

yum repolist enabled | grep otus

yum list | grep otus

yum install percona-release -y

