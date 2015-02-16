var UserItems = {}

UserItems.vm = {
	items: [],
	userId: m.prop(),
	listId: m.prop()
}

UserItems.controller = function () {
	var ctrl = {}

  ctrl.submit = function (e) {
    e.preventDefault();
    m.request({method: "POST", url: "/lists/" + UserItems.vm.listId() + "/items", data: ctrl.item}).then(function () {
      UserItems.vm.items = m.request({method: "GET", url: "/lists/" + UserItems.vm.listId()});
      m.route("/lists/" + UserItems.vm.listId())
    }),

    console.log("item add clicked")
  }

  ctrl.logOut = function (e) {
    console.log("logout selected")
    localStorage.clear()
  }



  ctrl.item = {
    content: '',
    user_id: UserItems.vm.userId(),
    list_id: UserItems.vm.listId()
  }

	return ctrl
}

UserItems.view = function (ctrl) {
  return m('.items', [
    m('h1', {}, "This is the items page"),
    UserItems.vm.items().items.map(itemView), m('br'), m('br'),
    m('form.addItem', binds(ctrl.item), [
      m('textarea[name=content]', {value: ctrl.item.content}), m('br'),
      m('label', {}, "Item"), m('br'), m('br'),
      m('button', {onclick: ctrl.submit}, "Add Item")
      ]),
    m("a[href='/']", {config: m.route, onclick: ctrl.logOut}, "Log Out")
    ]
  )

  function itemView (item) {
    return [m("div.item", {}, item.content),
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