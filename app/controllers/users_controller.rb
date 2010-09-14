class UsersController < ApplicationController
  before_filter :login_required,:only => [:edit,:update]

  include SessionsMethods

  def new
    online_key=session[:online_key]
    flash_info = session['flash']
    reset_session
    session[:online_key]=online_key
    session['flash']=flash_info
    @user = User.new
    render :layout=>'auth',:template=>'/auth/signup.haml'
  end

  def create
    # 出于安全性考虑，新用户注册时销毁cookies令牌
    destroy_cookie_token
    @user = User.new(params[:user])
    @user = User.create_user_only_email(@user)
    if @user.errors.blank?
      @user.send_activation_mail
      flash[:success] = "邮件已经发送，请查收"
      return redirect_to :action=>:new
    end
    flash[:error] = @user.errors.first[1]
    redirect_to :action=>:new
  end

  def login_after_create(user)
    self.current_user=user
    after_logged_in()
    flash[:success] = '注册成功，您现在已经是 MindPin ei 的用户'
    redirect_to '/welcome'
  end

  def show
    @user=User.find(params[:id])
    if logged_in? && @user == current_user
      @user_shares = @user.my_and_contacting_shares.paginate(:page => params[:page] ,:per_page=>30 )
    else
      @user_shares = @user.shares.paginate(:page => params[:page] ,:per_page=>30 )
    end
    respond_to do |format|
      format.html {} # 这一行必须有而且必须在下面这行之前，否则IE里会出问题
      format.xml {render :xml=>@user.to_xml(:only=>[:id,:name,:created_at],:methods=>:logo)}
    end
  end

  # 忘记密码时，填写邮件的表单
  def forgot_password_form
    render :layout=>'auth',:template=>'auth/forgot_password_form'
  end

  # 根据邮件地址发送邮件
  def forgot_password
    _deal_forgot_password(params[:email])
    redirect_to("/forgot_password_form")
  end
  
  def _deal_forgot_password(email)
    return flash[:error] = "请正确填写邮箱，我们才能帮你重设密码。。" if email.blank?
    
    user = User.find_by_email(email)
    return flash[:error] = "对不起，不存在邮箱为 #{params[:email]} 的用户。" if user.blank?
    
    user.forgot_password
    flash[:success] = "包含重设密码链接的邮件已经发送到邮箱 #{params[:email]}，请留意。"
  end

  # 重置密码的表单
  def reset_password
    @user = User.find_by_reset_password_code(params[:pw_code])
    return redirect_to("/") if @user.blank?
  end

  # 重置密码
  def change_password
    @user = User.find_by_reset_password_code(params[:pw_code])
    return redirect_to("/") if @user.blank?

    pu = params[:user]

    if !pu[:password].blank? && pu[:password] == pu[:password_confirmation]
      if @user.update_attributes(:password=>pu[:password],:reset_password_code=>nil)
        flash.now[:success] = "已成功为 #{@user.name} 重设密码"
        render :template=>"users/reset_password_success"
        return
      end
    end
    @user.errors.add(:password,"密码不能为空") if params[:user][:password].blank?
    @user.errors.add(:password_confirmation,"密码和确认密码必须相同") if params[:user][:password] != params[:user][:password_confirmation]
    flash.now[:error] = @user.errors.first[1] if !@user.errors.blank?
    render :template=>"users/reset_password"
  end

  # 注册并填写信息界面
  def active_form
    @user = User.find_by_activation_code(params[:code])
    if @user.blank?
      return render :layout=>"auth",:text=>"激活码无效，或者此邮箱已经激活"
    end
    render :layout=>'auth',:template=>'/auth/parts/signup_info_form'
  end

  # 激活
  def active
    @user = User.new(params[:user])
    @user.activated_at = Time.now
    if @user.valid?
      u = User.find_by_email(params[:user][:email])
      u.activate(@user)
      return redirect_to "/"
    end
    flash.now[:error] = @user.errors.first[1]
    return render :layout=>'auth',:template=>'/auth/parts/signup_info_form'
  end

  private
  def is_current_user?
    session[:user_id].to_s==params[:id]
  end

end
