var _ = require('lodash');

module.exports = {
  app: {
    helpers: function(obj) {
      _.extend(this.helpers, obj);
    }
  },
  conf: require('../../../conf'),
  logger: {
    add: function() {
      return {
        trace: _.partial(console.log, '[trace] '),
        debug: _.partial(console.log, '[debug] '),
        info: _.partial(console.log, '[info] '),
        warn: _.partial(console.log, '[warn] '),
        error: _.partial(console.log, '[error] '),
      };
    }
  }
};
