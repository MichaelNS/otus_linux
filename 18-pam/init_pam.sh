#!/bin/bash

for pkg in epel-release pam_script; do yum install -y $pkg; done

sudo useradd -G root -s /bin/bash admin ;

# pdf
sudo useradd dauser && sudo useradd night && sudo useradd friday
echo "Otus2022"|sudo passwd --stdin dauser && echo "Otus2022" | sudo passwd --stdin night && echo "Otus2022" | sudo passwd --stdin friday && echo "Otus2022" | sudo passwd --stdin admin

# docker
#usermod -G wheel dauser
sudo touch /etc/sudoers.d/dauser;
sudo cat >>/etc/sudoers.d/dauser <<EOF
dauser ALL=(ALL) NOPASSWD:ALL
EOF

sudo touch /etc/sudoers.d/admin;
sudo cat >>/etc/sudoers.d/admin <<EOF
admin ALL=(ALL) NOPASSWD:ALL
EOF
# end docker


sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd.service

sed -i "2i account  required  pam_script.so"  /etc/pam.d/sshd
sed -i "2i account  required  pam_time.so"  /etc/pam.d/login

cat >>/etc/security/time.conf <<EOF
*;*;dauser;Al0800-2000
*;*;night;!Al0800-2000
*;*;friday;Fr
*;*;admin;Al
EOF


cat <<'EOF' > /etc/pam_script
#!/bin/bash
if [[ `grep $PAM_USER /etc/group | grep 'vagrant'` ]]; then
	exit 0
fi

if [[ `grep $PAM_USER /etc/group | grep 'admin'` ]]; then
	exit 0
fi

if [[ `date +%u` > 5 ]]; then
	exit 1
fi
EOF

chmod +x /etc/pam_script
systemctl restart sshd

