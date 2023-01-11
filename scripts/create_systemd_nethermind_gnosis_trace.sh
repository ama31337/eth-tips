#!/bin/sh

. ./env.sh

APP_NAME='Nethermind.Runner'
SERVICE_NAME='nethermind-gnosis'
APP_PATH=${HOME}/nethermind-bin/Nethermind.Runner

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
WorkingDirectory=${HOME}/nethermind-bin/
ExecStart=${APP_PATH} \
        --config xdai_archive \
        --datadir=${HOME}/.nethermind/gnosis \
	--JsonRpc.Enabled=True \
	--JsonRpc.EnabledModules="Eth,Subscribe,Trace,TxPool,Web3,Personal,Proof,Net,Parity,Health" \
	--JsonRpc.EngineHost="127.0.0.1" \
	--JsonRpc.EnginePort=${GNOSIS_ENGINE_PORT} \
	--JsonRpc.Host="0.0.0.0" \
	--JsonRpc.JwtSecretFile="${HOME}/.nethermind/gnosis/jwt.hex" \
	--JsonRpc.Port=${GNOSIS_RPC_PORT} \
	--JsonRpc.Timeout=20000 \
	--Network.DiscoveryPort=${GNOSIS_NETWORK_PORT} \
	--Network.MaxActivePeers 256 \
	--Network.P2PPort=${GNOSIS_NETWORK_PORT} \
	--Sync.FastSync=false \
	--TraceStore.BlocksToKeep=0 \
	--TraceStore.Enabled=true \
	--TraceStore.TraceTypes=Trace,Rewards

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

