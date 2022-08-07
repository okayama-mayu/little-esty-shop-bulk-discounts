class Invoice < ApplicationRecord
  validates_presence_of :status, presence: true

  belongs_to :customer
  
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  enum status: { "in progress": 0, "completed": 1, "cancelled": 2 }


  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not(invoice_items: {status: 'shipped'})
    .distinct
    .order("created_at")
  end

  def total_revenue
    invoice_items
    .joins(item: :merchant)
    .select('invoice_items.invoice_id as inv_id, sum(invoice_items.quantity * invoice_items.unit_price) as rev')
    .group('inv_id')[0]
    .rev 
    # revenue_generated = 0
    # invoice_items.each do |invoice_item|
    #   revenue_generated += (invoice_item.quantity * invoice_item.unit_price)
    # end
    # revenue_generated
  end

  def total_discounts
    binding.pry 
    test = invoice_items
    .joins(item: [{merchant: :discounts}])
    .where('quantity >= discounts.threshold')
    .select('max(discounts.discount) as max_disc, max(discounts.discount) / 100  * invoice_items.quantity * invoice_items.unit_price as item_discount')
    .group(:id)
  end
end