#!/bin/bash

#packages
apt install default-jre -y
curl -L -s -O  https://github.com/hashicorp-demoapp/payments/releases/download/v0.0.16/spring-boot-payments-0.0.16.jar
mkdir -p /var/payments
mv spring-boot-payments-0.0.16.jar /var/payments/spring-boot-payments-0.0.16.jar
chmod +x /var/payments/spring-boot-payments-0.0.16.jar

#systemd
cat <<EOF > /etc/systemd/system/payments.service
[Unit]
Description=payments
After=syslog.target

[Service]
ExecStart=/usr/bin/java -jar /var/payments/spring-boot-payments-0.0.16.jar
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

#start it
systemctl enable payments.service
systemctl start payments.service

exit 0
