#!/bin/sh


APP_NAME='geth'
SERVICE_NAME='geth'

APP_PATH=`which $APP_NAME`

cat > ${HOME}/${SERVICE_NAME}.service <<EOF
[Unit]
Description=geth service
After=network.target

[Service]
Type=simple
Restart=always
RestartSec=3
LimitNOFILE=1024000
User=${USER}
ExecStart=${APP_PATH} --goerli --datadir="$HOME/Goerli" --port=44101 --cache=2048 --rpc --rpcport=44102 --rpcapi=eth,web3,net,personal --syncmode=fast --allow-insecure-unlock

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
echo "gethstart"

