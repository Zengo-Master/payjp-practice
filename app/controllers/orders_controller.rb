class OrdersController < ApplicationController

  def index
    @order = Order.new
  end

  def create
    # トークンは保存しないので含めない
    @order = Order.new(order_params)
    # 正常に保存できるか？
    if @order.valid?
      pay_item
      @order.save
      return redirect_to root_path # 保存できたら元の購入画面へ
    else
      render 'index' # 元の購入画面からやり直し
    end
  end

  private

  # price（金額）とtoken（カード情報）のみ受け取りを許可
  def order_params
    params.permit(:price, :token) # card.jsのL21で定義したname属性
  end

  def pay_item
    Payjp.api_key = ENV["PAYJP_SECRET_KEY"] # PAY.JPテスト秘密鍵（コードに直接記述しない）
    # 支払情報を生成
    Payjp::Charge.create(
      amount: order_params[:price],  # 商品の値段
      card: params[:token],    # カードトークン
      currency:'jpy'                 # 通貨の種類(日本円)
    )
  end

end