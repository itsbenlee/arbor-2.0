module ArborReloaded
  class SprintsController < ApplicationController
    include ArborReloaded::Concerns::ActAsProjectResource

    before_action :load_project

    def create
      @project.sprints.create
      @release_plan = @project.reload.to_release_plan
    end
  end
end
