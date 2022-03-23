import Joi from 'joi';
import yargs from 'yargs';

import { copyFile, rm, mkdir } from 'fs/promises';
import path from 'path';
import { execSync } from 'child_process';

const logger = console;
const schema = Joi.object({}).unknown();

yargs
  .scriptName(__filename)
  .usage('$0 <options>')
  .check((argv): boolean => {
    const { error } = schema.validate(argv, { abortEarly: true });
    if (error) {
      throw new Error(
        `invalid argument '${error.details[0].path[0]}': ${error.details[0].message}`
      );
    }
    return true;
  })
  .help()
  .alias('h', 'help')
  .parseSync();

const root = path.join(__dirname, '../..');

const clean = async (): Promise<void> => {
  try {
    logger.info('Removing /dist directory...');
    await rm(`${root}/dist`, { force: true, recursive: true });
  } catch (error) {
    logger.error('Failed to clean dist directory');
    logger.error(error);
  }
};

const buildRelease = async (): Promise<void> => {
  try {
    logger.info('Building for release...');
    await mkdir(`${root}/dist`);
    execSync('npm run release:compile');

    await copyFile(`${root}/package.json`, `${root}/dist/lambda/package.json`);
    await copyFile(`${root}/package-lock.json`, `${root}/dist/lambda/package-lock.json`);

    process.chdir(`${root}/dist/lambda`);
    execSync('npm ci --production');

    logger.info('Creating lambda zip file...');
    execSync('zip -r ../lambda.zip *', { stdio: 'ignore' });

    logger.info('Done.');
  } catch (error) {
    logger.error('Failed to build for release.');
    logger.error(error);
  }
};

(async function () {
  await clean();
  await buildRelease();
})();
