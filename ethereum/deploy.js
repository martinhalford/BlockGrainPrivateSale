const HDWalletProvider = require("truffle-hdwallet-provider");
const Web3 = require("web3");
const compiledPrivateSale = require("./build/PrivateSale.json");

const provider = new HDWalletProvider(
  "author bicycle entire work mixture worth usual solve tilt shoot reopen dial",
  "https://rinkeby.infura.io/AzbtIwkXoMeeMOJ29fZN"
);

const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log("Attempting to deploy from account", accounts[0]);

  const result = await new web3.eth.Contract(
    JSON.parse(compiledPrivateSale.interface)
  )
    .deploy({ data: compiledPrivateSale.bytecode })
    .send({ gas: "1000000", from: accounts[0] });

  console.log("Contract deployed to", result.options.address);
};
deploy();
