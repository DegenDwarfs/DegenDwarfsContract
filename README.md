# <img src="https://github.com/stinkyfi/DegenDwarfs/blob/main/images/DegenDwarfs.png" width="500">

Degen Dwarfs is a Guild of 6969 Dwarfs on the Ethereum blockchain, equipped with gear earned from their adventures through DeFi. The community aims to enhance the DeFi experience, using shared knowledge and funds to find new projects and minimize how often we are exit liquidity. Come join us at twitter.com/DegenDwarfs!


## Run Contract Locally

The first things you need to do are cloning this repository and installing its
dependencies:

```sh
git clone https://github.com/stinkyfi/DegenDwarfs.git
cd DegenDwarfs
npm install
```

Once installed, let's run Hardhat's testing network:

```sh
npx hardhat node
```

Then, on a new terminal, go to the repository's root folder and run this to
deploy your contract:

```sh
npx hardhat run scripts/deploy.js --network localhost
```
