
/*
A script called by the build process that creates a .env file filled with
environment variables defined by the build process.
*/

import fs from "fs";
import path from "path";

const includedKeys = Object.keys(process.env)
    .filter(key => key.startsWith("APP_") || key.startsWith("_APP_"));

let envFileStr = includedKeys
    .map(key => `${key}="${process.env[key]}"`)
    .join("\n");

envFileStr += "\nAPP_BUILD_DATE=" + Date.now().toString();

const envFilename = path.join(path.dirname(__dirname), ".env");
fs.writeFileSync(envFilename, envFileStr);
