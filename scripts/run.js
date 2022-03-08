const main = async () => {
  const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
  const waveContract = await waveContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.01"),
  });
  await waveContract.deployed();

  const money = ethers.utils.parseEther("0.001");

  // Get contract balance

  let contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

  // Send post

  let postTxn = await waveContract.createPost("Message 0", money);
  await postTxn.wait();

  postTxn = await waveContract.createPost("Message 1", 0);
  await postTxn.wait();

  // postTxn = await waveContract.createPost("Message 2", money);
  // await postTxn.wait();

  // postTxn = await waveContract.createPost("Message 3", money);
  // await postTxn.wait();

  // contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
  // console.log("Contract balance:", hre.ethers.utils.formatEther(contractBalance));

  let allPosts = await waveContract.getAllPosts();
  console.log("All posts: ", allPosts);

  postTxn = await waveContract.updatePost(allPosts[1].id, "ONE", money);
  await postTxn.wait();

  // postTxn = await waveContract.deletePost(allPosts[3].id);
  // await postTxn.wait();

  // postTxn = await waveContract.deletePost(allPosts[1].id);
  // await postTxn.wait();

  // postTxn = await waveContract.createPost("NEW 2", 0);
  // await postTxn.wait();

  // allPosts = await waveContract.getAllPosts();
  // console.log("All posts: ", allPosts);

  // postTxn = await waveContract.deletePost(allPosts[1].id);
  // await postTxn.wait();

  // Show deletePost() error
  // postTxn = await waveContract.connect(randomPerson).deletePost(1);
  // await postTxn.wait();

  allPosts = await waveContract.getAllPosts();
  console.log("All posts: ", allPosts);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();