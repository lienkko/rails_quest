class AgentSkill < ApplicationRecord
  belongs_to :agent
  belongs_to :skill

  validates :agent_id, presence: true
  validates :skill_id, presence: true
  validates :agent_id, uniqueness: { scope: :skill_id }
end
