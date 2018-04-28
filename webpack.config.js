const webpack = require('webpack');

module.exports = {
    entry: './node_modules/sci-frontend/src/assets/js/integration.js',
    output: {
        filename: 'web/js/integration.js',
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
    },
    plugins: [
        new webpack.DefinePlugin({
            'process.env': {
                NODE_ENV: '"production"'
            }
        }),
    ],
};