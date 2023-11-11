# typed: false
# frozen_string_literal: true

class Notification < ApplicationRecord
  key :ntf

  CHANNELS = %w[email web].freeze

  # Categories are used to group notifications together, like `user`
  attribute :category, :string
  # Types are used to determine a notification's subcategory, like `welcome`.
  # Together, the category and type determine the template's full path, like
  # `user/welcome`.
  attribute :type, :string
  attribute :title, :string
  attribute :body, :string
  # Summaries are used to generate a preview of the notification
  attribute :summary, :string
  attribute :channels, :string, array: true, default: CHANNELS
  attribute :data, :jsonb, default: {}
  attribute :url, :string

  belongs_to :account
  belongs_to :subject, polymorphic: true, optional: true
  belongs_to :template, class_name: 'Notification::Template', optional: true

  has_many :deliveries, dependent: :destroy
  has_many :users, -> { distinct }, through: :deliveries

  validates :category, :type, :title, :body, :summary, :channels, presence: true
  validates :channels, inclusion: { in: CHANNELS }

  inquirer :category
  inquirer :type

  before_create :assign_attributes_from_template

  sig { returns Notification }
  def assign_attributes_from_template # rubocop:disable Metrics/AbcSize
    return self unless template

    self.category ||= template.category
    self.type ||= template.type

    self.body ||= template.body
    self.title ||= template.title
    self.summary ||= template.summary

    self
  end
end
