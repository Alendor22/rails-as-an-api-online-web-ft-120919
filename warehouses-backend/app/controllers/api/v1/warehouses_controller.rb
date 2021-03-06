class Api::V1::WarehousesController < ApplicationController
  before_action :set_warehouse, only: [:show, :update, :destroy]

  # GET /warehouses
  def index
    @warehouses = Warehouse.all
    render json: @warehouses, include: {
      items: {
          only: [:name, :sku, :item_type, :id]
        }
      },
      except: [:created_at, :updated_at]
  end
  #
  # @events.to_json(:include => {
  #                 :images => {
  #                   :only => [], :methods => [:public_url] }})

  # GET /warehouses/1
  def show
    render json: @warehouse
  end

  # POST /warehouses
  def create
    @warehouse = Warehouse.new(warehouse_params)

    if @warehouse.save
      render json: @warehouse, include: {
        items: {
            only: [:name, :sku, :item_type, :id]
          }
        },
        except: [:created_at, :updated_at],
        status: :created
    else
      render json: error_json(@warehouse), status: :unprocessable_entity
    end
  end

  # PATCH/PUT /warehouses/1
  def update
    if @warehouse.update(warehouse_params)
      render json: @warehouse
    else
      render json: error_json(@warehouse), status: :unprocessable_entity
    end
  end

  # DELETE /warehouses/1
  def destroy
    @warehouse.destroy

    render json: {
      message: "successfully destroyed #{@warehouse.name}"
      },
      status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_warehouse
      @warehouse = Warehouse.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def warehouse_params
      params.require(:warehouse).permit(:aisles, :name)
    end

    def error_json(warehouse)
      {
        error: warehouse.errors.full_messages.to_sentence
      }
    end
end
