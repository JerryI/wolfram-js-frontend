import nodeResolve from "@rollup/plugin-node-resolve";
import commonjs from '@rollup/plugin-commonjs';
import json from "@rollup/plugin-json";

export default {

  input: 'rendererSrc.js',
  
  output: {
    dir: 'build',
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