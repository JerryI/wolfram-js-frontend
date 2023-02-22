import nodeResolve from "@rollup/plugin-node-resolve";

export default {

  input: 'Temp/merged.js',
  
  output: {
    file: 'Temp/bundle.js',
    format: 'cjs',
    strict: false
  },
  plugins    : [
  nodeResolve({
    jsnext: true,
    main: false
  })
  ]
};