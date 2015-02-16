var UserLists = {}

UserLists.vm = {
  lists: [],
  userId: m.prop()
}

UserLists.controller = function () {
  var ctrl = {}

  ctrl.submit = function (e) {
    e.preventDefault();
    m.request({method: "POST", url: "users/" + UserLists.vm.userId() + "/lists", data: ctrl.list}).then(function () {
    UserLists.vm.lists = m.request({method: "GET", url: "users/" + UserLists.vm.userId() + "/lists"});
    m.route("/users/" + UserLists.vm.userId())
    }),

    console.log("list add clicked")
  }

  ctrl.list = {
    name: '',
    user_id: UserLists.vm.userId()
  }
	return ctrl
}

UserLists.view = function (ctrl) {
  return m('.lists', [
    m('div', {}, "This is the lists page"),
    UserLists.vm.lists().user_lists.map(listView),
    UserLists.vm.lists().shared_lists.map(listView), m('br'), m('br'),
    m('form.addList', binds(ctrl.list), [
      m('input[name=name]', {value: ctrl.list.name}),
      m('label', {}, "Name"), m('br'), m('br'),
      m('button', {onclick: ctrl.submit}, "Add List")
      ]),
    m("a[href='/']", {config: m.route, onclick: ctrl.logOut}, "Log Out")
    ]
  )

  function listView (list) {
    return [m("a[href='/lists/" + list.id + "']", {config: m.route}, list.name),
    m('br')]
  }

  function binds(data) {
    return {
      onchange: function(e) {
        data[e.target.name] = e.target.value;
      }
    };
  };
}