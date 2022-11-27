#!/bin/sh

. ./env.sh

APP_NAME='erigon'
SERVICE_NAME='erigon-goerli'

APP_PATH=`which $APP_NAME`

cat > ${HOME}/${SERVICE_NAME}.service <<EOF
[Unit]
Description=erigon goerli service
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
ExecStart=${APP_PATH} --datadir=${HOME}/.goerli \
	--authrpc.jwtsecret="${HOME}/.goerli/jwt.hex" \
	--chain="goerli" \
	--http \
	--http.addr="0.0.0.0" \
	--http.api="eth,admin,debug,net,trace,web3,txpool,erigon" \
	--http.port="${GOERLI_HTTP_PORT}" \
	--metrics \
	--metrics.addr="127.0.0.1" \
	--metrics.port="${GOERLI_METRICS_PORT}" \
	--port="${GOERLI_P2P_PORT}" \
	--private.api.addr="0.0.0.0:${GOERLI_API_PORT}" \
	--authrpc.addr="127.0.0.1" \
	--authrpc.port="${GOERLI_AUTHRPC_PORT}" \
	--torrent.download.rate=50mb \
	--torrent.port="${GOERLI_TORRENT_PORT}" \
	--ws

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
echo "and after that start ETH node"
echo "${SERVICE_NAME}start"
