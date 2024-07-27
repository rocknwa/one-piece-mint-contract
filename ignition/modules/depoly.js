const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("OnePiecePersonalityDappModule", (m) => {
  // Define the contract to be deployed
  const onePiecePersonalityDapp = m.contract("OnePieceMint");

  // Log the address where the contract is deployed
 /* m.(async () => {
    const address = await onePiecePersonalityDapp.getAddress();
    console.log("OnePiecePersonalityDapp deployed to:", address);
  });*/

  return { onePiecePersonalityDapp };
});
