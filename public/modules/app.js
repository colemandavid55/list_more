

var App = {}


App.vm = {
	user: m.prop(null),
	
	users: m.prop([]),
  syncUsers: function () {
    var vm = App.vm
    if(vm.user()) {
    	console.log("Syncing users")
	    m.request({method: "GET", url: "/users", data: {'token': vm.user().token}}).then(function (response) {
	      vm.users(response.users)
	    })
	  } else {
    	console.log("Redirecting to /")
	  	m.route('/')
	  }
  }
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
	App.vm.syncUsers()
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
	}
	else {
		m.route('/')
	}
}

App.logOut = function() {
	m.request({method: "POST", url: "/logout", data: App.vm.user(), background: true})
	App.vm.user(null)
	localStorage.clear()
	m.route('/')
}
