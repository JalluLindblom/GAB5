
import webpack from 'webpack';
import path from 'path';

const conf: webpack.Configuration = {
    entry: ["./bundled/index.js"],
    module: {
        rules: [{
                test: /\.(js|jsx|ts|tsx)$/,
                exclude: /(node_modules|bower_components)/,
                loader: "babel-loader",
                options: { presets: ["@babel/env"] }
            }
        ]
    },
    resolve: { extensions: ["*", ".js", ".jsx", ".ts", ".tsx"] },
    output: {
        path: path.resolve(__dirname, "public/bundles/"),
        publicPath: "public/bundles/",
        filename: "bundle.js"
    }
};

export default conf;
