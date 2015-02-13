var SignIn = {}

SignIn.controller = function () {
	var ctrl = {}

  ctrl.user = {
    username: '',
    password: ''
  }

  ctrl.submit = function (e) {
    e.preventDefault()
    console.log('sign in submitted', ctrl.user)
    m.request({method: "POST", url: "/signin"}).then(
      function (response) {
        // User signed in!
        // switch pages with m.route and send them somewhere else
        console.log("Success",response)
      },
      function (a,b,c) {
        console.log("Error",a,b,c)
        // Sign in failed
      }
    )
  }

  return ctrl
}

SignIn.view = function (ctrl) {
  return m('form.signin', binds(ctrl.user), [
    m('input[name=username]', {value: ctrl.user.username}),
    m('label', {}, "Username"), m('br'), m('br'),
    m('input[name=password]', {value: ctrl.user.password}),
    m('label', {}, "Password"), m('br'), m('br'),
    m('button', {onclick: ctrl.submit}, "Sign In")
  ]);

  function binds(data) {
    return {
      onchange: function(e) {
        data[e.target.name] = e.target.value;
      }
    };
  };
}