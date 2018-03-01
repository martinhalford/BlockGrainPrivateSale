const path = require("path");
const solc = require("solc");
const fs = require("fs-extra");

const buildPath = path.resolve(__dirname, "build");
fs.removeSync(buildPath); //deletes folder

const privateSalePath = path.resolve(__dirname, "contracts", "PrivateSale.sol");
const source = fs.readFileSync(privateSalePath, "utf-8");

console.log(source);

const output = solc.compile(source, 1).contracts;

console.log(output);

fs.ensureDirSync(buildPath); //mkdir

for (let contract in output) {
  fs.outputJsonSync(
    path.resolve(buildPath, contract.replace(":", "") + ".json"),
    output[contract]
  );
}
