#!/bin/bash

#package
mkdir -p /var/payments
curl -s -O https://github.com/hashicorp-demoapp/payments/releases/download/v0.0.16/spring-boot-payments-0.0.16.jar
mv spring-boot-payments-0.0.16.jar /var/payments/spring-boot-payments-0.0.16.jar

#systemd
cat <<EOF > /etc/systemd/system/payments.service
[Unit]
Description=payments
After=syslog.target

[Service]
User=myapp
ExecStart=/var/payments/spring-boot-payments-0.0.16.jar
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

#start it
systemctl enable payments.service

exit 0
