import * as Web3 from 'web3';
import { Network, OpenSeaPort } from 'opensea-js';

export const provider = new Web3.providers.HttpProvider('https://mainnet.infura.io')

export const seaport = new OpenSeaPort(provider, {
  networkName: Network.Main
});
