var SignUp = {}


SignUp.controller = function () {
  var ctrl = {}

  ctrl.user = {
    username: '',
    password: '',
    password_conf: ''
  }

  ctrl.submit = function (e) {
    e.preventDefault()
    console.log("sign up submitted", ctrl.user)
    m.request({method: "POST", url: "/signup", data: ctrl.user}).then(
      function (response) {
        console.log("Success",response)
        m.route("/user_home")
      },
      function (error) {
        console.log("Error",error)
        m.route("/")
      }
    )


  }

  return ctrl
}


SignUp.view = function (ctrl) {
  return m('form.signup', binds(ctrl.user), [
    m('input[name=username]', {value: ctrl.user.username}),
    m('label', {}, "Username"), m('br'), m('br'),
    m('input[name=password]', {value: ctrl.user.password}),
    m('label', {}, "Password"),m('br'), m('br'),
    m('input[name=password_conf]', {value: ctrl.user.password_conf}),
    m('label', {}, "Password Confirmation"), m('br'), m('br'),
    m('button', {onclick: ctrl.submit}, "Sign Up")
  ]);

  function binds(data) {
    return {onchange: function(e) {
      data[e.target.name] = e.target.value;
    }};
  };
}



