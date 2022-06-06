/*****************************************************************************************************
 ██████╗░███████╗░██████╗░███████╗███╗░░██╗  ██████╗░░██╗░░░░░░░██╗░█████╗░██████╗░███████╗░██████╗
 ██╔══██╗██╔════╝██╔════╝░██╔════╝████╗░██║  ██╔══██╗░██║░░██╗░░██║██╔══██╗██╔══██╗██╔════╝██╔════╝
 ██║░░██║█████╗░░██║░░██╗░█████╗░░██╔██╗██║  ██║░░██║░╚██╗████╗██╔╝███████║██████╔╝█████╗░░╚█████╗░
 ██║░░██║██╔══╝░░██║░░╚██╗██╔══╝░░██║╚████║  ██║░░██║░░████╔═████║░██╔══██║██╔══██╗██╔══╝░░░╚═══██╗
 ██████╔╝███████╗╚██████╔╝███████╗██║░╚███║  ██████╔╝░░╚██╔╝░╚██╔╝░██║░░██║██║░░██║██║░░░░░██████╔╝
 ╚═════╝░╚══════╝░╚═════╝░╚══════╝╚═╝░░╚══╝  ╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═════╝░
  Contract Developer: Stinky (@nomamesgwei)
******************************************************************************************************/

const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");
const BigNumber = require('bignumber.js');

describe("Degen Dwarfs Discount TEST", function () {
  let NFT;
  let DWARF;
  let owner;
  let addr1;
  let addr2;
  let addrs;
  let provider;

  beforeEach(async function () {
    provider = waffle.provider;

    NFT = await ethers.getContractFactory("DegenDwarfs");

    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
    
    DWARF = await NFT.deploy(owner.address, "Degen Dwarfs", "DD", "https://assets.degendwarfs.io/json/");
    await DWARF.deployed();

  });

  describe("Deployment", function () {
    it("Verify Address Owner", async function () {
      expect(await DWARF.owner()).to.equal(owner.address);
    });

    it("Verify $DD supply is 0", async function () {
      expect(await DWARF.totalSupply()).to.equal(0);
    });

  });

  describe("Mint", function () {

    it("Verify Supply equals 0", async function () {
      let supply = await DWARF.totalSupply();
      expect(supply).to.be.equal(0);

    });

    it("Add Discounts to 2 Addresses, and mint", async function () {
        await DWARF.addDiscounts([owner.address, addr1.address], [ethers.utils.parseEther("0.2"), ethers.utils.parseEther("0.5")]);

        // console.log("Owners discount: " + await DWARF.checkMath(owner.address));
        // console.log("Addr1 discount: " + await DWARF.checkMath(addr1.address));

        let overrides = {value: ethers.utils.parseEther("0.0552")};
        await DWARF.discount(overrides);

        let supply = await DWARF.totalSupply();
        expect(supply).to.be.equal(1);

        let override = {value: ethers.utils.parseEther("0.0345")};
        await DWARF.connect(addr1).discount(override);

        expect(await DWARF.totalSupply()).to.be.equal(2);
    });
  });

});
