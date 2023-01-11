#!/bin/sh

. ./env.sh

APP_NAME='nethermind'
SERVICE_NAME='nethermind-gnosis'

APP_PATH=`which $APP_NAME`

cat > ${HOME}/${SERVICE_NAME}.service <<EOF
[Unit]
Description=${SERVICE_NAME} Node
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
WorkingDirectory=${HOME}
ExecStart=${APP_PATH} \
	--datadir=${HOME}/.nethermind/gnosis \
	--config xdai_archive \
	--HealthChecks.Enabled true \
	--Network.MaxActivePeers 256 \
	--Network.P2PPort=${GNOSIS_NETWORK_PORT} \
	--Network.DiscoveryPort=${GNOSIS_NETWORK_PORT} \
	--JsonRpc.Enabled=True \
	--JsonRpc.Timeout=20000 \
	--JsonRpc.Host="0.0.0.0" \
	--JsonRpc.Port=${GNOSIS_RPC_PORT} \
	--JsonRpc.EnabledModules="Eth,Subscribe,Trace,TxPool,Web3,Personal,Proof,Net,Parity,Health" \
	--JsonRpc.EnginePort=${GNOSIS_ENGINE_PORT} \
	--JsonRpc.EngineHost="127.0.0.1" \
	--JsonRpc.JwtSecretFile="${HOME}/.nethermind/gnosis/jwt.hex"

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

# add ufw rule
sudo ufw allow ${GNOSIS_NETWORK_PORT} comment 'nethermind gnosis'

# done
echo "done, now run"
echo "source ~/.bashrc"
echo "and after that start node"
echo "${SERVICE_NAME}restart;${SERVICE_NAME}logs"

