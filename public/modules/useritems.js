var UserItems = {}

UserItems.vm = {
	items:  m.prop([]),
	userId: m.prop(),
	listId: m.prop(),
  sync: function () {
    var vm = UserItems.vm
    m.request({ method: "GET", url: "/lists/" + m.route.param('id'), data: {'token': App.vm.user().token}}).then(function (response) {
      console.log(response)
      vm.items(response.items)
      vm.userId()
    })
  }
}

UserItems.controller = function () {
	var ctrl = {
    item: {
      content: '',
      user_id: UserItems.vm.userId(),
      list_id: UserItems.vm.listId()
    }
  }
  var vm = UserItems.vm
  vm.userId( m.route.param("userId") )
  vm.listId( m.route.param("id") )
  vm.sync()



  ctrl.submit = function (e) {
    e.preventDefault();
    m.request({method: "POST", url: "/lists/" + vm.listId() + "/items", data: ctrl.item}).then(function () {
      vm.sync()
      m.route("/lists/" + vm.listId())
    }),

    console.log("item add clicked")
  }

  ctrl.logOut = function (e) {
    console.log("logout selected")
    localStorage.clear()
  }

  ctrl.isOwner = function () {
    response = (App.vm.user().id == vm.userId()) ?
      "none" : "display:none";
    return response
  }

  ctrl.deleteItem = function (item, e) {
    e.preventDefault();
    console.log("item:",item)

    // Find and remove deleted item
    
    var newItemArray = Array.reject(vm.items(), function (it) {
      return it.id === item.id
    })
    vm.items(newItemArray)

    extend(item, {'token': App.vm.user().token})

    m.request({method: "DELETE", url: "/items/" + item.id, data: item, background: true})//.then(function () {
    //   vm.items = m.request({method: "GET", url: "/lists/" + vm.listId()});
    //   m.route("/lists/" + vm.listId())
    // })

    console.log("item delete clicked")
  }

  ctrl.editItem = function (item, e) {
    e.preventDefault();
    console.log("Attempting to edit", item, '/items/' + item.id)
    m.route('/items/' + item.id)
  }

	return ctrl
}

UserItems.view = function (ctrl) {
  return m('.items', [
    m('h1', {}, "This is the items page"),
    UserItems.vm.items().map(itemView), m('br'), m('br'),
    // m('form.addItem', {style: ctrl.isOwner()}, binds(ctrl.item)}, [
    m('form.addItem', binds(ctrl.item, { style: ctrl.isOwner() }), [
      m('textarea[name=content]', {value: ctrl.item.content}), m('br'),
      m('label', {}, "Item"), m('br'), m('br'),
      m('button', {onclick: ctrl.submit}, "Add Item")
      ]),
    m("a[href='/']", {config: m.route, onclick: ctrl.logOut}, "Log Out")
    ]
  )

  function itemView (item) {
    return [m("div.item", {}, item.content),
    m('form.deleteItem', binds(ctrl.item), [
      m("input[type=hidden]", {value: ctrl.item}),
      m('button', {onclick: ctrl.deleteItem.bind(null, item), style: ctrl.isOwner()}, "Delete")
      ]),
    m('form.editItem', binds(ctrl.item), [
      m("input[type=hidden]", {value: ctrl.item}),
      m('button', {onclick: ctrl.editItem.bind(null, item), style: ctrl.isOwner()}, "Edit")
      ]),
    m('br')]
  }


  function binds(targetObj, attrs) {
    attrs || (attrs = {})
    return extend(attrs, {
      onchange: function(e) {
        targetObj[e.target.name] = e.target.value;
      }
    });
  };
}