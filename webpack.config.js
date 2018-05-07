const webpack = require('webpack');

module.exports = {
    entry: './tmp/integration.js',
    output: {
        filename: 'web/js/react-integration.js',
    },
    module: {
        loaders: [
            {
                test: /\.js$/,
                loader: 'babel-loader',
                exclude: /node_modules/,
                query: {
                    presets: ['es2015', 'react']
                }
            }
        ]
    }
};