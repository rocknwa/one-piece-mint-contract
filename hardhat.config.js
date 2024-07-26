require('dotenv').config();
require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  defaultNetwork: "core",
  networks: {
    hardhat: {
    },
    core: {
      url: "https://rpc.test.btcs.network",
      accounts: [process.env.PRIVATE_KEY]
    }
  },

  solidity: {
		version: "0.8.20",
		settings: {
			evmVersion: 'paris',
			optimizer: {
				enabled: true,
				runs: 1000,
			},
		},
	},
}
