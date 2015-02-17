

var App = {}


App.vm = {
	user: m.prop(null)
}

App.signIn = function (userData) {
	App.vm.user({
					'id': userData.id,
					'username': userData.username,
					'token': userData.token
				})
	// Also store in localstorage
	localStorage.setItem('id', userData.id)
	localStorage.setItem('username', userData.username)
	localStorage.setItem('token', userData.token)
}

App.attemptSignIn = function () {
	// Check localstorage and run App.signIn if possible
	if (localStorage.getItem('token')) {
		console.log("Attempting auto sign in")
		App.signIn({
			'id': localStorage.getItem('id'),
			'username': localStorage.getItem('username'),
			'token': localStorage.getItem('token')
		})
		m.route('/users')
	}
	else {
		m.route('/')
	}
}
