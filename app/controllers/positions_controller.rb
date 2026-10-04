class PositionsController < ApplicationController
  before_action :set_position, only: %i[edit update destroy]

  # GET /positions/new
  def new
    @position = Position.new
  end

  # GET /positions/1/edit
  def edit
  end

  # POST /positions or /positions.json
  def create
    @position = Position.new(position_params)

    respond_to do |format|
      if @position.save
        format.html { redirect_to settings_path, notice: "Position was successfully created." }
        format.json { render :show, status: :created, location: @position }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @position.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /positions/1 or /positions/1.json
  def update
    respond_to do |format|
      if @position.update(position_params)
        format.html { redirect_to settings_path, notice: "Position was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @position }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @position.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /positions/1 or /positions/1.json
  def destroy
    @position.destroy!

    respond_to do |format|
      format.html { redirect_to settings_path, notice: "Position was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = Position.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def position_params
      params.expect(position: [ :title, :description ])
    end
end
