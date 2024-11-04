require('dotenv').config();
const contractJson = require('./build/contracts/FundMe.json');
const ethers = require('ethers');
const {INFURA_PROJECT_ID, MNEMONIC_PHRASE} = process.env;

const CONTRACE_ADDRESS = "0x93f2A95d31F8FD24AD1B4B2550D879762B77ffF8";
const provider = new ethers.InfuraProvider("sepolia", INFURA_PROJECT_ID);
const contract = new ethers.Contract("0x93f2A95d31F8FD24AD1B4B2550D879762B77ffF8", contractJson.abi, provider)

const wallet = ethers.Wallet.fromPhrase(MNEMONIC_PHRASE).connect(provider);

// async function sendEther() {
//     try {
//         const res = await wallet.sendTransaction({
//             to: CONTRACE_ADDRESS,
//             value: ethers.parseEther("0.28")
//         });
//         console.log("Transaction hash: ", res.hash);
//         recept = await res.wait();
//         console.log("Transaction mined in block: ", recept.blockNumber);
        
//     } catch (err) {
//         console.error(err);
//     }
// }

// sendEther().then(async () => {
//     const balance = await provider.getBalance(contract.address);
//     console.log("Balance: ", balance.toString());
// }).catch(err => {
//     console.error(err);
// })


contract.getBalance().then(balance => {
    console.log("Balance: ", balance.toString());
}).catch(err => {
    console.error(err);
})
