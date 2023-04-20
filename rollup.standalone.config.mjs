import nodeResolve from "@rollup/plugin-node-resolve";
import commonjs from '@rollup/plugin-commonjs';
import json from "@rollup/plugin-json";
import typescript from '@rollup/plugin-typescript';

export default {

  input: 'Temp/merged.js',
  
  output: {
    dir: 'public/js/export/',
    format: "es",
    strict: false,
    manualChunks: () => 'everything.js'
  },
  plugins    : [
  nodeResolve({
    jsnext: true,
    main: false
  }),
  json(),
  commonjs({transformMixedEsModules:true}),
  typescript({ compilerOptions: {lib: ["es5", "es6", "dom"], target: "es5"}})
  ]
};