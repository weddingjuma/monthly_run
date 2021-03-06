class Payment < ActiveRecord::Base
  belongs_to :lease
  belongs_to :admin_user
  belongs_to :charge

  by_star_field :applicable_period

  default_scope { order(created_at: :desc) }

  monetize :amount_due_in_cents, allow_nil: false
  monetize :amount_collected_in_cents, allow_nil: false

  delegate :formatted_address, to: :lease
  delegate :charges, to: :lease, prefix: :lease
  delegate :unit, to: :lease
  delegate :formatted_address, to: :unit, prefix: true
  delegate :name, to: :charge, prefix: true

  validates :admin_user, :applicable_period, presence: true

  scope :for_month, ->(date=Time.zone.now.to_date) { 
    date = date.is_a?(String) ? Chronic.parse(date.humanize) : date
    by_month(date.month, year: date.year) 
  }


  def self.for_period(date)
    for_month(date).first
  end
  
end
