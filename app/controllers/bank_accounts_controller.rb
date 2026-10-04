class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[edit update destroy]

  def new
    @bank_account = BankAccount.new
  end

  def create
    @bank_account = BankAccount.new(bank_account_params)
    if @bank_account.save
      redirect_to settings_path, notice: "Cuenta bancaria creada exitosamente."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @bank_account.update(bank_account_params)
      redirect_to settings_path, notice: "Cuenta bancaria actualizada exitosamente."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @bank_account.destroy
    redirect_to settings_path, notice: "Cuenta bancaria eliminada.", status: :see_other
  end

  private

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(:institution, :currency, :account_number, :email)
  end
end
