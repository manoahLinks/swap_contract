import {
    time,
    loadFixture,
  } from "@nomicfoundation/hardhat-toolbox/network-helpers";
  import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
  import { expect } from "chai";
  import { ethers } from "hardhat";

  describe("Swap", () => {

    const deploySwapContract = async () => {

        const [owner, otherAccount] = await ethers.getSigners();

        const ManoToken = await ethers.getContractFactory("ManoToken");
        const manoToken = await ManoToken.deploy(owner);

        const TokenMano = await ethers.getContractFactory("TokenMano");
        const tokenMano = await TokenMano.deploy(owner);

        const Swap = await ethers.getContractFactory('Swap');
        const swap = await Swap.deploy(manoToken.target, tokenMano.target);

        return {manoToken, tokenMano, swap, owner, otherAccount}
    }

    describe("swap test", () => {
        it("should swap token", async () => {
            
            const {manoToken, tokenMano, swap, owner, otherAccount} = await loadFixture(deploySwapContract);

            const minitedAmount = 2000;
            const trsfredAmount = 500;

            // trnsfer liquidity to contract
            await manoToken.connect(owner).transfer(swap.target, trsfredAmount);

            await tokenMano.connect(owner).transfer(swap.target, trsfredAmount);

            // approve contract to spend tokens
            await manoToken.connect(owner).approve(swap.target, 500);
            
            await tokenMano.connect(owner).approve(swap.target, 500);

            await swap.connect(owner).swapToken(manoToken.target, tokenMano.target, 200);

            await expect(await manoToken.balanceOf(owner)).to.be.equal(minitedAmount - 700); 

            await expect(await tokenMano.balanceOf(swap.target)).to.be.equal(minitedAmount - 1900);
            
        })
    })

  })