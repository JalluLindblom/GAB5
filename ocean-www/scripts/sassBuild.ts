
import path from 'path';
import util from 'util';
import fs from 'fs';
const fsp = fs.promises;

import sass from 'sass';

const sassRender = util.promisify(sass.render);

const inputFilename = "bundled/styles/style.scss";
const outputFilename = "public/bundles/style.css";

export const inputDirectory = path.dirname(inputFilename);

/**
 * Compiles Sass (.scss files) into CSS to be served to the client.
 * @param production If true, optimizes the output for production.
 */
export async function compile(production: boolean): Promise<void> {
    console.log(`Compiling sass from ${inputFilename} to ${outputFilename}...`);
    try {

        const enableSourceMap = !production;

        const options: sass.LegacyFileOptions<"async"> = {
            file: inputFilename,
            outFile: outputFilename,
            outputStyle: (production ? 'compressed' : undefined),
            sourceMap: enableSourceMap
        };
        const res = await sassRender(options);
        if (!res) {
            throw new Error("Failed to render Sass.");
        }

        const outputDir = path.dirname(outputFilename);
        if (!fs.existsSync(outputDir)) {
            await fsp.mkdir(outputDir, { recursive: true });
        }

        const cssBuffer = res.css;
        await fsp.writeFile(outputFilename, cssBuffer);
        console.log(`Sass compiled into "${outputFilename}".`);

        if (enableSourceMap) {
            const sourceMapBuffer = res.map || "";
            const sourceMapFilename = outputFilename + ".map";
            await fsp.writeFile(sourceMapFilename, sourceMapBuffer);
            console.log(`Sass source map written into "${sourceMapFilename}"`);
        }
    }
    catch (err: any) {
        console.error('Sass compilation failed:');
        console.error(err.toString());
    }
}
