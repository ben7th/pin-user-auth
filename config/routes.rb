ActionController::Routing::Routes.draw do |map|
  map.root :controller=>'index'
  #  map.root :controller=>'index',:action=>'updating'
  map.welcome '/welcome',:controller=>'index',:action=>'welcome'
  # ---------------- 用户认证相关 -----------
  map.login_ajax '/login_ajax',:controller=>'sessions',:action=>'new_ajax'
  map.login_fbox '/login_fbox',:controller=>'sessions',:action=>'login_fbox'
  map.login_fbox_create '/login_fbox_create',:controller=>'sessions',:action=>'login_fbox_create'
  map.login '/login',:controller=>'sessions',:action=>'new'
  map.logout '/logout',:controller=>'sessions',:action=>'destroy'
  map.signup '/signup',:controller=>'users',:action=>'new'

  map.resource :session

  map.resources :users,:member=>{
    :logo=>:put,:edit_logo=>:get
  },:collection=>{:send_activation_mail=>:get}

  # 激活用户
  map.activate '/activate/:activation_code',:controller=>'users',:action=>'activate'
  # 忘记密码
  map.forgot_password_form '/forgot_password_form',:controller=>'users',:action=>'forgot_password_form'
  map.forgot_password '/forgot_password',:controller=>'users',:action=>'forgot_password'
  # 重设密码
  map.reset_password '/reset_password/:pw_code',:controller=>'users',:action=>'reset_password'
  map.change_password '/change_password/:pw_code',:controller=>'users',:action=>'change_password'


  # ----------------- 设置相关 ----------
  map.resources :settings
  map.resource :preference,:collection=>{:selector=>:get,:ajax_theme_change=>:get}
end
