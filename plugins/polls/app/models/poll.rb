class Poll < ActiveRecord::Base
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_user_id'
  has_many :poll_votes, dependent: :destroy

  serialize :choices, Array
  serialize :requied_ordergroup_custom_fields, Array
  serialize :requied_user_custom_fields, Array
  enum voting_method: { event: 0, single_select: 1, multi_select: 2, points: 3, resistance_points: 4 }

  include DateTimeAttributeValidate
  date_time_attribute :starts, :ends

  def available_points
    return [] if min_points.nil? || max_points.nil?
    min_points..max_points
  end

  def user_can_edit?(user)
    created_by == user || user.role_admin?
  end

  def user_can_vote?(user)
    Ordergroup.custom_fields.each do |field|
      name = field[:name]
      next unless requied_ordergroup_custom_fields.include? name
      return false if user.ordergroup.nil? || user.ordergroup.settings.custom_fields[name].blank?
    end

    User.custom_fields.each do |field|
      name = field[:name]
      next unless requied_user_custom_fields.include? name
      return false if user.settings.custom_fields[name].blank?
    end

    true
  end
end
