var UserHome = {}

UserHome.vm = {
  users: m.request({method: "GET", url: "/users", background: true, initialValue: []})
}


UserHome.controller = function () {
	var ctrl = {}

  ctrl.logOut = function (e) {
    localStorage.clear()
  }

  // ctrl.getUsers = function () {
  //   return {
  //     users: m.request({method: "GET", url: "/users", background: true, initialValue: []}).then(
  //     function (response) {
  //       console.log("Success",response)
  //       m.redraw()
  //       return response.users
  //     },
  //     function (error) {
  //       console.log("Error",error)
  //       return error
  //     }
  //   )}
  // }
	return ctrl
}

UserHome.view = function (ctrl) {
	return m('.users', [
    m('h1', "this is the users homepage"),
    UserHome.vm.users().users.map(userView),
    m("a[href='/']", {config: m.route, onclick: ctrl.logOut}, "Log Out")
    ]
  )

  function userView (user) {
    return m('div.user', {data: user}, user.username)
  }
}