// Copyright (C) 2023 TomTom NV. All rights reserved.

module.exports = {
  gitAuthor: 'Renovate Bot <renovatebot@github.com>',
  username: 'TomTomSdkIntegration[bot]',
  onboarding: false,
  platform: 'github',
  repositories: [
    process.env.RENOVATE_TARGET_REPOSITORY,
  ],
  allowedPostUpgradeCommands: [
    "bundle exec pod install"
  ],
  customEnvVariables: {
    // build variables
    "CP_HOME_DIR": process.env.CP_HOME_DIR,
    "BUNDLE_GEMFILE": process.env.BUNDLE_GEMFILE
  },
  hostRules: [
    {
      matchHost: 'repositories.tomtom.com',
      authType: 'Basic',
      username: process.env.RENOVATE_ARTIFACTORY_USERNAME,
      password: process.env.RENOVATE_ARTIFACTORY_PASSWORD
    }
  ]
};
