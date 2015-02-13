var UserHome = {}


UserHome.controller = function () {
	var ctrl = {}

  ctrl.logOut = function (e) {
    localStorage.clear()
  }
	return ctrl
}

UserHome.view = function (ctrl) {
	return m('.userpage', [m('h1', "this is the users homepage"),
  m("a[href='/']", {config: m.route, onclick: ctrl.logOut}, "Log Out")
  ])
}