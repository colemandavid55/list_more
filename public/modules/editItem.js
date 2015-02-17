var EditItem = {}

EditItem.vm = {
  item: m.prop(null)
}

EditItem.controller = function () {
	var ctrl = {
    item: {
      content: EditItem.vm.item().content,
      user_id: EditItem.vm.item().user_id,
      list_id: EditItem.vm.item().list_id
    }
  }
  var itemId = m.route.param('id')
  // m.request({ method: 'GET', url: "/items/"+itemId }).then()

  ctrl.submit = function (item, e) {
    e.preventDefault()
    extend(item, {'token': App.vm.user().token})

    m.request({method: "PUT", url: "/items/" + m.route.param('id'), background: true})
    console.log("Edit item submitted")
    m.route("/users/" + ctrl.item.user_id + "/lists/" + ctrl.item.list_id)

  }
	return ctrl
}

EditItem.view = function (ctrl) {
	return m('form.editItem', binds(ctrl.item), [
      m("textarea[name=content]", {value: ctrl.item.content}),
      m("label", {}, "New Content"), m('br'),
      m('button', {onclick: ctrl.submit.bind(null, ctrl.item)}, "Submit Change")
      ])

  function binds(targetObj, attrs) {
    attrs || (attrs = {})
    return extend(attrs, {
      onchange: function(e) {
        targetObj[e.target.name] = e.target.value;
      }
    });
  };

}

