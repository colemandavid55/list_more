

var Welcome = {}


Welcome.controller = function () {
  var ctrl = {}
  return ctrl
}


Welcome.view = function (ctrl) {
  return m('.welcome', [
    m("a[href='/signup']", { config: m.route }, "Sign Up"),
    m('br'), m('br'),
    // anchor will go here instead of button
    m("a[href='/signin']", { config: m.route }, "Sign In")
  ])
}

