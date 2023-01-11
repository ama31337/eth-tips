#!/bin/sh

. ./env.sh

APP_NAME='lighthouse'
SERVICE_NAME='lighthouse-eth'

APP_PATH=`which $APP_NAME`

cat > ${HOME}/${SERVICE_NAME}.service <<EOF
[Unit]
Description=${APP_NAME} service
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
ExecStart=${APP_PATH} beacon_node \
	--checkpoint-sync-url=https://sync-mainnet.beaconcha.in \
	--datadir="${HOME}/.lighthouse/ethereum" \
	--disable-upnp \
	--execution-endpoint="http://127.0.0.1:${EXECUTION_PORT}" \
	--execution-jwt="${HOME}/.ethereum/jwt.hex" \
	--http \
	--http-address="127.0.0.1" \
	--http-allow-origin="*" \
	--http-port="${LIGHTHOUSE_HTTP_PORT}" \
	--import-all-attestations \
	--metrics \
	--metrics-address="0.0.0.0" \
	--metrics-allow-origin="*" \
	--metrics-port="${LIGHTHOUSE_METRICS_PORT}" \
	--network="mainnet" \
	--port="${LIGHTHOUSE_LISTEN_PORT}" \
	--private \
	--subscribe-all-subnets \
	--validator-monitor-auto

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

echo "done, now run"
echo "source ~/.bashrc"
echo "and after that start ${SERVICE_NAME} node"
echo "${SERVICE_NAME}restart;${SERVICE_NAME}logs"
