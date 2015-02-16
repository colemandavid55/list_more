
// var a = { x: 11 }
// extend(a, { y: 22 })
// a.y //=> 22
//
// var result = extend({ x: 11 }, { y: 22 })

function extend (target, source) {
	for (var prop in source) {
		target[prop] = source[prop]
	}
	return target
}
