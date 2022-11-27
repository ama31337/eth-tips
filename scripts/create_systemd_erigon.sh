#!/bin/sh

. ./env.sh

APP_NAME='erigon'
SERVICE_NAME='erigon'

APP_PATH=`which $APP_NAME`

cat > ${HOME}/${SERVICE_NAME}.service <<EOF
[Unit]
Description=erigon service
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
ExecStart=${APP_PATH} --datadir=${HOME}/.ethereum \
	--authrpc.jwtsecret="${HOME}/.ethereum/jwt.hex" \
	--chain=mainnet \
	--http \
	--http.addr=127.0.0.1 \
	--http.api=eth,admin,debug,net,trace,web3,txpool,erigon \
	--http.port=${HTTP_PORT} \
	--metrics \
	--metrics.addr="127.0.0.1" \
	--metrics.port=${METRICS_PORT} \
	--port=${P2P_PORT} \
	--private.api.addr=localhost:${API_PORT} \
	--torrent.download.rate=50mb \
	--torrent.port=${TORRENT_PORT} \
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

