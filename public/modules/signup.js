  var SignUp = {}


  SignUp.controller = function () {
    var ctrl = {}
    return ctrl
  }


  SignUp.view = function (ctrl) {
    return m('.signup', [
      m('button', { onclick: ctrl.signup }, "Sign Up"),
      m('button', { onclick: ctrl.login }, "Log In")
    ])
  }
