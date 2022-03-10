//Degen Dwarf Gnosis Safe
const BENEFICIARY = "0x4b0Ca72c5D8cba2805b9cD712be062b40dA24C38";
const NAME = "Degen Dwarfs";
const TICKER = "DD";
const TOKEN_URI = "https://assets.degendwarfs.io/json/";

async function main() {
  if (network.name === "hardhat") {
    console.warn(
      "You are trying to deploy a contract to the Hardhat Network, which" +
        "gets automatically created and destroyed every time. Use the Hardhat" +
        " option '--network localhost'"
    );
  }

  const [deployer] = await ethers.getSigners();

  console.log(
    "Deploying the contracts with the account:",
    await deployer.getAddress()
  );

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const Token = await ethers.getContractFactory("DegenDwarfs");
  const token = await Token.deploy(BENEFICIARY, NAME, TICKER, TOKEN_URI);
  await token.deployed();

  console.log("NFT address:", token.address);

  saveFrontendFiles(token);
}

function saveFrontendFiles(token) {
  const fs = require("fs");
  const contractsDir = __dirname + "";

  if (!fs.existsSync(contractsDir)) {
    fs.mkdirSync(contractsDir);
  }

  fs.writeFileSync(
    contractsDir + "/contract-address.json",
    JSON.stringify({ DegenDwarfs: token.address}, undefined, 2)
  );

  const TokenArtifact = artifacts.readArtifactSync("DegenDwarfs");

  fs.writeFileSync(
    contractsDir + "/DegenDwarfs.json",
    JSON.stringify(TokenArtifact, null, 2)
  );
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
