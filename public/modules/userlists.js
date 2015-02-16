var UserLists = {}

UserLists.vm = {
  lists: m.prop([]),
  userLists: m.prop([]),
  sharedLists: m.prop([]),
  userId: m.prop(),
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
  var ctrl = {
    list: {
      name: '',
      user_id: UserLists.vm.userId()
    }
  }

  var vm = UserLists.vm
  vm.userId( m.route.param("id") )
  vm.sync()

  ctrl.submit = function (e) {
    e.preventDefault();
    m.request({method: "POST", url: "users/" + vm.userId() + "/lists", data: ctrl.list}).then(function () {
      vm.sync()
      m.route("/users/" + vm.userId())
    });

    console.log("list add clicked")
  }

  ctrl.logOut = function (e) {
    console.log("logout selected")
    localStorage.clear()
  }

  ctrl.isOwner = function () {
    response = (localStorage.getItem('currentUserId') == vm.userId()) ?
      "none" : "display:none";
    return response
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
    m('div', {}, "This is the lists page"),
    UserLists.vm.userLists().map(listView),
    UserLists.vm.sharedLists().map(listView), m('br'), m('br'),
    m('form.addList', binds(ctrl.list, { style: ctrl.isOwner() }), [
      m('input[name=name]', {value: ctrl.list.name}),
      m('label', {}, "Name"), m('br'), m('br'),
      m('button', {onclick: ctrl.submit}, "Add List")
      ]),
    m("a[href='/']", {config: m.route, onclick: ctrl.logOut}, "Log Out")
    ]
  )

  function listView (list) {
    return [m("a[href='/users/'" + list.user_id +"/lists/" + list.id + "']", {config: m.route, onclick: ctrl.selectList.bind(null, list.user_id, list.id)}, list.name),
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