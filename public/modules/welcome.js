

  var Welcome = {}


  Welcome.controller = function () {
    var ctrl = {}
    return ctrl
  }


  Welcome.view = function (ctrl) {
    return m('.welcome', [
      m('button', { onclick: ctrl.signup }, "Sign Up"),
      m('button', { onclick: ctrl.login }, "Log In")
    ])
  }

