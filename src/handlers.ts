/*
 * Copyright © Time By Ping, Inc. 2021. All rights reserved.
 * Any unauthorized reproduction, distribution, public display, public performance or
 * derivatization thereof can constitute, among other things, an infringement of Time By Ping Inc.’s
 * exclusive rights under the Copyright Law of the U.S. (17 U.S.C. § 106) and may subject the
 * infringer thereof to severe legal liability.
 */
import { Handler } from 'aws-lambda';
import { v4 } from 'uuid';
export const test: Handler = async (event, context) => {
  console.log(v4());

  return {
    statusCode: 200,
    body: JSON.stringify({
      guid: v4()
    })
  };
};
