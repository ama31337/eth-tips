#!/bin/sh

. ./env.sh

APP_NAME='erigon'
SERVICE_NAME='erigon-polygon'

APP_PATH=`which $APP_NAME`
mkdir -p ${HOME}/.polygon/

cat > ${HOME}/${SERVICE_NAME}.service <<EOF
[Unit]
Description=erigon polygon service
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
ExecStart=${APP_PATH} --datadir="${HOME}/.polygon/" \
	--authrpc.addr="127.0.0.1" \
	--authrpc.port="${POLYGON_AUTHRPC_PORT}" \
	--bor.heimdall="http://127.0.0.1:${BOR_HIEMDALL_PORT}" \
	--chain="bor-mainnet" \
	--ethash.dagdir="${HOME}/.polygon/ethash" \
	--http \
	--http.addr="127.0.0.1" \
	--http.api="eth,debug,net,trace,web3,erigon,bor" \
	--http.compression \
	--http.corsdomain="*" \
	--http.port="${POLYGON_HTTP_PORT}" \
	--http.vhosts="*" \
	--metrics \
	--metrics.addr="0.0.0.0" \
	--metrics.port="${POLYGON_METRICS_PORT}" \
	--port=${POLYGON_P2P_PORT} \
	--private.api.addr="0.0.0.0:${POLYGON_API_PORT}" \
	--rpc.gascap="300000000" \
	--snapshots="true" \
	--torrent.download.rate=100mb \
	--torrent.port=${POLYGON_TORRENT_PORT} \
	--ws \
	--ws.compression

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
sudo ufw allow ${POLYGON_P2P_PORT} comment 'erigon polygon peers'
sudo ufw allow ${POLYGON_TORRENT_PORT} comment 'erigon polygon torrent'


# done
echo "done, now run"
echo "source ~/.bashrc"
echo "and after that start ETH node"
echo "${SERVICE_NAME}start;${SERVICE_NAME}logs"

