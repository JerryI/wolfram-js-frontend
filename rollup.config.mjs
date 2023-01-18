import nodeResolve from "@rollup/plugin-node-resolve";

export default {

  input: 'temp/merged.js',
  
  output: {
    file: 'build/bundle.js',
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