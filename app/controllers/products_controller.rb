class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy new_movement create_movement ]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
    @product = Product.find(params[:id])
    @stock_movements = @product.stock_movements.order(created_at: :desc)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "El producto fue creado con éxito." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "El producto fue actualizado con éxito.", status: :see_other }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy!

    respond_to do |format|
      format.html { redirect_to products_path, notice: "El producto fue eliminado con éxito.", status: :see_other }
      format.json { head :no_content }
    end
  end

  # GET /products/:id/new_movement
  def new_movement
    # AQUÍ ESTABA EL DETALLE: Primero creamos el objeto para el formulario
    @stock_movement = @product.stock_movements.build
    @stock_movement.movement_type = params[:type] if params[:type].present?
  end

  # POST /products/:id/create_movement
  def create_movement
    @stock_movement = @product.stock_movements.build(stock_movement_params)

    if @stock_movement.save
      redirect_to @product, notice: "El movimiento de stock fue registrado con éxito."
    else
      render :new_movement, status: :unprocessable_entity
    end
  end

  private

  def stock_movement_params
    params.require(:stock_movement).permit(:quantity, :movement_type, :reason)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params.expect(:id))
  end

  def product_params
    params.require(:product).permit(
      :name, :sku, :description, :stock_current, :stock_minimum,
      :category_id, :warehouse_id, :location_detail,
      :price_cost, :price_sale, :weight
    )
end
end