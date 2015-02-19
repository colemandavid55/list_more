var UserLists = {}

UserLists.vm = {
  lists: m.prop([]),
  userLists: m.prop([]),
  sharedLists: m.prop([]),
  userId: m.prop(),

  editingList: m.prop(null),
  sharingList: m.prop(null),

  sync: function () {
    var vm = UserLists.vm
    m.request({ method: "GET", url: "/users/" + m.route.param('id') + "/lists" }).then(function (response) {
      console.log(response);
      vm.userLists(response.user_lists)
      vm.sharedLists(response.shared_lists)

    })
  }
}

UserLists.controller = function () {
  console.log("UserLists controller")
  // debugger
  var ctrl = {
    newList: {
      name: '',
      user_id: UserLists.vm.userId()
    }
  }

  var vm = UserLists.vm
  vm.userId( m.route.param("id") )
  vm.sync()
  // if (!App.vm.user()) {
  //   m.route('/')
  // }


  ctrl.submit = function (e) {
    e.preventDefault();
    var data = {}
    extend(ctrl.newList, {'token': App.vm.user().token})
    extend(ctrl.newList, {'user_id': vm.userId()})
    m.request({method: "POST", url: "users/" + vm.userId() + "/lists", data: ctrl.newList}).then(function () {
      vm.sync()
      m.route("/users/" + vm.userId())
    });

    console.log("list add clicked")
  }

  ctrl.logOut = function (e) {
    console.log("logout selected")
    localStorage.clear()
    m.route('/')
  }

  ctrl.isOwner = function () {
    response = (App.vm.user().id == vm.userId()) ?
      "none" : "display:none";
    return response
  }

  ctrl.listOwner = function (list) {
    if (m.route.param('id') != App.vm.user().id) {
      return "display:none"
    }

    response = (App.vm.user().id == list.user_id) ?
      "none" : "display:none";
    return response
  }

  ctrl.deleteList = function (list, e) {
    e.preventDefault();
    console.log("list:",list)

    // Find and remove deleted item
    
    var newUserListArray = Array.reject(vm.userLists(), function (l) {
      return l.id === list.id
    })
    var newSharedListArray = Array.reject(vm.sharedLists(), function (l) {
      return l.id === list.id
    })
    vm.userLists(newUserListArray)
    vm.sharedLists(newSharedListArray)

    extend(list, {'token': App.vm.user().token})

    m.request({method: "DELETE", url: "/lists/" + list.id, data: list, background: true})//.then(function () {
    //   vm.items = m.request({method: "GET", url: "/lists/" + vm.listId()});
    //   m.route("/lists/" + vm.listId())
    // })

    console.log("item delete clicked")
  }

  ctrl.submitEditing = function (e) {
    var list = vm.editingList();
    e.preventDefault();
    var newArrayOne = vm.userLists().forEach(function (list_iterator) {
      if (list.id == list_iterator.id) {
        list_iterator['name'] = list.name
      }
    });
    var newArrayTwo = vm.sharedLists().forEach(function (list_iterator) {
      if (list.id == list_iterator.id) {
        list_iterator['name'] = list.name
      }
    });

    extend(list, {'token': App.vm.user().token})

    m.request({method: "PUT", url: "/lists/" + list.id, data: list, background: true})
    vm.editingList(null)
  }

  ctrl.submitSharing = function (e) {
    var list = vm.sharingList();
    e.preventDefault();
    extend(list, {'token': App.vm.user().token})
    console.log("object to be shared/sent to server", list)
    // m.request to share list in background
    data = {}
    if (list.user_id && list.list_id) {
      data.user_id = list.user_id
      data.list_id = list.list_id
      data.token = list.token
      m.request({method: "POST", url: "/share_list", data: data, background: true})
    }
    vm.sharingList(null)
  }

  ctrl.editList = function (list, e) {
    e.preventDefault();
    console.log("Attempting to edit", list, '/lists/' + list.id)
    UserLists.vm.editingList( extend({}, list) )
    // m.route('/items/' + item.id)
  }

  ctrl.cancelEditing = function (e) {
    e.preventDefault();
    vm.editingList(null)
  }

  ctrl.cancelSharing = function (e) {
    e.preventDefault();
    vm.sharingList(null)
  }

  ctrl.shareList = function(list, e) {
    var listObj = extend({}, list)
    e.preventDefault();
    listObj.user_id = null
    UserLists.vm.sharingList( extend({}, listObj) )
  }

  ctrl.selectList = function (userId, listId) {
    console.log("list selected");
    console.log(userId);
    console.log(listId);
    list_data = {
      'user_id': userId,
      'id': listId,
      'token': App.vm.user().token
    }
    m.request({method: "GET", url: "/lists/" + listId, data: list_data}).then(function (response) {
      UserItems.vm.userId(userId);
      UserItems.vm.listId(listId); 
    })
    return true
  }

  
	return ctrl
}

UserLists.view = function (ctrl) {
  return m('.lists', [
    m('div', {}, "This is the user's lists page"), m('br'),
    UserLists.vm.userLists().map(listView), m('br'),
    m('div', {}, "These lists have been shared with this user"), m('br'),
    UserLists.vm.sharedLists().map(listView), m('br'), m('br'),
    m('form.addList', binds(ctrl.newList, { style: ctrl.isOwner() }), [
      m('input[name=name]', {value: ctrl.newList.name}), m('br'),
      m('label', {}, "Name"), m('br'), m('br'),
      m('button', {onclick: ctrl.submit}, "Add List")
      ]),
    m("a[href='/']", {config: m.route, onclick: App.logOut}, "Log Out")
    ]
  )

  function listView (list) {
    var editingList = UserLists.vm.editingList(),
    sharingList = UserLists.vm.sharingList();

    if (sharingList && sharingList.id == list.id) {
      return shareListView(list)

    } else if (editingList && editingList.id === list.id) {
      return editListView(list)
    }

    else {
      return showListView(list)
    }
  }


  function showListView (list) {
    return m('div.showList', {},
      [m("a[href='/users/" + list.user_id +"/lists/" + list.id + "']", 
      {config: m.route, onclick: ctrl.selectList.bind(null, list.user_id, list.id)}, 
      list.name),
      m('br'),

      m('button', {onclick: ctrl.deleteList.bind(null, list), style: ctrl.isOwner()}, "Delete"),
      m('button', {onclick: ctrl.editList.bind(null, list), style: ctrl.isOwner()}, "Edit"),
      m('button', {onclick: ctrl.shareList.bind(null, list), style: ctrl.listOwner.bind(null, list)()}, "Share"),
      
      m('br'),
      m('br')]
    )
  }


  function editListView (list) {
    return m('form.list.editing', binds(UserLists.vm.editingList()), [
      "Editing List " + list.name, m('br'),
      m('textarea[name=name]', {value: list.name}), m('br'),
      m('button', {onclick: ctrl.cancelEditing}, "Cancel"), m('br'),
      m('button', {onclick: ctrl.submitEditing}, "Submit Changes"),
      m('br'),
      m('br'),
    ])
  }

  function shareListView (list) {
    extend(UserLists.vm.sharingList(), {'list_id': list.id})
    var userList = App.vm.users().map(function (user) {
      if (user.id != App.vm.user().id) {
        return m('option', {value: user.id}, user.username)
      }
    });
    userList.unshift(m('option', {value: null}, " "));
    return m('form.list.sharing', binds(UserLists.vm.sharingList()), [
      "Sharing List " + list.name, m('br'),
      m('select', { name: 'user_id' }, userList),
      m('br'),
      m('button', {onclick: ctrl.cancelSharing}, "Cancel"), m('br'),
      m('button', {onclick: ctrl.submitSharing}, "Share List"),
      m('br'),
      m('br')


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