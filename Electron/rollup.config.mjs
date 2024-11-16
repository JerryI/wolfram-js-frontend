//@ts-check
import nodeResolve from "@rollup/plugin-node-resolve";
import commonjs from '@rollup/plugin-commonjs';
import json from "@rollup/plugin-json";

export default {

  input: 'log.js',
  
  output: {
    dir: 'bundle',
    format: "es",
    strict: false
  },
  plugins    : [
  nodeResolve({
    jsnext: true,
    main: false
  }),
  json(),
  commonjs({transformMixedEsModules:true})
  ]
};