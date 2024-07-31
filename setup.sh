#!/bin/bash

LOGO="https://raw.githubusercontent.com/BlackIceNodeRunner/BlackIceGuides/main/logo.sh"
source <(curl -s $LOGO)
clear
logo

read -p "Enter EMPERIA_MONIKER name:" EMPERIA_MONIKER
export EMPERIA_MONIKER=$EMPERIA_MONIKER
EMPERIA_PORT=26
read -p "Enter EMPERIA_WALLET name:" EMPERIA_WALLET
export EMPERIA_WALLET=$EMPERIA_WALLET
EMPERIA_CHAIN_ID="empe-testnet-2"

read -p "Enter WARDEN_MONIKER name:" WARDEN_MONIKER
export WARDEN_MONIKER=$WARDEN_MONIKER
WARDEN_PORT=28
read -p "Enter WARDEN_WALLET name:" WARDEN_WALLET
export WARDEN_WALLET=$WARDEN_WALLET
WARDEN_CHAIN_ID="buenavista-1"

read -p "Enter ARTELA_MONIKER name:" ARTELA_MONIKER
export ARTELA_MONIKER=$ARTELA_MONIKER
ARTELA_PORT=30
read -p "Enter ARTELA_WALLET name:" ARTELA_WALLET
export ARTELA_WALLET=$ARTELA_WALLET
ARTELA_CHAIN_ID="artela_11822-1"

#VARS
echo "export EMPERIA_MONIKER=$EMPERIA_MONIKER" >> $HOME/.bashrc
echo "export EMPERIA_PORT=$EMPERIA_PORT" >> $HOME/.bashrc
echo "export EMPERIA_WALLET=$EMPERIA_WALLET" >> $HOME/.bashrc
echo "export EMPERIA_CHAIN_ID=$EMPERIA_CHAIN_ID" >> $HOME/.bashrc

echo "WARDEN_MONIKER=$WARDEN_MONIKER" >> $HOME/.bashrc
echo "WARDEN_PORT=$WARDEN_PORT" >> $HOME/.bashrc
echo "WARDEN_WALLET=$WARDEN_WALLET" >> $HOME/.bashrc
echo "WARDEN_CHAIN_ID=$WARDEN_CHAIN_ID"  >> $HOME/.bashrc

echo "ARTELA_MONIKER=$ARTELA_MONIKER" >> $HOME/.bashrc
echo "ARTELA_PORT=$ARTELA_PORT" >> $HOME/.bashrc
echo "ARTELA_WALLET=$ARTELA_WALLET" >> $HOME/.bashrc
echo "ARTELA_CHAIN_ID=$ARTELA_CHAIN_ID" >> $HOME/.bashrc

#Annoncment
echo -e " "
echo -e "\033[92m========================================================="
echo -e "THIS SCRIPT INSTALES Emperia, Warden Protocol AND Artela"
echo -e "=========================================================\033[0m"
echo -e " "

GO_VER="1.22.3"
wget "https://golang.org/dl/go$GO_VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$GO_VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> $HOME/.bashrc
source $HOME/.bashrc

echo -e " "
echo -e "\033[92m========================================================="
echo -e "                      CHEKING GO VERSION"
echo -e "=========================================================\033[0m"
echo -e " "

go version
echo -e " "
echo -e "\033[92m=========================================================\033[0m"

clear
logo

#===================================
#              EMPIRE
#===================================

# download Empire binary
cd $HOME
curl -LO https://github.com/empe-io/empe-chain-releases/raw/master/v0.1.0/emped_linux_amd64.tar.gz
tar -xvf emped_linux_amd64.tar.gz 
mv emped ~/go/bin

# config and init app
emped config node tcp://localhost:${EMPERIA_PORT}657
emped config keyring-backend os
emped config chain-id empe-testnet-2
emped init "test" --chain-id empe-testnet-2

# download genesis and addrbook
wget -O $HOME/.empe-chain/config/genesis.json https://server-5.itrocket.net/testnet/empeiria/genesis.json
wget -O $HOME/.empe-chain/config/addrbook.json  https://server-5.itrocket.net/testnet/empeiria/addrbook.json

# set seeds and peers
EMPERIA_SEEDS="20ca5fc4882e6f975ad02d106da8af9c4a5ac6de@empeiria-testnet-seed.itrocket.net:28656"
EMPERIA_PEERS="03aa072f917ed1b79a14ea2cc660bc3bac787e82@empeiria-testnet-peer.itrocket.net:28656,004e2924efb660169e27d55518909b24f902dd48@155.133.27.170:26656,7f777a33fc94dfdade513c161a0bafbb0cfc2025@213.199.45.86:43656,5faa12744223fd0aea91970e405d69731ff35fed@62.169.17.9:43656,33cfcfa07ad55331d40fb7bcda010b0156328647@149.102.144.171:43656,3e30e4b87bdd45e9715b0bbf02c9930d820a3158@164.132.168.149:26656,bb15883943a2f31b1ca73247a1b0526a5778f23a@135.181.94.81:26656,e058f20874c7ddf7d8dc8a6200ff6c7ee66098ba@65.109.93.124:29056,0340080d68f88eb6944bd79c86abd3c9794eb0a0@65.108.233.73:13656,45bdc8628385d34afc271206ac629b07675cd614@65.21.202.124:25656,a9cf0ffdef421d1f4f4a3e1573800f4ee6529773@136.243.13.36:29056,878d0e8b9741adc865823e4f69554712e35236b9@91.227.33.18:13656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$EMPERIA_SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$EMPERIA_PEERS\"/}" $HOME/.empe-chain/config/config.toml


# set custom ports in app.toml
sed -i.bak -e "s%:1317%:${EMPERIA_PORT}317%g;
s%:8080%:${EMPERIA_PORT}080%g;
s%:9090%:${EMPERIA_PORT}090%g;
s%:9091%:${EMPERIA_PORT}091%g;
s%:8545%:${EMPERIA_PORT}545%g;
s%:8546%:${EMPERIA_PORT}546%g;
s%:6065%:${EMPERIA_PORT}065%g" $HOME/.empe-chain/config/app.toml

# set custom ports in config.toml file
sed -i.bak -e "s%:26658%:${EMPERIA_PORT}658%g;
s%:26657%:${EMPERIA_PORT}657%g;
s%:6060%:${EMPERIA_PORT}060%g;
s%:26656%:${EMPERIA_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${EMPERIA_PORT}656\"%;
s%:26660%:${EMPERIA_PORT}660%g" $HOME/.empe-chain/config/config.toml

# config pruning
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.empe-chain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.empe-chain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.empe-chain/config/app.toml

# set minimum gas price, enable prometheus and disable indexing
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.0001uempe"|g' $HOME/.empe-chain/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.empe-chain/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.empe-chain/config/config.toml

# create service file
sudo tee /etc/systemd/system/emped.service > /dev/null <<EOF
[Unit]
Description=Empeiria node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.empe-chain
ExecStart=$(which emped) start --home $HOME/.empe-chain
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

# reset and download snapshot
emped tendermint unsafe-reset-all --home $HOME/.empe-chain
if curl -s --head curl https://server-5.itrocket.net/testnet/empeiria/empeiria_2024-07-30_753975_snap.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
  curl https://server-5.itrocket.net/testnet/empeiria/empeiria_2024-07-30_753975_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.empe-chain
    else
  echo "no snapshot founded"
fi

# enable and start service
sudo systemctl daemon-reload
sudo systemctl enable emped
sudo systemctl restart emped && sudo journalctl -u emped -f

clear
logo
sleep 3

echo -e " "
echo -e "\033[92m========================================================="
echo -e "                   CREATING EMPIRE WALLET "
echo -e "=========================================================\033[0m"
echo -e " "

emped keys add $EMPERIA_WALLET && sleep 2
EMPERIA_WALLET_ADDRESS=$(emped keys show $EMPERIA_WALLET -a)
EMPERIA_VALOPER_ADDRESS=$(emped keys show $EMPERIA_WALLET --bech val -a)
echo "export EMPERIA_WALLET_ADDRESS="$EMPERIA_WALLET_ADDRESS >> $HOME/.bashrc
echo "export EMPERIA_VALOPER_ADDRESS="$EMPERIA_VALOPER_ADDRESS >> $HOME/.bashrc
source $HOME/.bash_profile


#===================================
#            WARDEN
#===================================

clear
logo
cd $HOME
rm -rf wardenprotocol
git clone --depth 1 --branch v0.3.0 https://github.com/warden-protocol/wardenprotocol/
cd wardenprotocol
make install

# config and init app
wardend init $WARDEN_MONIKER
sed -i -e "s|^node *=.*|node = \"tcp://localhost:${WARDEN_PORT}657\"|" $HOME/.warden/config/client.toml

# download genesis and addrbook
wget -O $HOME/.warden/config/genesis.json https://server-4.itrocket.net/testnet/warden/genesis.json
wget -O $HOME/.warden/config/addrbook.json  https://server-4.itrocket.net/testnet/warden/addrbook.json

# set seeds and peers
WARDEN_SEEDS="8288657cb2ba075f600911685670517d18f54f3b@warden-testnet-seed.itrocket.net:18656"
WARDEN_PEERS="b14f35c07c1b2e58c4a1c1727c89a5933739eeea@warden-testnet-peer.itrocket.net:18656,dc0122e37c203dec43306430a1f1879650653479@37.27.97.16:26656,ab510acb34d4db1c925742f46b6a09fb7e3052bf@116.202.233.2:27356,24e2505eda562564151f49848ad44082bfaafaf8@86.48.3.91:656,ac16d7fa01abcc167d25641938b4cf419a0676ae@149.202.79.19:15656,e8b15bf7b20791665d8be9e530aafa3aa80f79c6@168.119.10.134:29474,db6947c73751a64b81360e2487c85c54ec0c81a5@81.17.97.89:656,d1022e9ba937d689b56c3d705318f42b7c990259@77.237.244.118:11256,e8b4153ae30f47d1ff0912b035b63be8f6cea0d9@192.99.9.143:26656,849252edf13621d4ad531c95c26159be6dbfbd51@37.27.115.100:26671,49fb18d457ec1be09de78472e33e5f685706ec6d@195.26.244.134:22656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$WARDEN_SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$WARDEN_PEERS\"/}" $HOME/.warden/config/config.toml


# set custom ports in app.toml
sed -i.bak -e "s%:1317%:${WARDEN_PORT}317%g;
s%:8080%:${WARDEN_PORT}080%g;
s%:9090%:${WARDEN_PORT}090%g;
s%:9091%:${WARDEN_PORT}091%g;
s%:8545%:${WARDEN_PORT}545%g;
s%:8546%:${WARDEN_PORT}546%g;
s%:6065%:${WARDEN_PORT}065%g" $HOME/.warden/config/app.toml

# set custom ports in config.toml file
sed -i.bak -e "s%:26658%:${WARDEN_PORT}658%g;
s%:26657%:${WARDEN_PORT}657%g;
s%:6060%:${WARDEN_PORT}060%g;
s%:26656%:${WARDEN_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${WARDEN_PORT}656\"%;
s%:26660%:${WARDEN_PORT}660%g" $HOME/.warden/config/config.toml

# config pruning
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.warden/config/app.toml

# set minimum gas price, enable prometheus and disable indexing
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.0025uward"|g' $HOME/.warden/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.warden/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.warden/config/config.toml

# create service file
sudo tee /etc/systemd/system/wardend.service > /dev/null <<EOF
[Unit]
Description=Warden node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.warden
ExecStart=$(which wardend) start --home $HOME/.warden
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

# reset and download snapshot
wardend tendermint unsafe-reset-all --home $HOME/.warden
if curl -s --head curl https://server-4.itrocket.net/testnet/warden/warden_2024-07-30_1508959_snap.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
  curl https://server-4.itrocket.net/testnet/warden/warden_2024-07-30_1508959_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.warden
    else
  echo "no snapshot founded"
fi

# enable and start service
sudo systemctl daemon-reload
sudo systemctl enable wardend
sudo systemctl restart wardend && sudo journalctl -u wardend -f

clear
logo
sleep 3

echo -e " "
echo -e "\033[92m========================================================="
echo -e "                   CREATING WARDEN WALLET "
echo -e "=========================================================\033[0m"
echo -e " "

wardend keys add $WARDEN_WALLET &&  sleep 2
WARDEN_WALLET_ADDRESS=$(wardend keys show $WARDEN_WALLET -a)
WARDEN_VALOPER_ADDRESS=$(wardend keys show $WARDEN_WALLET --bech val -a)
echo "export WARDEN_WALLET_ADDRESS="$WARDEN_WALLET_ADDRESS >> $HOME/.bashrc
echo "export WARDEN_VALOPER_ADDRESS="$WARDEN_VALOPER_ADDRESS >> $HOME/.bashrc
source $HOME/.bashrc


#===================================
#              ARTELLA
#===================================

clear
logo
cd $HOME
rm -rf artela
git clone https://github.com/artela-network/artela
cd artela
git checkout 2857a2b5f41eba0aa5d0d3a536f46a001e444f96
make install

# config and init app
artelad config node tcp://localhost:${ARTELA_PORT}657
artelad config keyring-backend os
artelad config chain-id artela_11822-1
artelad init "test" --chain-id artela_11822-1

# download genesis and addrbook
wget -O $HOME/.artelad/config/genesis.json https://server-4.itrocket.net/testnet/artela/genesis.json
wget -O $HOME/.artelad/config/addrbook.json  https://server-4.itrocket.net/testnet/artela/addrbook.json

# set seeds and peers
ARTELA_SEEDS="8d0c626443a970034dc12df960ae1b1012ccd96a@artela-testnet-seed.itrocket.net:30656"
ARTELA_PEERS="5c9b1bc492aad27a0197a6d3ea3ec9296504e6fd@artela-testnet-peer.itrocket.net:30656,a84cd3e3d401f7b853135a4ca786057c7a0b913a@38.242.157.138:26656,aa2e2400ead278c81b0a04b703eb51b604f4ddbe@185.255.131.50:3456,bd6564af6edf4693c0a0da976bc75559a83e48bd@173.249.19.35:25656,1f6b720de8c41f76aae93c9da5cae4de0eb37487@109.199.105.130:25656,0fd485c04a08619558cae33e30c194f99abb8058@65.109.86.216:3456,3aa6155b72dc7d636d3f34e6f392f40c545bb78b@152.53.34.225:3456,065b81852b240c922e2a34ddd49a4a6059a9c80e@178.128.228.250:3456,6d1bc3d051c2e8eb2fe7df284cd505ab97eefcfe@75.119.131.252:3456,cf1df633664e847b0276c597c40724e0ef6a2338@109.199.108.52:3456,69faae4c423fd59e67b358b29a9befeb6e83f58d@77.237.243.118:3456,58514c1280eb7b0cc57881fa09f0a4d39a39e886@195.7.4.16:11856,33e7f2a3a82ca7bd6dc941be95cec2f9a128de61@148.251.82.6:3456,b0475aaf0bee05abd007d1ff5a833bb46ec0daf4@162.55.22.230:26656,68398059b8be375fe760c5a45c0e6b9f46ee701c@109.199.114.153:3456,3d116e281c93bc73cd35b9036a64c7b3c7a6b1e4@84.46.240.232:3456,87d7660909447800d61ec37863da377ac66de53e@116.203.49.2:26656,80ec96e0189ff4e18038ed63d6dc62da02be5791@37.60.234.91:3456"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$ARTELA_SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$ARTELA_PEERS\"/}" $HOME/.artelad/config/config.toml


# set custom ports in app.toml
sed -i.bak -e "s%:1317%:${ARTELA_PORT}317%g;
s%:8080%:${ARTELA_PORT}080%g;
s%:9090%:${ARTELA_PORT}090%g;
s%:9091%:${ARTELA_PORT}091%g;
s%:8545%:${ARTELA_PORT}545%g;
s%:8546%:${ARTELA_PORT}546%g;
s%:6065%:${ARTELA_PORT}065%g" $HOME/.artelad/config/app.toml

# set custom ports in config.toml file
sed -i.bak -e "s%:26658%:${ARTELA_PORT}658%g;
s%:26657%:${ARTELA_PORT}657%g;
s%:6060%:${ARTELA_PORT}060%g;
s%:26656%:${ARTELA_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${ARTELA_PORT}656\"%;
s%:26660%:${ARTELA_PORT}660%g" $HOME/.artelad/config/config.toml

# config pruning
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.artelad/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.artelad/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.artelad/config/app.toml

# set minimum gas price, enable prometheus and disable indexing
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.025art"|g' $HOME/.artelad/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.artelad/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.artelad/config/config.toml

# create service file
sudo tee /etc/systemd/system/artelad.service > /dev/null <<EOF
[Unit]
Description=Artela node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.artelad
ExecStart=$(which artelad) start --home $HOME/.artelad
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF

# reset and download snapshot
artelad tendermint unsafe-reset-all --home $HOME/.artelad
if curl -s --head curl https://server-4.itrocket.net/testnet/artela/artela_2024-07-30_10807804_snap.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
  curl https://server-4.itrocket.net/testnet/artela/artela_2024-07-30_10807804_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.artelad
    else
  echo "no snapshot founded"
fi

# enable and start service
sudo systemctl daemon-reload
sudo systemctl enable artelad
sudo systemctl restart artelad && sudo journalctl -u artelad -f

clear
logo
sleep 3

echo -e " "
echo -e "\033[92m========================================================="
echo -e "                   CREATING WARDEN WALLET "
echo -e "=========================================================\033[0m"
echo -e " "

wardend keys add $ARTELA_WALLET &&  sleep 2
ARTELA_WALLET_ADDRESS=$(wardend keys show $ARTELA_WALLET -a)
ARTELA_VALOPER_ADDRESS=$(wardend keys show $ARTELA_WALLET --bech val -a)
echo "export ARTELA_WALLET_ADDRESS="$ARTELA_WALLET_ADDRESS >> $HOME/.bashrc
echo "export ARTELA_VALOPER_ADDRESS="$ARTELA_VALOPER_ADDRESS >> $HOME/.bashrc
source $HOME/.bashrc
