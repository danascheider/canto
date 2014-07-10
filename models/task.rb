class Task < ActiveRecord::Base

  belongs_to :task_list, foreign_key: :task_list_id
  acts_as_list scope: :task_list

  scope :complete, -> { where(complete: true) }
  scope :incomplete, -> { where(complete: false) }

  validates :title, presence: true, exclusion: { in: %w(nil null)}
  before_save :set_complete

  def self.create!(opts)
    if opts[:complete] == true
      if Task.complete
        Task.complete.each {|task| task.increment_position }
        opts[:position] = (Task.count + 1) - Task.complete.count
      else
        opts[:position] = Task.count
      end
    end
    super
  end

  def update!(opts)
    if opts[:complete] == true && self.complete == false
      opts[:position] = Task.count
    elsif opts[:complete] == false && self.complete == true
      opts[:position] = 1
    end
    super
  end

  def incomplete?
    !self.complete
  end

  def to_hash
    { id: self.id,
      position: self.position,
      title: self.title, 
      complete: self.complete, 
      created_at: self.created_at,
      updated_at: self.updated_at
    }
  end

  def self.first_complete
    self.complete.pluck(:position).sort[0] || Task.count
  end

  private
    def set_complete
      true if self.complete ||= false
    end

    def set_position
      #
    end
end