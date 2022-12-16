//contract deployed to  0x02Bb8c858612c245584E044B31b7DeC819136d0C
const main = async()=>{
    try{
        const nftContractFactory = await hre.ethers.getContractFactory("ChainBattles")
        const nftContract = await nftContractFactory.deploy();
        await nftContract.deployed();

        console.log('contract deployed to ',nftContract.address);
        process.exit(0);

    }catch(error){
        console.log(error)
        process.exit(1);
    }
};

main();