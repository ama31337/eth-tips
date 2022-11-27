#!/bin/sh

. ./env.sh

APP_NAME='lighthouse'
SERVICE_NAME='lighthouse-goerli'

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
	--checkpoint-sync-url=https://goerli.checkpoint-sync.ethpandaops.io \
	--datadir="${HOME}/.lighthouse/goerli" \
	--disable-upnp \
	--execution-endpoint="http://127.0.0.1:${GOERLI_EXECUTION_PORT}" \
	--execution-jwt="${HOME}/.goerli/jwt.hex" \
	--http \
	--http-address="127.0.0.1" \
	--http-allow-origin="*" \
	--import-all-attestations \
	--metrics \
	--metrics-address="0.0.0.0" \
	--metrics-allow-origin="*" \
	--metrics-port="${GOERLI_METRICS_PORT_LIGHHOUSE}" \
	--network="goerli" \
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
echo "" >> ~/.bashrc
echo "# ${SERVICE_NAME} alias" >> ~/.bashrc
echo "alias ${SERVICE_NAME}start='sudo systemctl start ${SERVICE_NAME}.service'" >> ~/.bashrc
echo "alias ${SERVICE_NAME}stop='sudo systemctl stop ${SERVICE_NAME}.service'" >> ~/.bashrc
echo "alias ${SERVICE_NAME}restart='sudo systemctl restart ${SERVICE_NAME}.service'" >> ~/.bashrc
echo "alias ${SERVICE_NAME}logs='sudo journalctl -u ${SERVICE_NAME} -f'" >> ~/.bashrc

echo "done, now run"
echo "source ~/.bashrc"
echo "and after that start ${SERVICE_NAME} node"
echo "${SERVICE_NAME}start"

