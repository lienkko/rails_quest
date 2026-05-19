class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent.includes(:missions)
        .order(:codename)
        .map { |agent| "#{agent.codename}: #{agent.missions.order(:title).pluck(:title).join(', ')}" }
        .join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      Agent.left_joins(:missions)
        .group('agents.id')
        .select('agents.*, COUNT(missions.id) as mission_count')
        .sort_by { |a| [-a.mission_count, a.codename] }
        .map { |agent| "#{agent.codename} (#{agent.mission_count}): #{agent.missions.order(:title).pluck(:title).join(', ')}" }
        .join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.includes(:skills)
        .order(:codename)
        .map { |agent| "#{agent.codename}: #{agent.skills.order(:name).pluck(:name).join(', ')}" }
        .join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      Skill.left_joins(:agents)
        .group('skills.id')
        .select('skills.*, COUNT(agents.id) as agent_count')
        .sort_by { |s| [-s.agent_count, s.name] }
        .map do |skill|
          agents = skill.agents.order(:codename).pluck(:codename).join(', ')
          "#{skill.name} (#{skill.agent_count}): #{agents}"
        end
        .join("\n")
    end
  end
end
