class Merchant < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :status 
  enum status: {"disabled": 0, "enabled": 1}

  has_many :items, dependent: :destroy
  has_many :discounts, dependent: :destroy
  has_many :invoice_items, through: :items 
  has_many :invoices, through: :invoice_items
  has_many :customers, -> { distinct }, through: :invoices
  has_many :transactions, through: :invoices
  # when it grabs customers, it's joining on both invoices and transactions 
  # could do left join if doing SQL? 

  # scope :distinct_customers, -> {select("distinct id").select("id")}
  # setting a method so you can have distinct customers with distinct ids 
  # creates subsets of data 
  # same thing as defining a method that pulls distinct customers 

  def top_5
    # test = customers
    # .joins(invoices: :transactions)
    # .where(transactions: { result: 'success'})
    # .select('customers.*, count(transactions.result) as transaction_total')
    # .group(:id)
    # binding.pry 
    customers
    .joins(invoices: :transactions)
    .where(transactions: { result: :success })
    .select('customers.*, count(transactions.result) as success_count')
    .group(:id)
    .order('success_count desc')
    .limit(5)
  end

  def unshipped_items
    # items.joins(:invoice_items).where(invoice_items: { status: 'packaged' }).select('items.*, invoice_items.invoice_id as invoice_id').order(:invoice_id)
    # binding.pry 
    test = invoice_items.joins(:invoice).where(status: 1).order("invoices.created_at")
    # binding.pry 
  end
  
  def get_invoice_items(invoice_id)
    InvoiceItem.where(item_id: items.pluck(:id), invoice_id: invoice_id)
  end

  def total_revenue(invoice_id)
    get_invoice_items(invoice_id).sum("quantity * unit_price")
  end

  def self.enabled_merchants
    Merchant.where("status = ?", 1).order(:created_at)
  end

  def self.disabled_merchants
    Merchant.where("status = ?", 0).order(:created_at)
  end

  def top_5_revenue_generated
    items
    .joins(:transactions)
    .where(transactions: {result: 'success'})
    .group(:id)
    .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
    .order('revenue desc')
    .limit(5)
  end

  def self.top_5_merchants
    self.all
    .joins(:transactions)
    .where(transactions: {result: 'success'})
    .group(:id)
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total')
    .order('total desc')
    .limit(5)
  end

  def best_day
    self.invoices
    .select("invoices.id, invoices.created_at as date, sum(invoice_items.quantity * invoice_items.unit_price) as invoice_revenue")
    .group(:id)
    .order("invoice_revenue desc")
    .limit(1)
    .first
    .date 
  end
end