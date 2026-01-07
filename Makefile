-include .env

build:
	forge clean && forge build

test:
	forge test

deploy:
	forge script ./script/DeployBox.s.sol --broadcast --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}

upgrade:
	forge script ./script/UpgradeBox.s.sol --broadcast --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY}