
const debounceMap = new Map();

function debounceKey(key, delay = 3000, callback) {
  if (debounceMap.has(key)) {
     clearTimeout(debounceMap.get(key).timer);
  }

  const timer = setTimeout(() => {
    debounceMap.delete(key);
    callback();
  }, delay);

  debounceMap.set(key, { timer });
}

module.exports = { debounceKey };