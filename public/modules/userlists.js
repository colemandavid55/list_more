var UserLists = {}

UserLists.vm = {
  lists: []
}

UserLists.controller = function () {
  var ctrl = {}
	return ctrl
}

UserLists.view = function (ctrl) {
  return m('.lists', [
    m('div', {}, "This is the lists page"),
    UserLists.vm.lists().user_lists.map(listView),
    UserLists.vm.lists().shared_lists.map(listView),
    m("a[href='/']", {config: m.route, onclick: ctrl.logOut}, "Log Out")
    ]
  )

  function listView (list) {
    return [m("a[href='/lists/" + list.id + "']", {config: m.route}, list.name),
    m('br')]
  }
}