const { override, babelInclude } = require('customize-cra');
const path = require('path');

module.exports = override(
  // Permitir imports ES6 en node_modules (ej. axios)
  babelInclude([
    path.resolve('src'),
    path.resolve('node_modules/axios'),
  ])
);
