var UserItems = {}

UserItems.vm = {
	items:  m.prop([]),
	userId: m.prop(),
	listId: m.prop(),
  
  editingItem: m.prop(null),

  sync: function () {
    var vm = UserItems.vm
    console.log("Making request to /lists/" + m.route.param('id'))
    m.request({ method: "GET", url: "/lists/" + m.route.param('id'), data: {'token': App.vm.user().token}}).then(function (response) {
      console.log(response)
      vm.items(response.items)
      vm.userId()
    })
  }
}

UserItems.controller = function () {
	var ctrl = {
    newItem: {
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
    m.request({method: "POST", url: "/lists/" + vm.listId() + "/items", data: ctrl.newItem}).then(function () {
      vm.sync()
      m.route("/users/" + vm.userId() + "/lists/" + vm.listId())
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

  ctrl.submitEditing = function (e) {
    var item = vm.editingItem();
    e.preventDefault();
    var newArray = vm.items().forEach(function (item_iterator) {
      if (item.id == item_iterator.id) {
        item_iterator['content'] = item.content
      }
    })

    extend(item, {'token': App.vm.user().token})

    m.request({method: "PUT", url: "/items/" + item.id, data: item, background: true})
    vm.editingItem(null)
  }

  ctrl.editItem = function (item, e) {
    e.preventDefault();
    console.log("Attempting to edit", item, '/items/' + item.id)
    UserItems.vm.editingItem( extend({}, item) )
    // m.route('/items/' + item.id)
  }

  ctrl.cancelEditing = function (e) {
    e.preventDefault();
    UserItems.vm.editingItem(null)
  }

	return ctrl
}

UserItems.view = function (ctrl) {
  return m('.items', [
    m('h1', {}, "This is the items page"),
    UserItems.vm.items().map(itemView), m('br'), m('br'),
    // m('form.addItem', {style: ctrl.isOwner()}, binds(ctrl.newItem)}, [
    m('form.addItem', binds(ctrl.newItem, { style: ctrl.isOwner() }), [
      m('textarea[name=content]', {value: ctrl.newItem.content}), m('br'),
      m('label', {}, "Item"), m('br'), m('br'),
      m('button', {onclick: ctrl.submit}, "Add Item")
      ]),
    m("a[href='/']", {config: m.route, onclick: ctrl.logOut}, "Log Out")
    ]
  )

  function itemView (item) {
    var editingItem = UserItems.vm.editingItem()
    
    if (editingItem && editingItem.id === item.id) {
      return editItemView(item)
    }
    else {
      return showItemView(item)
    }
  }

  function showItemView (item) {
    return m("div.item", {}, [
      item.content,
      m('br'),

      m('button', {onclick: ctrl.deleteItem.bind(null, item), style: ctrl.isOwner()}, "Delete"),
      m('button', {onclick: ctrl.editItem.bind(null, item), style: ctrl.isOwner()}, "Edit"),
      
      m('br'),
      m('br')
    ])
  }
  function editItemView (item) {
    return m('form.item.editing', binds(UserItems.vm.editingItem()), [
      "Editing Item " + item.content, m('br'),
      m('textarea[name=content]', {value: item.content}), m('br'),
      m('button', {onclick: ctrl.cancelEditing}, "Cancel"), m('br'),
      m('button', {onclick: ctrl.submitEditing}, "Submit Changes"),
      m('br'),
      m('br'),
    ])
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