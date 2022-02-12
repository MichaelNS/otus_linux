#yum groupinstall -y "Development Tools" 

#yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils
yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils openssl-devel zlib-devel pcre-devel gcc libtool perl-core openssl nano lynx

#yum install -y gnutls-devel

cd /root
echo "1 -----------------------------------------------------------------------------"

wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm

echo "2 -----------------------------------------------------------------------------"

#wget --no-check-certificate https://www.openssl.org/source/latest.tar.gz
wget https://www.openssl.org/source/openssl-3.0.0.tar.gz
tar -xvf latest.tar.gz

echo "3 -----------------------------------------------------------------------------"

yum-builddep rpmbuild/SPECS/nginx.spec

echo "4 -----------------------------------------------------------------------------"

rpmbuild -bb rpmbuild/SPECS/nginx.spec

echo "5 -----------------------------------------------------------------------------"

ll rpmbuild/RPMS/x86_64/
echo "6 -----------------------------------------------------------------------------"

yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
systemctl start nginx
systemctl status nginx

echo "7 -----------------------------------------------------------------------------"

mkdir /usr/share/nginx/html/repo

cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/

echo "8 -----------------------------------------------------------------------------"


wget https://repo.percona.com/yum/release/7/RPMS/noarch/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
#wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm


createrepo /usr/share/nginx/html/repo
#createrepo /usr/share/nginx/html/repo/

#В location / в файле /etc/nginx/conf.d/default.conf добавим директиву autoindex on. В
sed -i -e 's/index  index.html index.htm;/index  index.html index.htm;\n        autoindex on;/g' /etc/nginx/conf.d/default.conf

echo "9 -----------------------------------------------------------------------------"

nginx -t
nginx -s reload
sleep 5

echo "10 -----------------------------------------------------------------------------"

#lynx http://localhost/repo/
curl -a http://localhost/repo/

echo "11 -----------------------------------------------------------------------------"

cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF

cat /etc/yum.repos.d/otus.repo

echo "12 -----------------------------------------------------------------------------"

yum repolist enabled | grep otus

echo "13 -----------------------------------------------------------------------------"

yum list | grep otus

echo "14 -----------------------------------------------------------------------------"

yum install percona-release -y

echo "15 -----------------------------------------------------------------------------"


