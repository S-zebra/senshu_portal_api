class TokensController < ApplicationController
  before_action :confirm_login

  def index
    @tokens = Token.where(account: @account) #find_byじゃないのね！
  end

  def create
    @new_rand_str = SecureRandom::base58
    @account = Account.find(session[:uid])
    @new_token = Token.new(account: @account, token: @new_rand_str, available: true)
    if @new_token.save
      flash[:notice] = "新しいトークンを作成しました。"
      redirect_to :tokens
    end
  end

  def destroy
    @target_token = Token.find(params[:id])
    @target_token.available = false
    if @target_token.save
      flash[:notice] = "トークンは無効になりました。"
      redirect_to :tokens
    end
  end

  private

  def confirm_login
    if session[:uid] && Account.exists?(id: session[:uid])
      @account = Account.find(session[:uid])
    else
      flash[:alert] = "不正な画面遷移です。もう一度やり直してください。"
      session.delete(:uid)
      redirect_to :root and return
    end
  end
end
