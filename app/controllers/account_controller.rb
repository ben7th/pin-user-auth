class AccountController < ActionController::Base
  before_filter :login_required
  # 基本信息
  def base;end
  # 头像
  def avatared;end
  # 邮箱
  def email;end

  # 修改基本信息
  def base_submit
    @user= current_user
    s1=params[:user]
    @user.password=s1[:password]
    @user.password_confirmation=s1[:password_confirmation]
    @user.update_attributes(s1)
    if @user.save
      flash[:notice]="用户#{@user.name}的信息已经成功修改"
    else
      (@user.errors).each do |*error|
        flash[:error]=error*' '
      end
    end
    redirect_to :action=>:base
#    responds_to_parent do
#      render_ui do |ui|
#        ui.cell @user,:partial=>"users/cell_edit",:position=>:paper
#        ui.page << %`
#              $$("#logo_user_#{@user.id}").each(function(logo){
#                logo.src = "#{@user.logo.url}";
#              })
#              $$("#logo_user_#{@user.id}_tiny").each(function(logo){
#                logo.src = "#{@user.logo.url(:tiny)}";
#              })
        #`
#      end
#    end
  end
end