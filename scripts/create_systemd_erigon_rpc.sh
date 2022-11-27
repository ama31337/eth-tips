#!/bin/sh


APP_NAME='rpcdaemon'
SERVICE_NAME='erigon-rpc'

APP_PATH=`which $APP_NAME`

cat > ${HOME}/${SERVICE_NAME}.service <<EOF
[Unit]
Description=erigon service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=3
LimitNOFILE=1024000
User=${USER}
ExecStart=${APP_PATH} --datadir=${HOME}/.ethereum --txpool.api.addr=localhost:9090 --private.api.addr=localhost:9090 --http.api=eth,erigon,web3,net,debug,trace,txpool --ws

[Install]
WantedBy=default.target
EOF

sudo mv ${HOME}/${SERVICE_NAME}.service /etc/systemd/system/${SERVICE_NAME}.service
sudo systemctl daemon-reload

ALIAS_CHECK=$(cat ~/.bashrc | grep "# ${SERVICE_NAME} alias")
if [ -z "${ALIAS_CHECK}" ];
then
	# create aliases
	echo "" >> ~/.bashrc
	echo "# ${SERVICE_NAME} alias" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}start='sudo systemctl start ${SERVICE_NAME}.service'" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}stop='sudo systemctl stop ${SERVICE_NAME}.service'" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}restart='sudo systemctl restart ${SERVICE_NAME}.service'" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}logs='sudo journalctl -u ${SERVICE_NAME} -f'" >> ~/.bashrc
else
	echo "aliases already added"
fi

echo "done, now run"
echo "source ~/.bashrc"
echo "and after that start ETH node"
echo "${SERVICE_NAME}start"

