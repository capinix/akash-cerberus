cd $HOME/.cerberus/config/

PEERS=$(curl https://raw.githubusercontent.com/cerberus-zone/cerberus_genesis/main/peers.txt | \
head -n 14 | sed 's/$/,/' | tr -d '\n' | sed '$ s/.$//'); sed "s/persistent_peers = \".*\"/persistent_peers = \"$PEERS\"/" \
$HOME/.cerberus/config/config.toml -i

SEEDS=$(curl https://raw.githubusercontent.com/cerberus-zone/cerberus_genesis/main/seeds.txt | \
head -n 1 | sed 's/$/,/' | tr -d '\n' | sed '$ s/.$//'); sed "s/seeds = \".*\"/seeds = \"$SEEDS\"/" \
$HOME/.cerberus/config/config.toml -i

sed 's/laddr = "tcp:\/\/127.0.0.1:26657"/laddr = "tcp:\/\/0.0.0.0:26657"/' \
$HOME/.cerberus/config/config.toml -i

sed -e 's/pruning = "default"/pruning = "custom"/' \
    -e 's/pruning-keep-recent = ".*"/pruning-keep-recent = "100"/' \
    -e 's/pruning-keep-every = ".*"/pruning-keep-every = "0"/' \
    -e 's/pruning-interval = ".*"/pruning-interval = "10"/' \
$HOME/.cerberus/config/app.toml -i

cd $HOME/.cerberus/config/

wget -O $HOME/.cerberus/config/genesis.json \
https://raw.githubusercontent.com/cerberus-zone/cerberus_genesis/main/genesis.json
