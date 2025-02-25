import typescript from '@rollup/plugin-typescript';
import resolve from '@rollup/plugin-node-resolve';
import postcss from 'rollup-plugin-postcss';
import terser from '@rollup/plugin-terser';
import tailwindcss from 'tailwindcss';
import autoprefixer from 'autoprefixer';

export default {
    input: 'src/index.ts',
    output: {
        file: '../chrome-extension/bundle.js',
        format: 'iife',
        name: 'MyExtensionComponent',
        sourcemap: false
    },
    plugins: [
        typescript({
            compilerOptions: {
                declaration: false,
                declarationDir: null,
                sourceMap: false
            },
            outputToFilesystem: false
        }),
        resolve(),
        postcss({
            config: {
                path: './postcss.config.cjs'
            },
            extensions: ['.css'],
            minimize: true,
            inject: false,
            extract: false,
            modules: false,
            plugins: [
                tailwindcss(),
                autoprefixer()
            ]
        }),
        terser({
            format: {
                comments: false
            }
        })
    ]
};