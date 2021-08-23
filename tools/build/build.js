#!/usr/bin/env node
/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

const { resolve: resolvePath } = require('path');
const { resolveGlob } = require('./cbt/fs');
const { exec } = require('./cbt/process');
const { Task, runTasks } = require('./cbt/task');
const { regQuery } = require('./cbt/winreg');

// Change working directory to project root
process.chdir(resolvePath(__dirname, '../../'));

const DME_NAME = 'baystation12';

export const DefineParameter = new Juke.Parameter({
  type: 'string[]',
  alias: 'D',
});

export const MapOverrideParameter = new Juke.Parameter({
  type: 'string',
  alias: 'M',
})

export const PortParameter = new Juke.Parameter({
  type: 'string',
  alias: 'p',
});

export const CiParameter = new Juke.Parameter({
  type: 'boolean',
});

export const DmMapsIncludeTarget = new Juke.Target({
  executes: async () => {
    const folders = [
      ...Juke.glob('maps/away/**/*.dmm'),
      ...Juke.glob('maps/random_ruins/**/*.dmm'),
      ...Juke.glob('maps/RandomZLevels/**/*.dmm'),
      ...Juke.glob('maps/shipmaps/**/*.dmm'),
      ...Juke.glob('maps/templates/**/*.dmm'),
    ];
    const content = folders
      .map((file) => file.replace('maps/', ''))
      .map((file) => `#include "${file}"`)
      .join('\n') + '\n';
    fs.writeFileSync('maps/templates.dm', content);
  },
});

export const DmTarget = new Juke.Target({
  dependsOn: ({ get }) => [
    get(DefineParameter).includes('ALL_MAPS') && DmMapsIncludeTarget,
  ],
  inputs: [
    'Haven/**',
    'maps/**',
    'code/**',
    'html/**',
    'icons/**',
    `${DME_NAME}.dme`,
  ],
  outputs: [
    `${DME_NAME}.dmb`,
    `${DME_NAME}.rsc`,
  ],
  parameters: [DefineParameter],
  executes: async ({ get }) => {
    const includes = [];
    const defines = get(DefineParameter);
    const map_override = get(MapOverrideParameter);
    if (map_override) {
      Juke.logger.info('Using override map:', map_override);
      defines.push("MAP_OVERRIDE");
      includes.push(`maps/${map_override}/${map_override}.dm`)
    }
    if (defines.length > 0) {
      Juke.logger.info('Using defines:', defines.join(', '));
    }
    await DreamMaker(`${DME_NAME}.dme`, {
      defines: ['CBT', ...defines],
      includes: [...includes],
    });
    await yarn(['install']);
    await yarn(['run', 'webpack-cli', '--mode=production']);
  });

const taskDm = new Task('dm')
  .depends('code/**')
  .depends('html/**')
  .depends('maps/**')    // These two lines here are added only because
  .depends('Haven/**')   // Baycode does not use tg's JSON system for maps
  .depends('tgui/public/tgui.html')
  .depends('tgui/public/*.bundle.*')
  .depends('tgui/public/*.chunk.*')
  .depends('baystation12.dme')
  .provides('baystation12.dmb')
  .provides('baystation12.rsc')
  .build(async () => {
    let compiler = 'dm';
    // Let's do some registry queries on Windows, because dm is not in PATH.
    if (process.platform === 'win32') {
      const installPath = (
        await regQuery(
          'HKLM\\Software\\Dantom\\BYOND',
          'installpath')
        || await regQuery(
          'HKLM\\SOFTWARE\\WOW6432Node\\Dantom\\BYOND',
          'installpath')
      );
      if (installPath) {
        compiler = resolvePath(installPath, 'bin/dm.exe');
      }
    } else {
      compiler = 'DreamMaker';
    }
    await exec(compiler, ['baystation12.dme']);
  });

// Frontend
const tasksToRun = [
  taskTgui,
  taskDm,
];

if (process.env['TG_BUILD_TGS_MODE']) {
  tasksToRun.pop();
}

runTasks(tasksToRun);
