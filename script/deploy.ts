import { upgrades, ethers } from "hardhat";

const main = async () => {
  const TKTChainFactory = await ethers.getContractFactory("TKTChainFactory");
  const factory = await upgrades.deployProxy(TKTChainFactory, [ethers.parseEther("0.01"), "0x47Fb2585D2C56Fe188D0E6ec628a38b74fCeeeDf"], {
    kind: "uups",
  });

  await factory.waitForDeployment();

  const factoryAddress = await factory.getAddress();

  console.log(`TKT Chain Factory Proxy Deployed on Address: ${factoryAddress}`);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
