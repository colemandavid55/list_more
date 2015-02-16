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
    m.request({method: "POST", url: "/signin", data: ctrl.user}).then(
      function (response) {
        // User signed in!
        // switch pages with m.route and send them somewhere else
        console.log("Successful",response)
        // localStorage.setItem('token', response.token)
        // localStorage.setItem('currentUserName', response.user.username)
        // localStorage.setItem('currentUserId', response.user.id)
        App.signIn({
          token: response.token,
          username: response.user.username,
          id: response.user.id
        })
        m.route('/user_home')
      },
      function (error) {
        console.log("Error",error)
        // Sign in failed
        m.route('/')
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