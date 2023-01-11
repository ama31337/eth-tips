#!/bin/sh

. ./env.sh

APP_NAME='heimdalld'
SERVICE_NAME='heimdall-polygon'

APP_PATH=`which $APP_NAME`
mkdir -p ${HOME}/.local/share/heimdall/

cat > ${HOME}/${SERVICE_NAME}.service <<EOF
[Unit]
Description=heimdall polygon service
After=network.target

[Service]
CPUWeight=90
IOWeight=90
LimitNOFILE=1024000
LimitNPROC=1024000
MemoryMax=100G
Restart=always
RestartSec=3
TimeoutStopSec=600
Type=simple
User=${USER}
WorkingDirectory=$HOME/.local/share/heimdall/
ExecStart=${APP_PATH} \
	--chain-id=137 \
	--home="${HOME}/.local/share/heimdall/" \
	--laddr tcp://127.0.0.1:${BOR_HIEMDALL_PORT} \
	--with-heimdall-config ${HOME}/.local/share/heimdall/config/heimdall-config.toml \
	rest-server 


KillSignal=SIGHUP

[Install]
WantedBy=default.target
EOF

sudo mv ${HOME}/${SERVICE_NAME}.service /etc/systemd/system/${SERVICE_NAME}.service
sudo systemctl daemon-reload


# create aliases
ALIAS=$(cat ~/.bashrc | grep ${SERVICE_NAME})
if [ -z "${ALIAS}" ] 
then
	echo "" >> ~/.bashrc
	echo "# ${SERVICE_NAME} alias" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}start='sudo systemctl start ${SERVICE_NAME}.service'" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}stop='sudo systemctl stop ${SERVICE_NAME}.service'" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}restart='sudo systemctl restart ${SERVICE_NAME}.service'" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}status='sudo systemctl status ${SERVICE_NAME}.service'" >> ~/.bashrc
	echo "alias ${SERVICE_NAME}logs='sudo journalctl -u ${SERVICE_NAME} -f'" >> ~/.bashrc
else
	echo "alias already added"
fi

# setup firewall 
sudo ufw allow ${BOR_HIEMDALL_PORT} comment 'bot heimdall port'


# done
echo "done, now run"
echo "source ~/.bashrc"
echo "and after that start ETH node"
echo "${SERVICE_NAME}start;${SERVICE_NAME}logs"

