#-  -*- encoding : utf-8 -*- 
#- This Source Code Form is subject to the terms of the Mozilla Public
#- License, v. 2.0. If a copy of the MPL was not distributed with this
#- file, You can obtain one at http://mozilla.org/MPL/2.0/.

# -*- encoding : utf-8 -*-
module Weltel
	class UpdatesController < ApplicationController
		include Authentication::AuthenticatedController
		layout("private/application")

		#
		def show
			@update_complete = !File.exists?("/www/weltel/shared/deploy")
		end

		#
		def update
			script = Rails.root.to_s + "/script/update"
			out = Rails.root.to_s + "/tmp/update_out"
			err = Rails.root.to_s + "/tmp/update_err"
			pid = Kernel.spawn(script, {:out => out, :err => err})
			Process.detach(pid)
			logger.error(pid)
			FileUtils.touch("/www/weltel/shared/deploy")
			redirect_to(weltel_update_path)
		end
	end
end
