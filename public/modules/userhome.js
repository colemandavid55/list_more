var UserHome = {}

UserHome.vm = {
}


UserHome.controller = function () {
	var ctrl = {}
  var vm = UserHome.vm
  App.vm.syncUsers()



  ctrl.logOut = function (e) {
    console.log("logout selected")
    localStorage.clear()
    m.route('/')
  }

  ctrl.selectUser = function (userId) {
    // console.log("user selected");
    // UserLists.vm.lists = 
    m.request({method: "GET", url: "/users/" + userId + "/lists", data: {'token': App.vm.user().token}}).then(function (response) {
      UserLists.vm.userId(userId)
      UserLists.vm.userLists(response.user_lists)
      UserLists.vm.sharedLists(response.shared_lists)
    })
    // UserLists.vm.userId(userId);
    // console.log(UserLists.vm.lists)
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
      App.vm.users().map(userView),
      m("a[href='/']", {config: m.route, onclick: App.logOut}, "Log Out")
    ]
  )

  function userView (user) {
    var userId = user.id
    return [m("a[href='/users/" + userId + "']", {config: m.route, onclick: ctrl.selectUser.bind(null, userId)}, user.username),
    m('br')]
  }
}