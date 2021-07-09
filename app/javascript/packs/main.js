import Vue from "vue/dist/vue.esm.js";
import Web3 from "web3/dist/web3.min.js";

document.addEventListener("DOMContentLoaded", () => {
  const app = new Vue({
    el: "#metamask-app",
    methods: {
      signin: async function () {
        window.web3 = new Web3(window.ethereum);
        try {
          const coinbase = await web3.eth.getCoinbase();
          if (!coinbase) {
            window.alert("Please activate MetaMask first.");
            return;
          }
          const publicAddress = coinbase.toLowerCase();
          fetch(
            `http://${window.location.host}/api/users?public_address=${publicAddress}`
          )
            .then((response) => response.json())
            .then((user) => (user ? user : this.handleSignup(publicAddress)))
            .then(this.handleSignMessage)
            .then(this.handleAuth)
            .then(this.redirect);
        } catch (error) {
          console.log(error);
        }
      },
      signout: async function () {
        try {
          fetch(`http://${window.location.host}/api/users/signout`, {
            method: "DELETE",
            headers: { "Content-Type": "application/json" },
          }).then(this.redirect);
        } catch (error) {
          console.log(error);
        }
      },
      handleSignup: async function (publicAddress) {
        return fetch(`http://${window.location.host}/api/users`, {
          body: JSON.stringify({ public_address: publicAddress }),
          method: "POST",
          headers: { "Content-Type": "application/json" },
        }).then((response) => response.json());
      },
      handleSignMessage: async function (user) {
        const publicAddress = user.public_address;
        const signature = await web3.eth.personal.sign(
          `[MetaMask Demo]\none-time nonce: ${user.nonce}`,
          publicAddress,
          ""
        );
        return { publicAddress, signature };
      },
      handleAuth: async function (publicAddressAndSignature) {
        return fetch(`http://${window.location.host}/api/users/signin`, {
          body: JSON.stringify({
            public_address: publicAddressAndSignature.publicAddress,
            signature: publicAddressAndSignature.signature,
          }),
          method: "POST",
          headers: { "Content-Type": "application/json" },
        });
      },
      redirect: async function () {
        window.location.href = `http://${window.location.host}`;
      },
    },
  });
});
