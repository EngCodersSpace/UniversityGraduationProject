// utils/filterParser.js

/**
 * Applies dynamic filters to Sequelize query options.
 * Supports operators: eq, ne, gt, gte, lt, lte, like, in, notIn, between
 *
 * Example:
 * filters = {
 *   createdAt: { gte: '2024-01-01', lte: '2024-12-31' },
 *   name: { like: '%John%' },
 *   status: { in: ['active', 'pending'] }
 * }
*/
const { Op } = require('sequelize');

const operatorMap = {
  eq: Op.eq,
  ne: Op.ne,
  gt: Op.gt,
  gte: Op.gte,
  lt: Op.lt,
  lte: Op.lte,
  like: Op.like,
  in: Op.in,
  notIn: Op.notIn,
  between: Op.between,
};

function applyFiltersToQuery(queryOptions, filters) {
  queryOptions.where = {};

  for (const field in filters) {
    const conditions = filters[field];
    const whereClause = {};

    for (const op in conditions) {
      if (operatorMap[op]) {
        let value = conditions[op];

        // Convert comma-separated values to array for in/notIn
        if ((op === 'in' || op === 'notIn') && typeof value === 'string') {
          value = value.split(',');
        }

        // Convert between range to array
        if (op === 'between' && typeof value === 'string') {
          value = value.split(','); // e.g. "2023-01-01,2023-12-31"
        }

        whereClause[operatorMap[op]] = value;
      }
    }

    queryOptions.where[field] = whereClause;
  }

  return queryOptions;
}

module.exports = {
  applyFiltersToQuery,
};