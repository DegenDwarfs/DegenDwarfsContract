# <img src="https://github.com/stinkyfi/DegenDwarfs/blob/main/images/DegenDwarfs.png" width="500">

Degen Dwarfs is a Guild of 6969 Dwarfs on the Ethereum blockchain, equipped with gear earned from their adventures through DeFi. The community aims to enhance the DeFi experience, using shared knowledge and funds to find new projects and minimize how often we are exit liquidity. Come join us at twitter.com/DegenDwarfs!


<img src="https://ethereum.org/static/a110735dade3f354a46fc2446cd52476/db4de/eth-home-icon.webp" data-canonical-src="https://ethereum.org/static/a110735dade3f354a46fc2446cd52476/db4de/eth-home-icon.webp" width="12" height="18" /> Contract Address:
```
0x9091C144218D3Ab99C716833404B74A87aea4c74
```

## Install Contract Dependecies

The first steps are to clone the repository and install its dependencies:

```sh
git clone https://github.com/DegenDwarfs/DegenDwarfsContract.git
cd DegenDwarfsContract
npm install
```

## Test
On a new terminal, go to the repository's root folder and run this to
test the contract:

```sh
npx hardhat test
```

## Deploy
On a new terminal, go to the repository's root folder and run this to
deploy the contract:

```sh
npx hardhat run scripts/deploy.js --network <network>
```

## ABI
Build a front-end for this contract by using the ABI located in [scripts/DegenDwarfs.json](https://github.com/DegenDwarfs/DegenDwarfsContract/blob/main/scripts/DegenDwarfs.json)
