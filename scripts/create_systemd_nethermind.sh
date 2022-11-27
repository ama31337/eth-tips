#!/bin/sh


APP_NAME='nethermind'
SERVICE_NAME='nethermind'

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
ExecStart=${APP_PATH} \
	--datadir=${HOME}/nethermind/data \
	--config xdai_archive \
	--HealthChecks.Enabled true \
	--Merge.Enabled=True \
	--Network.P2PPort=38303 \
	--Network.DiscoveryPort=38303 \
	--JsonRpc.Enabled=True \
	--JsonRpc.Timeout=20000 \
	--JsonRpc.Host="127.0.0.1" \
	--JsonRpc.Port=38545 \
	--JsonRpc.EnabledModules="Eth,Subscribe,Trace,TxPool,Web3,Personal,Proof,Net,Parity,Health" \
	--JsonRpc.EnginePort=38551 \
	--JsonRpc.EngineHost="127.0.0.1" \
	--JsonRpc.JwtSecretFile="${HOME}/nethermind/data/jwt-secret"

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
echo "alias ${SERVICE_NAME}status='sudo systemctl status ${SERVICE_NAME}.service'" >> ~/.bashrc
echo "alias ${SERVICE_NAME}logs='sudo journalctl -u ${SERVICE_NAME} -f'" >> ~/.bashrc

echo "done, now run"
echo "source ~/.bashrc"
echo "and after that start ETH node"
echo "${SERVICE_NAME}start"

