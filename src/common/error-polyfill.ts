/*
 * Copyright © Time By Ping, Inc. 2021. All rights reserved.
 * Any unauthorized reproduction, distribution, public display, public performance or
 * derivatization thereof can constitute, among other things, an infringement of Time By Ping Inc.’s
 * exclusive rights under the Copyright Law of the U.S. (17 U.S.C. § 106) and may subject the
 * infringer thereof to severe legal liability.
 */
import { assign, pick } from 'lodash';

const TO_JSON_METHOD_NAME = 'toJSON';

if (!(TO_JSON_METHOD_NAME in Error.prototype)) {
  Object.defineProperty(Error.prototype, TO_JSON_METHOD_NAME, {
    value: function () {
      const { name, message } = this;
      const enumerablePropertyNames = Object.keys(this);
      const enumerableProperties = pick(this, enumerablePropertyNames);
      return assign(enumerableProperties, { name, message });
    },
    writable: true
  });
}
