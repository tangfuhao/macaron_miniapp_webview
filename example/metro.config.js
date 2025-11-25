const { getDefaultConfig } = require('expo/metro-config');
const path = require('path');

const projectRoot = __dirname;
const monorepoRoot = path.resolve(projectRoot, '..');

const config = getDefaultConfig(projectRoot);

// Watch the monorepo root for changes (includes packages/miniapp)
config.watchFolders = [monorepoRoot];

// Add extra node_modules paths for resolving packages
config.resolver.nodeModulesPaths = [
  path.resolve(projectRoot, 'node_modules'),
  path.resolve(monorepoRoot, 'node_modules'),
];

// Resolve @macaron/miniapp to the local package
config.resolver.extraNodeModules = {
  '@macaron/miniapp': path.resolve(monorepoRoot, 'packages/miniapp'),
};

module.exports = config;

