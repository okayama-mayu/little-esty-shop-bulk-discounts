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
    .select('invoice_items.invoice_id as inv_id, sum(invoice_items.quantity * invoice_items.unit_price/100.0) as rev')
    .group('inv_id')[0]
    .rev 
    # revenue_generated = 0
    # invoice_items.each do |invoice_item|
    #   revenue_generated += (invoice_item.quantity * invoice_item.unit_price)
    # end
    # revenue_generated
  end

  def all_discounts
    test = invoice_items
    .joins(item: [{merchant: :discounts}])
    .where('quantity >= discounts.threshold')
    .select('invoice_items.*, max(discounts.discount) as max_disc, max(discounts.threshold) as count_threshold, max(discounts.id) as discount_id, max(discounts.discount) / 100  * invoice_items.quantity * invoice_items.unit_price/100.0 as item_discount')
    .group(:id)
    .order(:id)
  end

  def has_pending_invoice
    binding.pry 
  end
end