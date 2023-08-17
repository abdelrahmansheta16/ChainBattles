const { expect } = require("chai");

describe("Token contract", function () {
  it("Deployment should assign the total supply of tokens to the owner", async function () {
    const [owner] = await ethers.getSigners();

    const hardhatToken = await ethers.deployContract("ChainBattles");

    const mint = await hardhatToken.mint();
    const train = await hardhatToken.train(1);
    const tracker = await hardhatToken.getTracker(1);
    console.log(tracker);
    // expect(await hardhatToken.getTracker()).to.equal(tracker);
  });
});