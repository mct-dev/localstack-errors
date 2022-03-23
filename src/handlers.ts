/*
 * Copyright © Time By Ping, Inc. 2021. All rights reserved.
 * Any unauthorized reproduction, distribution, public display, public performance or
 * derivatization thereof can constitute, among other things, an infringement of Time By Ping Inc.’s
 * exclusive rights under the Copyright Law of the U.S. (17 U.S.C. § 106) and may subject the
 * infringer thereof to severe legal liability.
 */
// import 'reflect-metadata';
// import './common/error-polyfill';

import { Handler } from 'aws-lambda';
import { v4 } from 'uuid';
// import { ScheduledEvent, ScheduledHandler } from 'aws-lambda';

// import { DependencyContainer } from './common/dependency-container';
// import { ExportSchedulerLambdaHandler } from './lambda-handlers/export-scheduler-lambda-handler';
// import { LambdaHandler } from './lambda-handlers/lambda-handler';

// const dependency = new DependencyContainer();

// export const exportScheduler: ScheduledHandler = async (event, context) => {
export const test: Handler = async (event, context) => {
  // const handler = dependency.container.resolve<LambdaHandler<ScheduledEvent, void>>(
  //   ExportSchedulerLambdaHandler
  // );
  // return await handler.execute(event, context);
  console.log(v4());
  return {
    statusCode: 200,
    body: JSON.stringify({
      guid: v4()
    })
  };
};
