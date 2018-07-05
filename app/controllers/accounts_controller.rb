class AccountsController < ApplicationController
  def new
    @new_account=Account.new()
  end
end
