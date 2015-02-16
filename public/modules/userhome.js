var UserHome = {}

UserHome.vm = {
  users: m.request({method: "GET", url: "/users", background: true, initialValue: []})
}


UserHome.controller = function () {
	var ctrl = {}

  ctrl.logOut = function (e) {
    console.log("logout selected")
    localStorage.clear()
  }

  ctrl.selectUser = function (userId) {
    console.log("user selected");
    UserLists.vm.lists = m.request({method: "GET", url: "/users/" + userId + "/lists"});
    UserLists.vm.userId(userId);
    console.log(UserLists.vm.lists)
    return true
  }

  // ctrl.submit = function (userId) {
  //   ctrl.selectUser.userId = userId
  //   console.log('lists requested for user:', ctrl.selectedUser.userId)
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
    var userId = user.id
    return [m("a[href='/users/" + userId + "']", {config: m.route, onclick: ctrl.selectUser.bind(null, userId)}, user.username),
    m('br')]
  }
}