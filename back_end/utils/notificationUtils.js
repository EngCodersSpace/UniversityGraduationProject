const { Parser } = require("expr-eval");

function isNotificationRelevant(userTopics, condition) {
  if (!condition || typeof condition !== "string") {
    return false;
  }

  const safeCondition = condition
    .replace(/&&/g, "and")
    .replace(/\|\|/g, "or");

  const parser = new Parser();

  const tokens = [...new Set(safeCondition.match(/\b[a-zA-Z_][a-zA-Z0-9_]*\b/g))];

  const context = {};
  tokens.forEach(token => {
    context[token] = userTopics.includes(token);
  });

  try {
    const expr = parser.parse(safeCondition);
    return expr.evaluate(context);
  } catch (error) {
    console.error("Invalid condition:", condition, error.message);
    return false;
  }
}

function convertToFcmCondition1(expr) {
  const parser = new Parser();
  const ast = parser.parse(expr);

  function walk(node) {
    if (node.type === 'Literal') {
      return `'${node.value}' in topics`;
    }

    if (node.type === 'Identifier') {
      return `'${node.name}' in topics`;
    }

    if (node.type === 'BinaryExpression') {
      const operator = node.operator === '||' ? '||' : '&&';
      return `(${walk(node.left)} ${operator} ${walk(node.right)})`;
    }

    throw new Error(`Unsupported node type: ${node.type}`);
  }

  return walk(ast);
}

function convertToFcmCondition(expr) {
  return expr.replace(/\b([a-zA-Z0-9_]+)\b/g, "'$1' in topics");
}


module.exports={isNotificationRelevant, convertToFcmCondition};