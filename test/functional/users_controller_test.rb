require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "邮箱非法不能注册" do
    get :signup_email
    assert_response :success
    email_1 = "qdclw1986sdsina.cn"
    email_2 = ""
    email_3 = "qdclw1986@sinacn"
    assert_difference("User.count",0) do
      post :signup_email_action,:user=>{:email=>email_1}
      post :signup_email_action,:user=>{:email=>email_2}
      post :signup_email_action,:user=>{:email=>email_3}
    end
  end
  
  test "普通用户注册流程" do
    get :signup_email
    assert_response :success
    email = "qdclw1986@sina.cn"
    assert_difference("User.count",1) do
      post :signup_email_action,:user=>{:email=>email}
    end
    user = User.last
    assert_equal user.email,email
    activation_code = user.activation_code
    assert !activation_code.blank?

    get :active_form,:code=>activation_code
    assert_response :success
    assert_difference("User.count",0) do
      put :active,:user=>{:password=>"123456",:password_confirmation=>"123456",:name=>"cheng",:email=>email}
    end
    user.reload
    assert user.activation_code.blank?
    assert !user.activated_at.blank?
    assert !user.hashed_password.blank?
    assert !user.salt.blank?

    # 激活之后，再去发送邮件 显示此邮箱已经激活
  end

  test "邮箱正确，用户名不正确，零次密码不一样 激活失败" do
    get :signup_email
    assert_response :success
    email = "qdclw1986@sina.cn"
    assert_difference("User.count",1) do
      post :signup_email_action,:user=>{:email=>email}
    end
    user = User.last
    assert_equal user.email,email
    activation_code = user.activation_code
    assert !activation_code.blank?

    get :active_form,:code=>activation_code
    assert_response :success
    assert_difference("User.count",0) do
      put :active,:user=>{:password=>"123456",:password_confirmation=>"123456",:name=>"",:email=>email}
    end
    user.reload
    assert !user.activation_code.blank?
    assert user.activated_at.blank?
    assert_difference("User.count",0) do
      put :active,:user=>{:password=>"12asdf3456",:password_confirmation=>"123456",:name=>"用户名正确",:email=>email}
    end
    user.reload
    assert !user.activation_code.blank?
    assert user.activated_at.blank?
  end

end
