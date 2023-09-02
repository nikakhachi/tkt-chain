import { upgrades, ethers } from "hardhat";

const PROXY = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

const main = async () => {
  const TKTChainFactoryV2 = await ethers.getContractFactory("TKTChainFactoryV2");
  const factoryV2 = await upgrades.upgradeProxy(PROXY, TKTChainFactoryV2);

  await factoryV2.waitForDeployment();

  console.log(`Implementation ${await factoryV2.version()} has been Deployed`);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
