/*
 * Copyright © Time By Ping, Inc. 2021. All rights reserved.
 * Any unauthorized reproduction, distribution, public display, public performance or
 * derivatization thereof can constitute, among other things, an infringement of Time By Ping Inc.’s
 * exclusive rights under the Copyright Law of the U.S. (17 U.S.C. § 106) and may subject the
 * infringer thereof to severe legal liability.
 */

/*  eslint-disable node/no-unpublished-require */

const path = require('path');
const nodeExternals = require('webpack-node-externals');
const TerserPlugin = require('terser-webpack-plugin');

module.exports = {
  entry: {
    'lambda/handlers': ['source-map-support/register', './src/handlers']
  },
  target: 'node',
  externals: [nodeExternals()],
  mode: 'production',
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /(?<!spec)\.ts$/,
        loader: "ts-loader",
        exclude: /node_modules/
      }
    ]
  },
  resolve: {
    modules: ['node_modules'],
    extensions: ['.ts', '.js']
  },
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'dist'),
    library: {
      type: 'commonjs'
    }
  },
  optimization: {
    minimize: true,
    minimizer: [new TerserPlugin()]
  }
};
