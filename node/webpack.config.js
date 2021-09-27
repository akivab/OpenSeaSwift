var path = require('path')
var webpack = require('webpack')
var base64 = require('base-64')

var whatwgFetch = require('whatwg-fetch')

module.exports = {
  target: 'web',
  entry: { OpenSeaJS: "./index.js" },
  output: {
    filename: "[name].bundle.js",
    path: path.resolve(__dirname, "dist"),
    libraryTarget: 'umd',
    library: '[name]',
    umdNamedDefine: true,
    globalObject: `(typeof self !== 'undefined' ? self : this)`

  },
  mode: 'production',
  resolve: {
    fallback: {
      util: require.resolve("util/"),
      path: require.resolve("path-browserify"),
      crypto: require.resolve("crypto-browserify"),
      buffer: require.resolve("buffer/"),
      https: require.resolve("https-browserify"),
      http: require.resolve("stream-http"),
      os: require.resolve("os-browserify/browser"),
      vm: require.resolve("vm-browserify"),
      stream: require.resolve("stream-browserify"),
      constants: require.resolve("constants-browserify"),
      assert: require.resolve("assert/"),
    },
  },
  plugins: [
    new webpack.DefinePlugin({
      btoa: base64.encode,
      atob: base64.decode,
      fetch: whatwgFetch.fetch
    }),
    new webpack.ProvidePlugin({
      Buffer: ['buffer', 'Buffer'],
    }),
    new webpack.ProvidePlugin({
      process: "process/browser"
    })
  ],
};
