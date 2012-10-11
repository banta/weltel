#-  -*- encoding : utf-8 -*- 
#- This Source Code Form is subject to the terms of the Mozilla Public
#- License, v. 2.0. If a copy of the MPL was not distributed with this
#- file, You can obtain one at http://mozilla.org/MPL/2.0/.

# -*- encoding : utf-8 -*-
require "spec_helper"

describe Weltel::TasksController do
	#
	it "creates records" do
		create(:message_template, :name => :checkup)
		create(:patient)

		get :create_records
	end

	#
	it "updates records" do
		create(:record)

		get :update_records
	end
end
