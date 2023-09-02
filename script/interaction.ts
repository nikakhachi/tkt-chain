import { upgrades, ethers } from "hardhat";

const PROXY = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";

const main = async () => {
  const provider = ethers.provider;
  const wallet = new ethers.Wallet("0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80", provider); // Replace with your private key

  const factory = await ethers.getContractAt("TKTChainFactoryV2", PROXY);

  // Create a transaction with the encoded function selector in the data field
  const tx = await wallet.sendTransaction({
    to: PROXY,
    value: ethers.parseEther("0.1"),
    data: factory.interface.encodeFunctionData("createEvent(string,string,string,uint256,(uint256,uint256)[])", ["", "", "", 0, []]),
  });

  await tx.wait();

  const logs = await provider.getLogs({
    address: PROXY,
    fromBlock: 0, // Starting block
    toBlock: "latest", // Ending block (or 'latest' for the latest block)
    topics: [ethers.id("EventCreated(address,address,uint256)")],
  });

  // Parse and process the event logs
  logs.forEach((log) => {
    console.log("------");
    const parsedLog = factory.interface.parseLog({
      topics: [...log.topics],
      data: log.data,
    });

    console.log("Event Address: ", parsedLog?.args.eventAddress);
    console.log("Owner: ", parsedLog?.args.owner);
    console.log("Timestamp: ", parsedLog?.args.timestamp);
  });

  console.log(logs.length);
};

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
