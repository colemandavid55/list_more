
// var results = Array.reject([10,11,12,13], function (item) { return item <= 11 })
// results //=> [12, 13]
// 
Array.reject = function (array, rejecterFn) {
	var results = []
	for (var x in array) {
		if (!rejecterFn(array[x])) {
			results.push(array[x])
		}
	}
	return results
}
